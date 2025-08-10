import '../domain/entities/dua_entity.dart';

class MockDuaDataService {
  static List<DuaEntity> getSampleDuas() {
    return [
      DuaEntity(
        id: '1',
        arabicText: '''بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ
الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
الرَّحْمَنِ الرَّحِيمِ
مَالِكِ يَوْمِ الدِّينِ
إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ
صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ''',
        transliteration: '''Bismillahi Rahmanir Raheem
Alhamdu lillahi rabbil alameen
Ar-Rahmanir Raheem
Maliki yaumid deen
Iyyaka na'budu wa iyyaka nasta'een
Ihdinassiratal mustaqeem
Siratal lazeena an'amta alaihim ghairil maghdoobi alaihim walad daaleen''',
        translation:
            '''In the name of Allah, the Most Gracious, the Most Merciful.
All praise is due to Allah, Lord of all the worlds.
The Most Gracious, the Most Merciful.
Master of the Day of Judgment.
You alone we worship, and You alone we ask for help.
Guide us to the straight path.
The path of those You have blessed, not of those who have incurred Your wrath, nor of those who have gone astray.''',
        category: 'Al-Fatiha (The Opening)',
        tags: ['prayer', 'quran', 'opening', 'daily', 'essential'],
        authenticity: SourceAuthenticity(
          level: AuthenticityLevel.quran,
          source: 'Holy Quran',
          reference: 'Surah Al-Fatiha (1:1-7)',
          confidenceScore: 1.0,
        ),
        ragConfidence: RAGConfidence(
          score: 0.98,
          reasoning:
              '''This is the opening chapter of the Quran, recited in every unit of prayer. It's perfectly matched for morning prayers as it contains praise, guidance seeking, and establishes the relationship with Allah. The RAG system identified this as highly relevant due to the user's query about morning prayers and the universal nature of Al-Fatiha.''',
          keywords: ['morning', 'prayer', 'guidance', 'worship', 'praise'],
          contextMatch: ContextMatch(
            relevanceScore: 0.95,
            category: 'Daily Prayers',
            matchingCriteria: [
              'Essential for all prayers',
              'Contains morning supplications theme',
              'Establishes connection with Allah',
              'Seeks guidance for the day ahead',
            ],
            timeOfDay: 'Universal - suitable for all times',
            situation: 'Daily prayer routine',
          ),
          supportingEvidence: [
            'Recited in every prayer unit (Sahih Bukhari)',
            'Called "Umm al-Kitab" (Mother of the Book)',
            'Contains all essential elements of worship',
          ],
        ),
        audioUrl: 'https://example.com/audio/fatiha.mp3',
        context:
            '''Al-Fatiha is the opening chapter of the Quran and is recited in every unit (rak'ah) of the five daily prayers. It serves as a comprehensive prayer that includes praise of Allah, acknowledgment of His mercy and sovereignty, declaration of worship and seeking help from Him alone, and a request for guidance.''',
        benefits:
            '''Reciting Al-Fatiha brings immense spiritual benefits including establishing a direct connection with Allah, expressing gratitude, seeking guidance, and preparing the heart for the rest of the prayer. It is considered the most important chapter of the Quran.''',
        relatedDuas: ['2', '3', '4'],
        isFavorite: false,
      ),

      DuaEntity(
        id: '2',
        arabicText:
            '''أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ''',
        transliteration:
            '''Asbahna wa asbahal mulku lillah, walhamdu lillah, la ilaha illa Allah wahdahu la shareeka lah, lahul mulku wa lahul hamdu wa huwa ala kulli shay'in qadeer. Rabbi as'aluka khayra ma fee hadhal yawmi wa khayra ma ba'dah, wa a'udhu bika min sharri ma fee hadhal yawmi wa sharri ma ba'dah''',
        translation:
            '''We have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah. There is no deity except Allah, alone without partner. To Him belongs sovereignty and to Him belongs praise, and He is over all things competent. My Lord, I ask You for the good of this day and the good of what follows it, and I take refuge in You from the evil of this day and the evil of what follows it.''',
        category: 'Morning Dhikr',
        tags: ['morning', 'dhikr', 'protection', 'daily', 'sunnah'],
        authenticity: SourceAuthenticity(
          level: AuthenticityLevel.sahih,
          source: 'Sahih Muslim',
          reference: 'Muslim 2723',
          hadithGrade: 'Sahih',
          scholar: 'Imam Muslim',
          confidenceScore: 0.98,
        ),
        ragConfidence: RAGConfidence(
          score: 0.96,
          reasoning:
              '''This morning dhikr is specifically designed for recitation upon waking up or early in the morning. It perfectly matches the user's query about morning prayers and supplications. The dua contains comprehensive elements of praise, declaration of faith, and seeking protection for the day.''',
          keywords: ['morning', 'protection', 'sovereignty', 'praise', 'daily'],
          contextMatch: ContextMatch(
            relevanceScore: 0.98,
            category: 'Morning Supplications',
            matchingCriteria: [
              'Specifically for morning time',
              'Seeks protection for the day',
              'Contains praise and tawhid',
              'Recommended daily practice',
            ],
            timeOfDay: 'Early morning upon waking',
            situation: 'Beginning of the day',
          ),
          supportingEvidence: [
            'Reported from Prophet Muhammad (PBUH)',
            'Part of daily morning remembrance',
            'Provides spiritual protection',
          ],
        ),
        audioUrl: 'https://example.com/audio/morning-dhikr.mp3',
        context:
            '''This is one of the essential morning supplications (adhkar) that Muslims are encouraged to recite daily upon waking up or in the early morning. It establishes the tone for the day by acknowledging Allah's sovereignty and seeking His protection.''',
        benefits:
            '''Regular recitation provides spiritual protection throughout the day, increases God-consciousness, and helps maintain a connection with Allah from the very beginning of the day.''',
        relatedDuas: ['1', '3', '5'],
        isFavorite: true,
      ),

      DuaEntity(
        id: '3',
        arabicText:
            '''بِسْمِ اللهِ تَوَكَّلْتُ عَلَى اللهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ''',
        transliteration:
            '''Bismillahi tawakkaltu alallahi wa la hawla wa la quwwata illa billah''',
        translation:
            '''In the name of Allah, I trust in Allah, and there is no might nor power except with Allah.''',
        category: 'Travel Prayer',
        tags: ['travel', 'protection', 'trust', 'short', 'daily'],
        authenticity: SourceAuthenticity(
          level: AuthenticityLevel.sahih,
          source: 'Sunan Abu Dawud',
          reference: 'Abu Dawud 5095',
          hadithGrade: 'Sahih',
          scholar: 'Abu Dawud',
          confidenceScore: 0.95,
        ),
        ragConfidence: RAGConfidence(
          score: 0.92,
          reasoning:
              '''This is the authentic dua for leaving home and traveling. It emphasizes trust in Allah and acknowledgment that all power belongs to Him. Perfect match for travel-related queries as it specifically addresses protection during movement and journeys.''',
          keywords: ['travel', 'protection', 'trust', 'leaving', 'bismillah'],
          contextMatch: ContextMatch(
            relevanceScore: 0.94,
            category: 'Travel Supplications',
            matchingCriteria: [
              'Specifically for travel',
              'Expresses trust in Allah',
              'Seeks divine protection',
              'Short and easy to memorize',
            ],
            timeOfDay: 'When leaving home',
            situation: 'Beginning of journey',
          ),
          supportingEvidence: [
            'Narrated in authentic hadith collections',
            'Recommended by Prophet Muhammad (PBUH)',
            'Part of travel etiquette in Islam',
          ],
        ),
        audioUrl: 'https://example.com/audio/travel-dua.mp3',
        context:
            '''This dua is to be recited when leaving home for any journey, whether short or long. It expresses complete trust in Allah and seeks His protection and guidance during travel.''',
        benefits:
            '''Provides spiritual protection during travel, increases trust in Allah, and serves as a reminder of dependence on divine guidance and protection.''',
        relatedDuas: ['4', '5', '6'],
        isFavorite: false,
      ),
    ];
  }

  static DuaEntity? findDuaById(String id) {
    try {
      return getSampleDuas().firstWhere((dua) => dua.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<DuaEntity> getRelatedDuas(String currentDuaId) {
    final allDuas = getSampleDuas();
    final currentDua = findDuaById(currentDuaId);

    if (currentDua?.relatedDuas == null) return [];

    return currentDua!.relatedDuas!
        .map((id) => findDuaById(id))
        .where((dua) => dua != null)
        .cast<DuaEntity>()
        .toList();
  }

  static List<DuaEntity> searchDuas(String query) {
    final allDuas = getSampleDuas();
    final lowerQuery = query.toLowerCase();

    return allDuas.where((dua) {
      return dua.category.toLowerCase().contains(lowerQuery) ||
          dua.translation.toLowerCase().contains(lowerQuery) ||
          dua.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          (dua.context?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
