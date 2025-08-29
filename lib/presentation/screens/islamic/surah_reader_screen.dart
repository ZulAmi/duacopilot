import 'dart:async';
import 'dart:io' show File, Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../../data/datasources/quran_api_service.dart';
import '../../widgets/revolutionary_components.dart';

/// Dedicated reader screen for a Surah with verse transliteration support.
class SurahReaderScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahEnglishName;
  final String surahArabicName;
  final int? initialVerse;

  const SurahReaderScreen({
    super.key,
    required this.surahNumber,
    required this.surahEnglishName,
    required this.surahArabicName,
    this.initialVerse,
  });

  @override
  ConsumerState<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends ConsumerState<SurahReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  final QuranApiService _quranApi = QuranApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  ConcatenatingAudioSource? _ayahPlaylist; // per-ayah playlist
  bool _usingPlaylist = false;
  bool _fullSurahCached = false; // track if full surah file is cached locally

  // Position preservation when switching modes
  Duration _lastFullSurahPosition = Duration.zero;

  // Audio state
  bool _audioLoading = false;
  String _selectedReciter = 'alafasy';
  ProcessingState _processingState = ProcessingState.idle;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int? _currentAyahIndex; // track which ayah is playing in playlist mode

  bool _loading = true;
  List<_VerseDisplay> _verses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSurah();
    _initAudioListeners();
  }

  Future<void> _loadSurah() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 1. Fetch English surah first (fast initial paint)
      final englishSurah = await _quranApi.getSurah(
        widget.surahNumber,
        edition: QuranApiService.popularEditions['english_sahih']!,
      );

      _verses = englishSurah.ayahs
          .map(
            (v) => _VerseDisplay(
              globalNumber: v.number,
              numberInSurah: v.numberInSurah,
              english: v.text,
            ),
          )
          .toList();

      setState(() => _loading = false);

      // 2. In the background fetch Arabic + transliteration editions and merge
      unawaited(_prefetchArabicAndTransliteration());

      // 3. Scroll to initial verse if provided
      if (widget.initialVerse != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final index = _verses.indexWhere((e) => e.numberInSurah == widget.initialVerse);
          if (index != -1) {
            _scrollController.animateTo(
              index * 180.0, // approximate height after expansion
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load Surah: $e';
      });
      // Also log the error for debugging
      print('SurahReaderScreen: Error loading surah ${widget.surahNumber}: $e');
    }
  }

  void _initAudioListeners() {
    _audioPlayer.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
    _audioPlayer.durationStream.listen((d) {
      if (!mounted) return;
      if (d != null) setState(() => _duration = d);
    });
    _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      _processingState = state.processingState;
      if (state.processingState == ProcessingState.completed) {
        if (_usingPlaylist) {
          // Loop not enabled; stop at end
          _currentAyahIndex = null;
        } else {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      }
      setState(() {});
    });
    _audioPlayer.currentIndexStream.listen((idx) {
      if (!mounted) return;
      if (idx != null && _usingPlaylist) {
        setState(() => _currentAyahIndex = idx);
      }
    });
  }

  Future<void> _togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      return;
    }
    if (_audioLoading) return;
    // If not loaded yet, set source
    try {
      if (_audioPlayer.audioSource == null || _lastLoadedReciter != _selectedReciter) {
        setState(() {
          _audioLoading = true;
        });
        await _loadFullSurahAudio();
        _duration = _audioPlayer.duration ?? Duration.zero;
      }
      await _audioPlayer.play();
    } catch (_) {
      if (mounted) {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Audio failed',
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) setState(() => _audioLoading = false);
    }
  }

  Future<File?> _cacheFullSurahIfNeeded(String url) async {
    try {
      if (Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final dir = await getApplicationSupportDirectory();
        final fileName = QuranApiService.fullSurahCacheFileName(widget.surahNumber, _selectedReciter);
        final file = File('${dir.path}/$fileName');
        // Eviction simple strategy: if directory exceeds ~600MB, delete oldest files
        try {
          final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.mp3')).toList();
          int totalBytes = 0;
          files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
          for (final f in files) {
            totalBytes += f.lengthSync();
          }
          const maxBytes = 600 * 1024 * 1024; // 600MB cap
          if (totalBytes > maxBytes) {
            for (final f in files) {
              if (totalBytes <= maxBytes) break;
              final len = f.lengthSync();
              try {
                f.deleteSync();
              } catch (_) {}
              totalBytes -= len;
            }
          }
        } catch (_) {}
        if (await file.exists() && await file.length() > 1024) {
          if (mounted) setState(() => _fullSurahCached = true);
          return file;
        }
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
          await file.writeAsBytes(resp.bodyBytes, flush: true);
          if (mounted) setState(() => _fullSurahCached = true);
          return file;
        }
      }
    } catch (_) {
      // ignore caching errors
    }
    return null;
  }

  Future<void> _loadFullSurahAudio() async {
    // Preserve playlist position if switching from playlist
    // Preserve ayah index not needed explicitly; we keep full surah position separately.
    final url = _quranApi.getSurahAudioUrl(surahNumber: widget.surahNumber, reciter: _selectedReciter);
    _lastLoadedReciter = _selectedReciter;
    Uri sourceUri = Uri.parse(url);
    final cached = await _cacheFullSurahIfNeeded(url);
    if (cached != null) {
      sourceUri = cached.uri;
    }
    await _audioPlayer.setAudioSource(
      AudioSource.uri(
        sourceUri,
        tag: MediaItem(
          id: 'surah_${widget.surahNumber}_$_selectedReciter',
          album: 'Quran Recitation',
          title: '${widget.surahEnglishName} (${widget.surahArabicName})',
          artist: _selectedReciter,
        ),
      ),
    );
    _usingPlaylist = false;
    // If we had a prior full surah position, restore it
    if (_lastFullSurahPosition > Duration.zero) {
      try {
        await _audioPlayer.seek(_lastFullSurahPosition);
      } catch (_) {}
    }
  }

  Future<void> _playAyah(int ayahIndex) async {
    if (ayahIndex < 0 || ayahIndex >= _verses.length) return;
    // Toggle pause if same ayah currently playing
    if (_usingPlaylist && _currentAyahIndex == ayahIndex) {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
        return;
      } else {
        await _audioPlayer.play();
        return;
      }
    }
    try {
      setState(() {
        _audioLoading = true;
      });
      // Build playlist lazily if not exists or reciter changed
      if (_ayahPlaylist == null || _lastLoadedReciter != _selectedReciter) {
        final sources = <AudioSource>[];
        for (final v in _verses) {
          final global = v.globalNumber;
          // Use per-ayah CDN pattern
          final url = _quranApi.getAudioUrl(
              ayahNumber: global, reciter: QuranApiService.popularReciters[_selectedReciter] ?? 'ar.alafasy');
          sources.add(AudioSource.uri(Uri.parse(url),
              tag: MediaItem(
                id: 'ayah_${global}_$_selectedReciter',
                album: '${widget.surahEnglishName} (${widget.surahArabicName})',
                title: 'Ayah ${v.numberInSurah}',
                artist: _selectedReciter,
              )));
        }
        _ayahPlaylist = ConcatenatingAudioSource(children: sources);
        _lastLoadedReciter = _selectedReciter;
      }
      // If switching from full surah, set new source
      if (!_usingPlaylist || _audioPlayer.audioSource != _ayahPlaylist) {
        // Preserve full surah position in case we go back
        _lastFullSurahPosition = _position;
        await _audioPlayer.setAudioSource(_ayahPlaylist!, initialIndex: ayahIndex, initialPosition: Duration.zero);
        _usingPlaylist = true;
      } else {
        // Already playlist: just seek to index
        await _audioPlayer.seek(Duration.zero, index: ayahIndex);
      }
      _currentAyahIndex = ayahIndex;
      await _audioPlayer.play();
    } catch (_) {
      if (mounted) {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Failed to play ayah',
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) setState(() => _audioLoading = false);
    }
  }

  String? _lastLoadedReciter; // track for change reload

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _prefetchArabicAndTransliteration() async {
    try {
      final arabicFuture = _quranApi.getSurah(
        widget.surahNumber,
        edition: QuranApiService.popularEditions['arabic_uthmani']!,
      );
      final translitFuture = _quranApi.getSurah(
        widget.surahNumber,
        edition: QuranApiService.popularEditions['transliteration']!,
      );

      final results = await Future.wait([arabicFuture, translitFuture]);
      final arabicSurah = results[0];
      final translitSurah = results[1];

      // Merge by index (API preserves ayah ordering)
      for (int i = 0; i < _verses.length; i++) {
        final verse = _verses[i];
        if (i < arabicSurah.ayahs.length) {
          verse.arabic = arabicSurah.ayahs[i].text;
        }
        if (i < translitSurah.ayahs.length) {
          verse.transliteration = translitSurah.ayahs[i].text;
        }
        verse.hasDetails = true;
        verse.expanded = true;
      }

      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      RevolutionaryComponents.showModernSnackBar(
        context: context,
        message: 'Arabic / transliteration prefetch failed',
        icon: Icons.error_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: '${widget.surahEnglishName} • ${widget.surahArabicName}',
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
        showHamburger: false,
        actions: [
          // Reciter selection (basic subset for now)
          PopupMenuButton<String>(
            tooltip: 'Select Reciter',
            initialValue: _selectedReciter,
            onSelected: (val) async {
              if (val == _selectedReciter) return;
              setState(() {
                _selectedReciter = val;
              });
              // Reload audio source if currently playing or previously loaded
              if (_audioPlayer.playing || _audioPlayer.audioSource != null) {
                await _audioPlayer.stop();
                _audioPlayer.seek(Duration.zero);
                _position = Duration.zero;
                _duration = Duration.zero;
                _audioPlayer.setAudioSource(AudioSource.uri(
                    Uri.parse(_quranApi.getSurahAudioUrl(surahNumber: widget.surahNumber, reciter: _selectedReciter))));
                _fullSurahCached = false; // reset cached indicator; will refresh when reloaded
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'alafasy', child: Text('Al-Afasy')),
              const PopupMenuItem(value: 'sudais', child: Text('As-Sudais')), // folder placeholder
              const PopupMenuItem(value: 'husary', child: Text('Al-Husary')),
              const PopupMenuItem(value: 'abdulbasit', child: Text('Abdul Basit')),
            ],
            child: Icon(
              Icons.record_voice_over_rounded,
              color: _audioPlayer.playing
                  ? RevolutionaryIslamicTheme.primaryEmerald
                  : RevolutionaryIslamicTheme.textSecondary,
            ),
          ),
          IconButton(
            tooltip: _audioPlayer.playing ? 'Pause' : 'Play Full Surah',
            icon: _audioLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_audioPlayer.playing ? Icons.pause_circle_filled : Icons.play_circle_fill_rounded),
            onPressed: _togglePlayPause,
          ),
          if (_fullSurahCached)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Tooltip(
                message: 'Cached for offline playback',
                child: Icon(Icons.download_done_rounded, color: RevolutionaryIslamicTheme.successGreen),
              ),
            ),
          IconButton(
            tooltip: 'Copy Audio URL',
            icon: const Icon(Icons.link_rounded),
            onPressed: () {
              final url = _quranApi.getSurahAudioUrl(surahNumber: widget.surahNumber);
              Clipboard.setData(ClipboardData(text: url));
              RevolutionaryComponents.showModernSnackBar(
                context: context,
                message: 'Audio URL copied',
                icon: Icons.check_circle_outline,
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(RevolutionaryIslamicTheme.primaryEmerald),
              ),
            )
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: RevolutionaryIslamicTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSurah,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Simple audio progress bar
        if (_duration > Duration.zero)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              children: [
                // Processing / buffering indicator inline
                if (_processingState == ProcessingState.loading || _processingState == ProcessingState.buffering)
                  Row(
                    children: const [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Buffering audio...',
                          style: TextStyle(fontSize: 12, color: RevolutionaryIslamicTheme.textSecondary)),
                    ],
                  ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 3),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
                    onChanged: (v) async {
                      final seekTo = Duration(milliseconds: v.toInt());
                      await _audioPlayer.seek(seekTo);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatTime(_position),
                        style: const TextStyle(fontSize: 11, color: RevolutionaryIslamicTheme.textSecondary)),
                    Text(_formatTime(_duration),
                        style: const TextStyle(fontSize: 11, color: RevolutionaryIslamicTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: _verses.length,
            itemBuilder: (context, index) {
              final verse = _verses[index];
              return _buildVerseCard(verse, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerseCard(_VerseDisplay verse, int ayahNumberInSurah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray300.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => verse.expanded = !verse.expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          RevolutionaryIslamicTheme.primaryEmerald,
                          RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      verse.numberInSurah.toString(),
                      style: const TextStyle(
                        color: RevolutionaryIslamicTheme.neutralWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      verse.english,
                      style: const TextStyle(
                        fontSize: 14,
                        color: RevolutionaryIslamicTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Play this Ayah',
                    onPressed: () => _playAyah(ayahNumberInSurah - 1),
                    icon: Icon(
                      _usingPlaylist && _currentAyahIndex == ayahNumberInSurah - 1 && _audioPlayer.playing
                          ? Icons.pause_circle_filled
                          : Icons.play_arrow_rounded,
                      size: 22,
                      color: _usingPlaylist && _currentAyahIndex == ayahNumberInSurah - 1
                          ? RevolutionaryIslamicTheme.primaryEmerald
                          : RevolutionaryIslamicTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    verse.expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: RevolutionaryIslamicTheme.textSecondary,
                  ),
                ],
              ),
              if (verse.expanded) ...[
                const SizedBox(height: 14),
                if (verse.arabic != null)
                  Text(
                    verse.arabic!.replaceAll('\n', ' '), // ensure single-line Arabic segments
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 2.0,
                      fontWeight: FontWeight.w500,
                      color: RevolutionaryIslamicTheme.textPrimary,
                    ),
                  ),
                if (verse.transliteration != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    verse.transliteration!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: RevolutionaryIslamicTheme.textSecondary,
                    ),
                  ),
                ],
              ]
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class _VerseDisplay {
  final int globalNumber; // Unique global ayah number
  final int numberInSurah;
  final String english;
  String? arabic;
  String? transliteration;
  bool loadingDetails = false;
  bool hasDetails = false;
  bool expanded = true; // Keep expanded to show details once loaded

  _VerseDisplay({
    required this.globalNumber,
    required this.numberInSurah,
    required this.english,
  });
}
