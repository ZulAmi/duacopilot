import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Optimized image widget with smart caching for RAG responses
class OptimizedRagImage extends StatelessWidget {
  const OptimizedRagImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
    this.compressionQuality = 85,
    this.maxWidth = 1920,
    this.maxHeight = 1080,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final bool enableMemoryCache;
  final bool enableDiskCache;
  final int compressionQuality;
  final int maxWidth;
  final int maxHeight;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      cacheManager: _getOptimizedCacheManager(),
      memCacheWidth: maxWidth,
      memCacheHeight: maxHeight,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildDefaultErrorWidget(),
      imageBuilder: (context, imageProvider) => _buildOptimizedImage(imageProvider),
    );
  }

  Widget _buildOptimizedImage(ImageProvider imageProvider) {
    return Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true, // Prevent flicker during image changes
      isAntiAlias: true, // Better rendering quality
      filterQuality: FilterQuality.medium, // Balanced quality/performance
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.error_outline, color: Colors.grey),
    );
  }

  CacheManager _getOptimizedCacheManager() {
    return RagImageCacheManager.instance;
  }
}

/// Custom cache manager optimized for RAG images
class RagImageCacheManager extends CacheManager {
  static const key = 'rag_images';
  static RagImageCacheManager? _instance;

  factory RagImageCacheManager() {
    _instance ??= RagImageCacheManager._();
    return _instance!;
  }

  RagImageCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7), // Keep images for 7 days
          maxNrOfCacheObjects: 1000, // Limit cache size
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: _getOptimizedFileService(),
        ),
      );

  static FileService _getOptimizedFileService() {
    if (Platform.isAndroid || Platform.isIOS) {
      return HttpFileService(httpClient: _getOptimizedHttpClient());
    } else {
      return HttpFileService();
    }
  }

  static dynamic _getOptimizedHttpClient() {
    // Platform-specific HTTP client optimizations
    // This would be implemented with actual HTTP client configuration
    return null;
  }

  static RagImageCacheManager get instance => RagImageCacheManager();

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    await emptyCache();
  }

  /// Get cache size information
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      // Get approximate cache info
      final cacheDir = await getTemporaryDirectory();
      final cacheSize = await _calculateDirectorySize(cacheDir);

      return {
        'cache_size_bytes': cacheSize,
        'cache_size_mb': (cacheSize / (1024 * 1024)).toInt(),
        'estimated_files': 0, // Would need platform-specific implementation
      };
    } catch (e) {
      return {'cache_size_bytes': 0, 'cache_size_mb': 0, 'estimated_files': 0};
    }
  }

  Future<int> _calculateDirectorySize(Directory directory) async {
    int size = 0;
    try {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (e) {
      // Handle errors silently
    }
    return size;
  }

  /// Dispose resources
  @override
  Future<void> dispose() async {
    // Cache manager automatically manages resources
  }
}

/// Image compression utility for RAG content
class RagImageCompressor {
  /// Compress image with platform-specific optimizations
  static Future<Uint8List?> compressImage({
    required Uint8List imageBytes,
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    try {
      // Platform-specific compression
      if (Platform.isAndroid || Platform.isIOS) {
        return await _compressWithNative(
          imageBytes: imageBytes,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          format: format,
        );
      } else {
        return await _compressWithDart(
          imageBytes: imageBytes,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      }
    } catch (e) {
      debugPrint('Image compression failed: $e');
      return imageBytes; // Return original if compression fails
    }
  }

  static Future<Uint8List?> _compressWithNative({
    required Uint8List imageBytes,
    required int quality,
    int? maxWidth,
    int? maxHeight,
    required CompressFormat format,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.tmp');

    await tempFile.writeAsBytes(imageBytes);

    final result = await FlutterImageCompress.compressWithFile(
      tempFile.absolute.path,
      quality: quality,
      minWidth: maxWidth ?? 1920,
      minHeight: maxHeight ?? 1080,
      format: format,
    );

    // Clean up temp file
    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    return result;
  }

  static Future<Uint8List> _compressWithDart({
    required Uint8List imageBytes,
    required int quality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    // Resize if dimensions are specified
    img.Image resizedImage = image;
    if (maxWidth != null || maxHeight != null) {
      resizedImage = img.copyResize(image, width: maxWidth, height: maxHeight, interpolation: img.Interpolation.linear);
    }

    // Encode with specified quality
    final compressedBytes = img.encodeJpg(resizedImage, quality: quality);
    return Uint8List.fromList(compressedBytes);
  }

  /// Generate optimized thumbnails
  static Future<Uint8List?> generateThumbnail({
    required Uint8List imageBytes,
    int thumbnailSize = 150,
    int quality = 70,
  }) async {
    return await compressImage(
      imageBytes: imageBytes,
      quality: quality,
      maxWidth: thumbnailSize,
      maxHeight: thumbnailSize,
    );
  }
}

/// Audio optimization utility for RAG content
class RagAudioOptimizer {
  static const String _cacheKey = 'rag_audio';
  static CacheManager? _audioCacheManager;

  /// Get optimized audio cache manager
  static CacheManager get audioCacheManager {
    _audioCacheManager ??= CacheManager(
      Config(
        _cacheKey,
        stalePeriod: const Duration(days: 30), // Keep audio longer than images
        maxNrOfCacheObjects: 500,
        repo: JsonCacheInfoRepository(databaseName: _cacheKey),
      ),
    );
    return _audioCacheManager!;
  }

  /// Preload audio file for instant playback
  static Future<String?> preloadAudio(String audioUrl) async {
    try {
      final file = await audioCacheManager.getSingleFile(audioUrl);
      return file.path;
    } catch (e) {
      debugPrint('Audio preload failed: $e');
      return null;
    }
  }

  /// Get cached audio file path
  static Future<String?> getCachedAudioPath(String audioUrl) async {
    try {
      final fileInfo = await audioCacheManager.getFileFromCache(audioUrl);
      return fileInfo?.file.path;
    } catch (e) {
      return null;
    }
  }

  /// Clear audio cache
  static Future<void> clearAudioCache() async {
    await audioCacheManager.emptyCache();
  }

  /// Get audio cache statistics
  static Future<Map<String, dynamic>> getAudioCacheInfo() async {
    try {
      // Get approximate cache info
      final cacheDir = await getTemporaryDirectory();
      final cacheSize = await _calculateAudioDirectorySize(cacheDir);

      return {
        'totalFiles': 0, // Would need platform-specific implementation
        'totalSizeBytes': cacheSize,
        'totalSizeMB': (cacheSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      return {'totalFiles': 0, 'totalSizeBytes': 0, 'totalSizeMB': '0.00'};
    }
  }

  static Future<int> _calculateAudioDirectorySize(Directory directory) async {
    int size = 0;
    try {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File && entity.path.contains('audio')) {
          size += await entity.length();
        }
      }
    } catch (e) {
      // Handle errors silently
    }
    return size;
  }
}

/// Smart caching strategy for RAG media content
class RagMediaCacheStrategy {
  /// Determine if content should be cached based on usage patterns
  static bool shouldCache({
    required String contentUrl,
    required int accessCount,
    required DateTime lastAccessed,
    required int contentSizeBytes,
  }) {
    // Don't cache very large files on mobile
    if ((Platform.isAndroid || Platform.isIOS) && contentSizeBytes > 50 * 1024 * 1024) {
      return false;
    }

    // Cache frequently accessed content
    if (accessCount > 3) return true;

    // Cache recently accessed content
    final hoursSinceAccess = DateTime.now().difference(lastAccessed).inHours;
    if (hoursSinceAccess < 24) return true;

    // Cache smaller files more aggressively
    if (contentSizeBytes < 1024 * 1024) return true; // Cache files under 1MB

    return false;
  }

  /// Get cache priority (higher number = higher priority)
  static int getCachePriority({required String contentType, required int accessCount, required DateTime lastAccessed}) {
    int priority = 0;

    // Content type priority
    if (contentType.startsWith('image/')) {
      priority += 10; // Images have high priority
    } else if (contentType.startsWith('audio/')) {
      priority += 8; // Audio has medium-high priority
    }

    // Access frequency priority
    priority += (accessCount * 2).clamp(0, 20);

    // Recency priority
    final hoursSinceAccess = DateTime.now().difference(lastAccessed).inHours;
    if (hoursSinceAccess < 1) {
      priority += 15;
    } else if (hoursSinceAccess < 6)
      priority += 10;
    else if (hoursSinceAccess < 24)
      priority += 5;

    return priority;
  }

  /// Generate cache key for content
  static String generateCacheKey(String url, {Map<String, String>? parameters}) {
    final uri = Uri.parse(url);
    final baseKey = '${uri.host}${uri.path}';

    if (parameters != null && parameters.isNotEmpty) {
      final paramString = parameters.entries.map((e) => '${e.key}=${e.value}').join('&');
      return '${baseKey}_${md5.convert(utf8.encode(paramString)).toString()}';
    }

    return baseKey;
  }
}

/// Widget for optimized media display in RAG responses
class OptimizedRagMediaWidget extends StatelessWidget {
  const OptimizedRagMediaWidget({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
    this.width,
    this.height,
    this.enableCaching = true,
    this.compressionQuality = 85,
  });

  final String mediaUrl;
  final String mediaType;
  final double? width;
  final double? height;
  final bool enableCaching;
  final int compressionQuality;

  @override
  Widget build(BuildContext context) {
    if (mediaType.startsWith('image/')) {
      return _buildOptimizedImage();
    } else if (mediaType.startsWith('audio/')) {
      return _buildOptimizedAudio();
    } else {
      return _buildUnsupportedMedia();
    }
  }

  Widget _buildOptimizedImage() {
    return OptimizedRagImage(
      imageUrl: mediaUrl,
      width: width,
      height: height,
      compressionQuality: compressionQuality,
      enableMemoryCache: enableCaching,
      enableDiskCache: enableCaching,
    );
  }

  Widget _buildOptimizedAudio() {
    return Container(
      width: width,
      height: height ?? 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.audio_file, color: Colors.grey),
          SizedBox(width: 8),
          Text('Audio Content', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildUnsupportedMedia() {
    return Container(
      width: width,
      height: height ?? 60,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: const Center(child: Icon(Icons.attachment, color: Colors.grey)),
    );
  }
}
