/// RAG API Configuration
class RagConfig {
  // Option 1: OpenAI GPT-4 (Most popular)
  static const String openAiApiUrl = 'https://api.openai.com/v1';
  static const String openAiModel = 'gpt-4o-mini'; // Cost-effective option

  // Option 2: Anthropic Claude (Best for reasoning)
  static const String claudeApiUrl = 'https://api.anthropic.com/v1';
  static const String claudeModel = 'claude-3-haiku-20240307'; // Cost-effective

  // Option 3: Google Gemini (Free tier available)
  static const String geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-1.5-flash'; // Fast and free

  // Option 4: Ollama (Local/Self-hosted)
  static const String ollamaApiUrl = 'http://localhost:11434/api';
  static const String ollamaModel = 'llama3.1:8b'; // Local model

  // Option 5: Hugging Face (Open source)
  static const String huggingFaceApiUrl =
      'https://api-inference.huggingface.co/models';
  static const String huggingFaceModel = 'microsoft/DialoGPT-large';

  // Current configuration (change this to switch providers)
  static const String currentProvider =
      'openai'; // Change to: openai, claude, gemini, ollama, huggingface

  // Islamic context prompt
  static const String islamicSystemPrompt = '''
You are DuaCopilot, an Islamic AI assistant specializing in providing authentic Islamic guidance.

GUIDELINES:
- Always provide answers based on Quran and authentic Hadith
- Include Arabic text with English translations when relevant
- Cite sources (Quran verse/chapter or Hadith reference)
- Be respectful and sensitive to Islamic beliefs
- If unsure about Islamic ruling, recommend consulting a scholar
- Focus on authentic sources: Sahih Bukhari, Sahih Muslim, etc.

RESPONSE FORMAT:
- Provide clear, actionable Islamic guidance
- Include relevant duas (Arabic + transliteration + translation)
- Add source citations
- Keep responses concise but comprehensive
''';
}
