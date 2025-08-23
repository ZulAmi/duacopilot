import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/rag_config.dart';
import '../../core/di/injection_container.dart' as di;
import '../../data/datasources/working_rag_api_service.dart';

/// RAG System Setup Screen for configuring API providers
class RagSetupScreen extends StatefulWidget {
  const RagSetupScreen({super.key});

  @override
  State<RagSetupScreen> createState() => _RagSetupScreenState();
}

class _RagSetupScreenState extends State<RagSetupScreen> {
  String _selectedProvider = RagConfig.currentProvider;
  final _apiKeyController = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentApiKey();
  }

  Future<void> _loadCurrentApiKey() async {
    try {
      final ragService = di.sl<RagApiService>();
      // Note: We can't read the key back for security reasons
      setState(() {
        _statusMessage = 'Current provider: $_selectedProvider';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading configuration: $e';
      });
    }
  }

  Future<void> _saveConfiguration() async {
    if (_apiKeyController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = 'Please enter an API key';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Saving configuration...';
    });

    try {
      final ragService = di.sl<RagApiService>();
      await ragService.setApiKey(_apiKeyController.text.trim());

      setState(() {
        _isLoading = false;
        _statusMessage = '✅ Configuration saved! Restart the app to use $_selectedProvider';
      });

      // Clear the input for security
      _apiKeyController.clear();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ Error saving configuration: $e';
      });
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing connection...';
    });

    try {
      final ragService = di.sl<RagApiService>();
      // You would implement a simple test query here
      setState(() {
        _isLoading = false;
        _statusMessage = '✅ Connection test would go here (implement in real app)';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ Connection test failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAG System Setup'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🤖 RAG Provider Selection',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Choose your AI provider:'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedProvider,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'AI Provider'),
                      items: const [
                        DropdownMenuItem(value: 'openai', child: Text('OpenAI GPT-4 (Most Popular)')),
                        DropdownMenuItem(value: 'claude', child: Text('Anthropic Claude (Best Reasoning)')),
                        DropdownMenuItem(value: 'gemini', child: Text('Google Gemini (Free Tier Available)')),
                        DropdownMenuItem(value: 'ollama', child: Text('Ollama (Local/Self-hosted)')),
                        DropdownMenuItem(value: 'huggingface', child: Text('Hugging Face (Open Source)')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedProvider = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔑 API Key Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'API Key for $_selectedProvider',
                        hintText: _getApiKeyHint(_selectedProvider),
                        suffixIcon: IconButton(icon: const Icon(Icons.paste), onPressed: _pasteFromClipboard),
                      ),
                      obscureText: true,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(_getProviderInfo(_selectedProvider), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveConfiguration,
                    icon:
                        _isLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.save),
                    label: const Text('Save Configuration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testConnection,
                  icon: const Icon(Icons.wifi_protected_setup),
                  label: const Text('Test'),
                ),
              ],
            ),

            if (_statusMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      _statusMessage!.startsWith('✅')
                          ? Colors.green.withOpacity(0.1)
                          : _statusMessage!.startsWith('❌')
                          ? Colors.red.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        _statusMessage!.startsWith('✅')
                            ? Colors.green
                            : _statusMessage!.startsWith('❌')
                            ? Colors.red
                            : Colors.blue,
                  ),
                ),
                child: Text(_statusMessage!),
              ),
            ],

            const Spacer(),

            Card(
              color: Colors.orange.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📝 Quick Setup Guide', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('1. Choose your preferred AI provider above'),
                    Text('2. Get an API key from the provider\'s website'),
                    Text('3. Paste the API key and save configuration'),
                    Text('4. Restart the app to activate the RAG system'),
                    SizedBox(height: 8),
                    Text(
                      '💡 The Islamic RAG service will work as fallback even without API keys!',
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getApiKeyHint(String provider) {
    switch (provider) {
      case 'openai':
        return 'sk-...';
      case 'claude':
        return 'sk-ant-...';
      case 'gemini':
        return 'AI...';
      case 'huggingface':
        return 'hf_...';
      case 'ollama':
        return 'No API key needed for local Ollama';
      default:
        return 'Enter your API key';
    }
  }

  String _getProviderInfo(String provider) {
    switch (provider) {
      case 'openai':
        return 'Get API key from: https://platform.openai.com/api-keys\nCost: ~\$0.002 per 1K tokens';
      case 'claude':
        return 'Get API key from: https://console.anthropic.com\nCost: ~\$0.25 per 1M tokens';
      case 'gemini':
        return 'Get API key from: https://aistudio.google.com/app/apikey\nCost: Free tier available';
      case 'ollama':
        return 'Install Ollama locally: https://ollama.com\nCost: Free (runs on your computer)';
      case 'huggingface':
        return 'Get token from: https://huggingface.co/settings/tokens\nCost: Free tier available';
      default:
        return '';
    }
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData?.text != null) {
        _apiKeyController.text = clipboardData!.text!;
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to paste from clipboard: $e';
      });
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
}
