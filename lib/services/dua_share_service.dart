import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../domain/entities/dua_entity.dart';

class DuaShareService {
  static Future<void> shareDua(
    DuaEntity dua, {
    bool includeArabic = true,
    bool includeTransliteration = true,
    bool includeTranslation = true,
    bool includeSource = true,
    bool includeAttribution = true,
  }) async {
    final shareText = formatDuaForSharing(
      dua,
      includeArabic: includeArabic,
      includeTransliteration: includeTransliteration,
      includeTranslation: includeTranslation,
      includeSource: includeSource,
      includeAttribution: includeAttribution,
    );

    await Share.share(shareText, subject: 'Du\'a: ${dua.category}');
  }

  static Future<void> copyToClipboard(
    DuaEntity dua, {
    bool includeArabic = true,
    bool includeTransliteration = true,
    bool includeTranslation = true,
    bool includeSource = true,
    bool includeAttribution = false,
  }) async {
    final copyText = formatDuaForSharing(
      dua,
      includeArabic: includeArabic,
      includeTransliteration: includeTransliteration,
      includeTranslation: includeTranslation,
      includeSource: includeSource,
      includeAttribution: includeAttribution,
    );

    await Clipboard.setData(ClipboardData(text: copyText));
  }

  static String formatDuaForSharing(
    DuaEntity dua, {
    bool includeArabic = true,
    bool includeTransliteration = true,
    bool includeTranslation = true,
    bool includeSource = true,
    bool includeAttribution = true,
  }) {
    final buffer = StringBuffer();

    // Title/Category
    buffer.writeln('📿 ${dua.category}');
    buffer.writeln();

    // Arabic text with proper formatting
    if (includeArabic) {
      buffer.writeln('🔸 Arabic:');
      buffer.writeln(dua.arabicText);
      buffer.writeln();
    }

    // Transliteration
    if (includeTransliteration) {
      buffer.writeln('🔸 Transliteration:');
      buffer.writeln(dua.transliteration);
      buffer.writeln();
    }

    // Translation
    if (includeTranslation) {
      buffer.writeln('🔸 Translation:');
      buffer.writeln(dua.translation);
      buffer.writeln();
    }

    // Source and authenticity
    if (includeSource) {
      buffer.writeln('📖 Source: ${dua.authenticity.source}');
      if (dua.authenticity.reference.isNotEmpty) {
        buffer.writeln('📋 Reference: ${dua.authenticity.reference}');
      }
      if (dua.authenticity.hadithGrade != null) {
        buffer.writeln('⭐ Grade: ${dua.authenticity.hadithGrade}');
      }
      buffer.writeln('✅ Authenticity: ${dua.authenticity.level.displayName}');
      buffer.writeln();
    }

    // Context (if available)
    if (dua.context != null && dua.context!.isNotEmpty) {
      buffer.writeln('ℹ️ Context:');
      buffer.writeln(dua.context);
      buffer.writeln();
    }

    // Benefits (if available)
    if (dua.benefits != null && dua.benefits!.isNotEmpty) {
      buffer.writeln('🌟 Benefits:');
      buffer.writeln(dua.benefits);
      buffer.writeln();
    }

    // Tags
    if (dua.tags.isNotEmpty) {
      buffer.writeln('🏷️ Tags: ${dua.tags.join(', ')}');
      buffer.writeln();
    }

    // Attribution
    if (includeAttribution) {
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('📱 Shared from Dua Copilot');
      buffer.writeln('🤖 Islamic Search Assistant');
      buffer.writeln('💝 May Allah accept our supplications');
    }

    return buffer.toString();
  }

  static Future<void> shareAsImage(DuaEntity dua) async {
    // This would generate a beautiful image with Arabic calligraphy
    // For now, we'll just share as text
    await shareDua(dua);
  }

  static Future<void> shareAudioLink(DuaEntity dua) async {
    if (dua.audioUrl == null) return;

    final message = '''
🎧 Listen to the recitation of: ${dua.category}

📖 ${dua.translation}

🔗 Audio: ${dua.audioUrl}

📱 Shared from Dua Copilot - Islamic Search Assistant
''';

    await Share.share(message);
  }

  static Future<void> shareToWhatsApp(DuaEntity dua) async {
    final shareText = formatDuaForSharing(dua);
    final encodedText = Uri.encodeComponent(shareText);
    final whatsappUrl = 'https://wa.me/?text=$encodedText';

    // In a real app, you would use url_launcher to open WhatsApp
    await Share.share(shareText);
  }

  static Future<void> shareToSocialMedia(
    DuaEntity dua, {
    required String platform,
  }) async {
    String shareText;

    switch (platform.toLowerCase()) {
      case 'twitter':
        shareText = _formatForTwitter(dua);
        break;
      case 'facebook':
        shareText = _formatForFacebook(dua);
        break;
      case 'instagram':
        shareText = _formatForInstagram(dua);
        break;
      default:
        shareText = formatDuaForSharing(dua);
    }

    await Share.share(shareText);
  }

  static String _formatForTwitter(DuaEntity dua) {
    // Twitter has character limits, so we'll keep it concise
    return '''
📿 ${dua.category}

${dua.translation}

Source: ${dua.authenticity.source}

#Dua #Islam #Prayer #Islamic #Spirituality
''';
  }

  static String _formatForFacebook(DuaEntity dua) {
    return formatDuaForSharing(
      dua,
      includeArabic: true,
      includeTransliteration: false, // Less clutter for Facebook
      includeTranslation: true,
      includeSource: true,
      includeAttribution: true,
    );
  }

  static String _formatForInstagram(DuaEntity dua) {
    return '''
📿 ${dua.category}

${dua.arabicText}

"${dua.translation}"

Source: ${dua.authenticity.source}

#Dua #Islam #Prayer #Islamic #Spirituality #Peace #Faith #Blessings #Muslim #Quran #Hadith #Dhikr
''';
  }

  static Map<String, String> getShareFormats(DuaEntity dua) {
    return {
      'Full': formatDuaForSharing(dua),
      'Arabic Only': formatDuaForSharing(
        dua,
        includeArabic: true,
        includeTransliteration: false,
        includeTranslation: false,
        includeSource: true,
      ),
      'Translation Only': formatDuaForSharing(
        dua,
        includeArabic: false,
        includeTransliteration: false,
        includeTranslation: true,
        includeSource: true,
      ),
      'Social Media': _formatForInstagram(dua),
      'Minimal': '''
${dua.category}
${dua.translation}
Source: ${dua.authenticity.source}
''',
    };
  }
}
