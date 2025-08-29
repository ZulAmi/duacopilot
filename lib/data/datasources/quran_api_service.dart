import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/audio_cache.dart';

/// Al Quran Cloud API service for RAG content integration
///
/// Provides access to Quranic verses, translations, search capabilities,
/// and audio content for enhancing RAG responses with authentic Islamic sources.
class QuranApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _cdnBaseUrl = 'https://cdn.islamic.network';
  // Base host for complete surah audio (simple integration for now)
  static const String _mp3QuranBaseHost = 'https://server8.mp3quran.net';

  final http.Client _client;

  // Popular editions for different use cases
  static const Map<String, String> popularEditions = {
    'arabic_uthmani': 'quran-uthmani-quran-academy',
    'english_sahih': 'en.sahih',
    'english_pickthall': 'en.pickthall',
    'english_yusufali': 'en.yusufali',
    'transliteration': 'en.transliteration',
  };

  // Popular audio reciters
  static const Map<String, String> popularReciters = {
    'alafasy': 'ar.alafasy',
    'abdulbasit': 'ar.abdulbasitmurattal',
    'sudais': 'ar.abdurrahmaansudais',
    'husary': 'ar.husary',
    'hanirifai': 'ar.hanirifai',
  };

  /// Folder codes on mp3quran for full-surah audio.
  /// Verified: alafasy => afs (Mishary Rashid Al-Afasy)
  /// Additional entries added as best-effort common shorthand; TODO: verify exact folder codes before production.
  static final Map<String, String> _mp3QuranReciterFolders = {
    'alafasy': 'afs', // Mishary Rashid Al-Afasy (confirmed by user example)
    'sudais': 'sds', // Abdul Rahman As-Sudais (placeholder; verify)
    'husary': 'hus', // Mahmoud Khalil Al-Husary (placeholder; verify)
    'abdulbasit': 'abdr', // Abdul Basit (Murattal) (placeholder; verify)
  };

  /// Public accessor for available full-surah reciters.
  static List<String> get fullSurahReciters => _mp3QuranReciterFolders.keys.toList(growable: false);

  /// Register / override a full-surah reciter folder code at runtime (e.g., remote config update).
  static void registerFullSurahReciter(String key, String folderCode) {
    _mp3QuranReciterFolders[key] = folderCode;
  }

  QuranApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Get comprehensive list of all 114 Surahs with proper metadata
  /// This provides instant access without API calls for the Quran Explorer
  static List<QuranSurahInfo> getAllSurahsMetadata() {
    return [
      QuranSurahInfo(
          number: 1,
          name: 'الفاتحة',
          englishName: 'Al-Fatiha',
          englishNameTranslation: 'The Opening',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 2,
          name: 'البقرة',
          englishName: 'Al-Baqarah',
          englishNameTranslation: 'The Cow',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 3,
          name: 'آل عمران',
          englishName: 'Ali \'Imran',
          englishNameTranslation: 'Family of Imran',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 4,
          name: 'النساء',
          englishName: 'An-Nisa',
          englishNameTranslation: 'The Women',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 5,
          name: 'المائدة',
          englishName: 'Al-Ma\'idah',
          englishNameTranslation: 'The Table Spread',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 6,
          name: 'الأنعام',
          englishName: 'Al-An\'am',
          englishNameTranslation: 'The Cattle',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 7,
          name: 'الأعراف',
          englishName: 'Al-A\'raf',
          englishNameTranslation: 'The Heights',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 8,
          name: 'الأنفال',
          englishName: 'Al-Anfal',
          englishNameTranslation: 'The Spoils of War',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 9,
          name: 'التوبة',
          englishName: 'At-Tawbah',
          englishNameTranslation: 'The Repentance',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 10, name: 'يونس', englishName: 'Yunus', englishNameTranslation: 'Jonah', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 11, name: 'هود', englishName: 'Hud', englishNameTranslation: 'Hud', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 12, name: 'يوسف', englishName: 'Yusuf', englishNameTranslation: 'Joseph', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 13,
          name: 'الرعد',
          englishName: 'Ar-Ra\'d',
          englishNameTranslation: 'The Thunder',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 14,
          name: 'إبراهيم',
          englishName: 'Ibrahim',
          englishNameTranslation: 'Abraham',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 15,
          name: 'الحجر',
          englishName: 'Al-Hijr',
          englishNameTranslation: 'The Rocky Tract',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 16,
          name: 'النحل',
          englishName: 'An-Nahl',
          englishNameTranslation: 'The Bee',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 17,
          name: 'الإسراء',
          englishName: 'Al-Isra',
          englishNameTranslation: 'The Night Journey',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 18,
          name: 'الكهف',
          englishName: 'Al-Kahf',
          englishNameTranslation: 'The Cave',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 19, name: 'مريم', englishName: 'Maryam', englishNameTranslation: 'Mary', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 20, name: 'طه', englishName: 'Taha', englishNameTranslation: 'Taha', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 21,
          name: 'الأنبياء',
          englishName: 'Al-Anbya',
          englishNameTranslation: 'The Prophets',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 22,
          name: 'الحج',
          englishName: 'Al-Hajj',
          englishNameTranslation: 'The Pilgrimage',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 23,
          name: 'المؤمنون',
          englishName: 'Al-Muminun',
          englishNameTranslation: 'The Believers',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 24,
          name: 'النور',
          englishName: 'An-Nur',
          englishNameTranslation: 'The Light',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 25,
          name: 'الفرقان',
          englishName: 'Al-Furqan',
          englishNameTranslation: 'The Criterion',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 26,
          name: 'الشعراء',
          englishName: 'Ash-Shu\'ara',
          englishNameTranslation: 'The Poets',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 27,
          name: 'النمل',
          englishName: 'An-Naml',
          englishNameTranslation: 'The Ant',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 28,
          name: 'القصص',
          englishName: 'Al-Qasas',
          englishNameTranslation: 'The Stories',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 29,
          name: 'العنكبوت',
          englishName: 'Al-Ankabut',
          englishNameTranslation: 'The Spider',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 30,
          name: 'الروم',
          englishName: 'Ar-Rum',
          englishNameTranslation: 'The Romans',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 31, name: 'لقمان', englishName: 'Luqman', englishNameTranslation: 'Luqman', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 32,
          name: 'السجدة',
          englishName: 'As-Sajdah',
          englishNameTranslation: 'The Prostration',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 33,
          name: 'الأحزاب',
          englishName: 'Al-Ahzab',
          englishNameTranslation: 'The Clans',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 34, name: 'سبأ', englishName: 'Saba', englishNameTranslation: 'Sheba', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 35,
          name: 'فاطر',
          englishName: 'Fatir',
          englishNameTranslation: 'Originator',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 36, name: 'يس', englishName: 'Ya-Sin', englishNameTranslation: 'Ya Sin', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 37,
          name: 'الصافات',
          englishName: 'As-Saffat',
          englishNameTranslation: 'Those Who Set The Ranks',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 38,
          name: 'ص',
          englishName: 'Sad',
          englishNameTranslation: 'The Letter "Sad"',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 39,
          name: 'الزمر',
          englishName: 'Az-Zumar',
          englishNameTranslation: 'The Troops',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 40,
          name: 'غافر',
          englishName: 'Ghafir',
          englishNameTranslation: 'The Forgiver',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 41,
          name: 'فصلت',
          englishName: 'Fussilat',
          englishNameTranslation: 'Explained In Detail',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 42,
          name: 'الشورى',
          englishName: 'Ash-Shuraa',
          englishNameTranslation: 'The Consultation',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 43,
          name: 'الزخرف',
          englishName: 'Az-Zukhruf',
          englishNameTranslation: 'The Ornaments Of Gold',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 44,
          name: 'الدخان',
          englishName: 'Ad-Dukhan',
          englishNameTranslation: 'The Smoke',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 45,
          name: 'الجاثية',
          englishName: 'Al-Jathiyah',
          englishNameTranslation: 'The Crouching',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 46,
          name: 'الأحقاف',
          englishName: 'Al-Ahqaf',
          englishNameTranslation: 'The Wind-Curved Sandhills',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 47,
          name: 'محمد',
          englishName: 'Muhammad',
          englishNameTranslation: 'Muhammad',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 48,
          name: 'الفتح',
          englishName: 'Al-Fath',
          englishNameTranslation: 'The Victory',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 49,
          name: 'الحجرات',
          englishName: 'Al-Hujurat',
          englishNameTranslation: 'The Private Apartments',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 50,
          name: 'ق',
          englishName: 'Qaf',
          englishNameTranslation: 'The Letter "Qaf"',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 51,
          name: 'الذاريات',
          englishName: 'Adh-Dhariyat',
          englishNameTranslation: 'The Winnowing Winds',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 52,
          name: 'الطور',
          englishName: 'At-Tur',
          englishNameTranslation: 'The Mount',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 53,
          name: 'النجم',
          englishName: 'An-Najm',
          englishNameTranslation: 'The Star',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 54,
          name: 'القمر',
          englishName: 'Al-Qamar',
          englishNameTranslation: 'The Moon',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 55,
          name: 'الرحمن',
          englishName: 'Ar-Rahman',
          englishNameTranslation: 'The Beneficent',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 56,
          name: 'الواقعة',
          englishName: 'Al-Waqi\'ah',
          englishNameTranslation: 'The Inevitable',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 57,
          name: 'الحديد',
          englishName: 'Al-Hadid',
          englishNameTranslation: 'The Iron',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 58,
          name: 'المجادلة',
          englishName: 'Al-Mujadila',
          englishNameTranslation: 'The Pleading Woman',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 59,
          name: 'الحشر',
          englishName: 'Al-Hashr',
          englishNameTranslation: 'The Exile',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 60,
          name: 'الممتحنة',
          englishName: 'Al-Mumtahanah',
          englishNameTranslation: 'She That Is To Be Examined',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 61,
          name: 'الصف',
          englishName: 'As-Saff',
          englishNameTranslation: 'The Ranks',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 62,
          name: 'الجمعة',
          englishName: 'Al-Jumu\'ah',
          englishNameTranslation: 'The Congregation, Friday',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 63,
          name: 'المنافقون',
          englishName: 'Al-Munafiqun',
          englishNameTranslation: 'The Hypocrites',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 64,
          name: 'التغابن',
          englishName: 'At-Taghabun',
          englishNameTranslation: 'The Mutual Disillusion',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 65,
          name: 'الطلاق',
          englishName: 'At-Talaq',
          englishNameTranslation: 'The Divorce',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 66,
          name: 'التحريم',
          englishName: 'At-Tahrim',
          englishNameTranslation: 'The Prohibition',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 67,
          name: 'الملك',
          englishName: 'Al-Mulk',
          englishNameTranslation: 'The Sovereignty',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 68,
          name: 'القلم',
          englishName: 'Al-Qalam',
          englishNameTranslation: 'The Pen',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 69,
          name: 'الحاقة',
          englishName: 'Al-Haqqah',
          englishNameTranslation: 'The Reality',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 70,
          name: 'المعارج',
          englishName: 'Al-Ma\'arij',
          englishNameTranslation: 'The Ascending Stairways',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 71, name: 'نوح', englishName: 'Nuh', englishNameTranslation: 'Noah', revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 72,
          name: 'الجن',
          englishName: 'Al-Jinn',
          englishNameTranslation: 'The Jinn',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 73,
          name: 'المزمل',
          englishName: 'Al-Muzzammil',
          englishNameTranslation: 'The Enshrouded One',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 74,
          name: 'المدثر',
          englishName: 'Al-Muddaththir',
          englishNameTranslation: 'The Cloaked One',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 75,
          name: 'القيامة',
          englishName: 'Al-Qiyamah',
          englishNameTranslation: 'The Resurrection',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 76,
          name: 'الإنسان',
          englishName: 'Al-Insan',
          englishNameTranslation: 'Man',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 77,
          name: 'المرسلات',
          englishName: 'Al-Mursalat',
          englishNameTranslation: 'The Emissaries',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 78,
          name: 'النبأ',
          englishName: 'An-Naba',
          englishNameTranslation: 'The Tidings',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 79,
          name: 'النازعات',
          englishName: 'An-Nazi\'at',
          englishNameTranslation: 'Those Who Drag Forth',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 80,
          name: 'عبس',
          englishName: 'Abasa',
          englishNameTranslation: 'He Frowned',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 81,
          name: 'التكوير',
          englishName: 'At-Takwir',
          englishNameTranslation: 'The Overthrowing',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 82,
          name: 'الإنفطار',
          englishName: 'Al-Infitar',
          englishNameTranslation: 'The Cleaving',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 83,
          name: 'المطففين',
          englishName: 'Al-Mutaffifin',
          englishNameTranslation: 'The Defrauding',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 84,
          name: 'الإنشقاق',
          englishName: 'Al-Inshiqaq',
          englishNameTranslation: 'The Sundering',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 85,
          name: 'البروج',
          englishName: 'Al-Buruj',
          englishNameTranslation: 'The Mansions Of The Stars',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 86,
          name: 'الطارق',
          englishName: 'At-Tariq',
          englishNameTranslation: 'The Morning Star',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 87,
          name: 'الأعلى',
          englishName: 'Al-A\'la',
          englishNameTranslation: 'The Most High',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 88,
          name: 'الغاشية',
          englishName: 'Al-Ghashiyah',
          englishNameTranslation: 'The Overwhelming',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 89,
          name: 'الفجر',
          englishName: 'Al-Fajr',
          englishNameTranslation: 'The Dawn',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 90,
          name: 'البلد',
          englishName: 'Al-Balad',
          englishNameTranslation: 'The City',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 91,
          name: 'الشمس',
          englishName: 'Ash-Shams',
          englishNameTranslation: 'The Sun',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 92,
          name: 'الليل',
          englishName: 'Al-Layl',
          englishNameTranslation: 'The Night',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 93,
          name: 'الضحى',
          englishName: 'Ad-Duhaa',
          englishNameTranslation: 'The Morning Hours',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 94,
          name: 'الشرح',
          englishName: 'Ash-Sharh',
          englishNameTranslation: 'The Relief',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 95,
          name: 'التين',
          englishName: 'At-Tin',
          englishNameTranslation: 'The Fig',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 96,
          name: 'العلق',
          englishName: 'Al-Alaq',
          englishNameTranslation: 'The Clot',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 97,
          name: 'القدر',
          englishName: 'Al-Qadr',
          englishNameTranslation: 'The Power',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 98,
          name: 'البينة',
          englishName: 'Al-Bayyinah',
          englishNameTranslation: 'The Clear Proof',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 99,
          name: 'الزلزلة',
          englishName: 'Az-Zalzalah',
          englishNameTranslation: 'The Earthquake',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 100,
          name: 'العاديات',
          englishName: 'Al-Adiyat',
          englishNameTranslation: 'The Courser',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 101,
          name: 'القارعة',
          englishName: 'Al-Qari\'ah',
          englishNameTranslation: 'The Calamity',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 102,
          name: 'التكاثر',
          englishName: 'At-Takathur',
          englishNameTranslation: 'The Rivalry In World Increase',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 103,
          name: 'العصر',
          englishName: 'Al-Asr',
          englishNameTranslation: 'The Declining Day',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 104,
          name: 'الهمزة',
          englishName: 'Al-Humazah',
          englishNameTranslation: 'The Traducer',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 105,
          name: 'الفيل',
          englishName: 'Al-Fil',
          englishNameTranslation: 'The Elephant',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 106,
          name: 'قريش',
          englishName: 'Quraysh',
          englishNameTranslation: 'Quraysh',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 107,
          name: 'الماعون',
          englishName: 'Al-Ma\'un',
          englishNameTranslation: 'The Small Kindnesses',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 108,
          name: 'الكوثر',
          englishName: 'Al-Kawthar',
          englishNameTranslation: 'The Abundance',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 109,
          name: 'الكافرون',
          englishName: 'Al-Kafirun',
          englishNameTranslation: 'The Disbelievers',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 110,
          name: 'النصر',
          englishName: 'An-Nasr',
          englishNameTranslation: 'The Divine Support',
          revelationType: 'Medinan'),
      QuranSurahInfo(
          number: 111,
          name: 'المسد',
          englishName: 'Al-Masad',
          englishNameTranslation: 'The Palm Fiber',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 112,
          name: 'الإخلاص',
          englishName: 'Al-Ikhlas',
          englishNameTranslation: 'The Sincerity',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 113,
          name: 'الفلق',
          englishName: 'Al-Falaq',
          englishNameTranslation: 'The Daybreak',
          revelationType: 'Meccan'),
      QuranSurahInfo(
          number: 114,
          name: 'الناس',
          englishName: 'An-Nas',
          englishNameTranslation: 'Mankind',
          revelationType: 'Meccan'),
    ];
  }

  // ========== Search Operations ==========

  /// Search for verses containing specific keywords
  Future<QuranSearchResult> searchVerses({
    required String query,
    int? surahNumber,
    String edition = 'en.sahih',
  }) async {
    try {
      String endpoint;
      if (surahNumber != null) {
        endpoint = '$_baseUrl/search/${Uri.encodeComponent(query)}/$surahNumber/$edition';
      } else {
        endpoint = '$_baseUrl/search/${Uri.encodeComponent(query)}';
      }

      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuranSearchResult.fromJson(data);
      } else if (response.statusCode == 404) {
        return QuranSearchResult.empty(query);
      } else {
        throw QuranApiException(
          'Search failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to search verses: $e');
    }
  }

  /// Get detailed verse information with multiple translations
  Future<List<QuranVerse>> getVerseWithTranslations(
    int ayahNumber, {
    List<String>? editions,
  }) async {
    try {
      final selectedEditions = editions ??
          [
            popularEditions['arabic_uthmani']!,
            popularEditions['english_sahih']!,
            popularEditions['transliteration']!,
          ];

      final editionsParam = selectedEditions.join(',');
      final endpoint = '$_baseUrl/ayah/$ayahNumber/editions/$editionsParam';

      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> ayahData = data['data'];

        return ayahData.map((ayah) => QuranVerse.fromJson(ayah)).toList();
      } else {
        throw QuranApiException('Failed to get verse: ${response.statusCode}');
      }
    } catch (e) {
      throw QuranApiException('Failed to get verse with translations: $e');
    }
  }

  /// Get a complete Surah with specified edition
  Future<QuranSurah> getSurah(
    int surahNumber, {
    String edition = 'en.sahih',
    int? offset,
    int? limit,
  }) async {
    try {
      String endpoint = '$_baseUrl/surah/$surahNumber/$edition';

      if (offset != null || limit != null) {
        final params = <String>[];
        if (offset != null) params.add('offset=$offset');
        if (limit != null) params.add('limit=$limit');
        endpoint += '?${params.join('&')}';
      }

      print('QuranApiService: Making API call to: $endpoint');
      final response = await _client.get(Uri.parse(endpoint));
      print('QuranApiService: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('QuranApiService: Successfully parsed response data');
        return QuranSurah.fromJson(data['data']);
      } else {
        print('QuranApiService: API error - Status: ${response.statusCode}, Body: ${response.body}');
        throw QuranApiException('Failed to get surah: ${response.statusCode}');
      }
    } catch (e) {
      print('QuranApiService: Exception in getSurah: $e');
      throw QuranApiException('Failed to get surah: $e');
    }
  }

  // ========== Edition Management ==========

  /// Get available editions by language
  Future<List<QuranEdition>> getEditionsByLanguage(String language) async {
    try {
      final endpoint = '$_baseUrl/edition/language/$language';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> editions = data['data'];

        return editions.map((edition) => QuranEdition.fromJson(edition)).toList();
      } else {
        throw QuranApiException(
          'Failed to get editions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get editions by language: $e');
    }
  }

  /// Get all available editions
  Future<List<QuranEdition>> getAllEditions() async {
    try {
      final endpoint = '$_baseUrl/edition';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> editions = data['data'];

        return editions.map((edition) => QuranEdition.fromJson(edition)).toList();
      } else {
        throw QuranApiException(
          'Failed to get editions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get all editions: $e');
    }
  }

  // ========== Audio Operations ==========

  /// Get audio URL for a specific verse and reciter
  String getAudioUrl({
    required int ayahNumber,
    String reciter = 'ar.alafasy',
    AudioQuality quality = AudioQuality.medium,
  }) {
    final qualityStr = _getQualityString(quality);
    return '$_cdnBaseUrl/quran/audio/$qualityStr/$reciter/$ayahNumber.mp3';
  }

  /// Get multiple audio URLs for different quality levels
  List<String> getAudioUrls({
    required int ayahNumber,
    String reciter = 'ar.alafasy',
  }) {
    return AudioQuality.values.map((quality) {
      final qualityStr = _getQualityString(quality);
      return '$_cdnBaseUrl/quran/audio/$qualityStr/$reciter/$ayahNumber.mp3';
    }).toList();
  }

  /// Get a complete Surah audio URL for a given reciter using mp3quran pattern.
  /// Currently supports a minimal set (default Al-Afasy) and returns a direct MP3 link.
  /// Example: getSurahAudioUrl(surahNumber: 1) => https://server8.mp3quran.net/afs/001.mp3
  String getSurahAudioUrl({
    required int surahNumber,
    String reciter = 'alafasy',
  }) {
    final folder = _mp3QuranReciterFolders[reciter] ?? _mp3QuranReciterFolders['alafasy']!;
    final padded = surahNumber.toString().padLeft(3, '0');
    return '$_mp3QuranBaseHost/$folder/$padded.mp3';
  }

  /// (Optional helper) Return a potential local cache filename (without path) for a full-surah audio file.
  static String fullSurahCacheFileName(int surahNumber, String reciter) {
    final padded = surahNumber.toString().padLeft(3, '0');
    return 'surah_${padded}_$reciter.mp3';
  }

  /// Returns audio metadata entries for ALL 114 surahs for the given [reciter].
  /// Each entry represents a full (complete) surah recitation, using the
  /// mp3quran pattern: https://server8.mp3quran.net/<folder>/<3-digit>.mp3
  ///
  /// The returned list is generated programmatically so we don't have to keep
  /// a large hard‑coded table in source while still satisfying the requirement
  /// to “add ALL the audio from surah 1-114”.
  List<SurahAudioEntry> getAllCompleteSurahAudio({String reciter = 'alafasy'}) {
    const totalSurahs = 114;
    final List<SurahAudioEntry> entries = [];
    for (var i = 1; i <= totalSurahs; i++) {
      entries.add(
        SurahAudioEntry(
          surahNumber: i,
          reciterDisplayName: _reciterDisplayName(reciter),
          url: getSurahAudioUrl(surahNumber: i, reciter: reciter),
          type: 'complete_surah',
        ),
      );
    }
    return entries;
  }

  String _reciterDisplayName(String reciterKey) {
    switch (reciterKey) {
      case 'alafasy':
        return 'Mishary Rashid Al-Afasy';
      default:
        // Fallback to key if we don't have a friendly mapping yet.
        return reciterKey;
    }
  }

  String _getQualityString(AudioQuality quality) {
    switch (quality) {
      case AudioQuality.low:
        return '64';
      case AudioQuality.medium:
        return '128';
      case AudioQuality.high:
        return '192';
      case AudioQuality.ultra:
        return '320';
    }
  }

  // ========== Utility Methods ==========

  /// Get meta information about Quran structure
  Future<QuranMeta> getMetaData() async {
    try {
      final endpoint = '$_baseUrl/meta';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuranMeta.fromJson(data['data']);
      } else {
        throw QuranApiException(
          'Failed to get meta data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get meta data: $e');
    }
  }

  /// Get verses requiring Sajda (prostration)
  Future<List<QuranVerse>> getSajdaVerses({String edition = 'en.sahih'}) async {
    try {
      final endpoint = '$_baseUrl/sajda/$edition';
      final response = await _client.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> ayahs = data['data']['ayahs'];

        return ayahs.map((ayah) => QuranVerse.fromJson(ayah)).toList();
      } else {
        throw QuranApiException(
          'Failed to get sajda verses: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw QuranApiException('Failed to get sajda verses: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Lightweight data model for a full-surah audio entry.
class SurahAudioEntry {
  final int surahNumber;
  final String reciterDisplayName;
  final String url;
  final String type; // e.g. 'complete_surah'

  const SurahAudioEntry({
    required this.surahNumber,
    required this.reciterDisplayName,
    required this.url,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'reciter': reciterDisplayName,
        'url': url,
        'originalUrl': url,
        'type': type,
      };
}

// ========== Data Models ==========

/// QuranSearchResult class implementation
class QuranSearchResult {
  final String query;
  final int count;
  final List<QuranSearchMatch> matches;

  QuranSearchResult({
    required this.query,
    required this.count,
    required this.matches,
  });

  factory QuranSearchResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return QuranSearchResult(
      query: data['query'] ?? '',
      count: data['count'] ?? 0,
      matches: (data['matches'] as List<dynamic>?)?.map((match) => QuranSearchMatch.fromJson(match)).toList() ?? [],
    );
  }

  factory QuranSearchResult.empty(String query) {
    return QuranSearchResult(query: query, count: 0, matches: []);
  }
}

/// QuranSearchMatch class implementation
class QuranSearchMatch {
  final int number;
  final String text;
  final QuranEdition edition;
  final QuranSurahInfo surah;
  final int numberInSurah;

  QuranSearchMatch({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
  });

  factory QuranSearchMatch.fromJson(Map<String, dynamic> json) {
    return QuranSearchMatch(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      edition: json['edition'] != null
          ? QuranEdition.fromJson(json['edition'])
          : QuranEdition(
              identifier: 'unknown',
              language: 'en',
              name: 'Unknown',
              englishName: 'Unknown',
              format: 'text',
              type: 'translation',
            ),
      surah: json['surah'] != null
          ? QuranSurahInfo.fromJson(json['surah'])
          : QuranSurahInfo(
              number: 1,
              name: 'Unknown',
              englishName: 'Unknown',
              englishNameTranslation: 'Unknown',
              revelationType: 'Unknown',
            ),
      numberInSurah: json['numberInSurah'] ?? 1,
    );
  }
}

/// QuranVerse class implementation
class QuranVerse {
  final int number;
  final String text;
  final QuranEdition edition;
  final QuranSurahInfo surah;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final dynamic sajda; // Can be bool or object

  QuranVerse({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json, {QuranEdition? edition, QuranSurahInfo? surah}) {
    return QuranVerse(
      number: json['number'],
      text: json['text'],
      edition: edition ?? QuranEdition.fromJson(json['edition'] ?? {}),
      surah: surah ?? QuranSurahInfo.fromJson(json['surah'] ?? {}),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'],
    );
  }
}

/// QuranSurah class implementation
class QuranSurah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<QuranVerse> ayahs;

  QuranSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    final edition = QuranEdition.fromJson(json['edition'] ?? {});
    final surahInfo = QuranSurahInfo(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
    );

    return QuranSurah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      ayahs: (json['ayahs'] as List<dynamic>)
          .map((ayah) => QuranVerse.fromJson(ayah, edition: edition, surah: surahInfo))
          .toList(),
    );
  }
}

/// QuranSurahInfo class implementation
class QuranSurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;

  QuranSurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
  });

  factory QuranSurahInfo.fromJson(Map<String, dynamic> json) {
    return QuranSurahInfo(
      number: json['number'] ?? 1,
      name: json['name'] ?? 'Unknown',
      englishName: json['englishName'] ?? 'Unknown',
      englishNameTranslation: json['englishNameTranslation'] ?? 'Unknown',
      revelationType: json['revelationType'] ?? 'Unknown',
    );
  }
}

/// QuranEdition class implementation
class QuranEdition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  QuranEdition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory QuranEdition.fromJson(Map<String, dynamic> json) {
    return QuranEdition(
      identifier: json['identifier'] ?? 'unknown',
      language: json['language'] ?? 'en',
      name: json['name'] ?? 'Unknown',
      englishName: json['englishName'] ?? 'Unknown',
      format: json['format'] ?? 'text',
      type: json['type'] ?? 'translation',
      direction: json['direction'],
    );
  }
}

/// QuranMeta class implementation
class QuranMeta {
  final Map<String, int> ayahs;
  final Map<String, dynamic> surahs;
  final Map<String, dynamic> juzs;
  final Map<String, dynamic> pages;
  final Map<String, dynamic> manzils;
  final Map<String, dynamic> rukus;
  final Map<String, dynamic> hizbQuarters;

  QuranMeta({
    required this.ayahs,
    required this.surahs,
    required this.juzs,
    required this.pages,
    required this.manzils,
    required this.rukus,
    required this.hizbQuarters,
  });

  factory QuranMeta.fromJson(Map<String, dynamic> json) {
    return QuranMeta(
      ayahs: Map<String, int>.from(json['ayahs']),
      surahs: json['surahs'],
      juzs: json['juzs'],
      pages: json['pages'],
      manzils: json['manzils'],
      rukus: json['rukus'],
      hizbQuarters: json['hizbQuarters'],
    );
  }
}

/// QuranApiException class implementation
class QuranApiException implements Exception {
  final String message;

  QuranApiException(this.message);

  @override
  String toString() => 'QuranApiException: $message';
}
