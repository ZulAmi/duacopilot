# Secure API Key Configuration

This project uses a secure environment configuration system to protect sensitive API keys from being exposed in source code.

## Quick Start

1. **Create Environment File**: Copy `.env.example` to `.env` in the project root
2. **Add Your API Keys**: Edit `.env` with your actual API keys
3. **Never Commit .env**: The `.env` file is gitignored and should never be committed

## Environment File Setup

```bash
# Copy the example file
cp .env.example .env

# Edit with your API keys
notepad .env  # Windows
nano .env     # Linux/Mac
```

## Required API Keys

### OpenAI (Primary)

- **Purpose**: Main AI provider for RAG responses
- **Get Key**: [OpenAI API Keys](https://platform.openai.com/api-keys)
- **Environment Variable**: `OPENAI_API_KEY`

### Claude (Anthropic) - Optional

- **Purpose**: Alternative AI provider
- **Get Key**: [Anthropic Console](https://console.anthropic.com/)
- **Environment Variable**: `CLAUDE_API_KEY`

### Gemini (Google) - Optional

- **Purpose**: Alternative AI provider
- **Get Key**: [Google AI Studio](https://makersuite.google.com/app/apikey)
- **Environment Variable**: `GEMINI_API_KEY`

### HuggingFace - Optional

- **Purpose**: Open-source model access
- **Get Key**: [HuggingFace Tokens](https://huggingface.co/settings/tokens)
- **Environment Variable**: `HUGGINGFACE_API_KEY`

## Security Features

✅ **Environment Files Protected**: `.env` files are automatically gitignored  
✅ **Secure Storage**: API keys stored in device secure storage  
✅ **Runtime Loading**: Keys loaded only at runtime, never in code  
✅ **Multiple Providers**: Fallback system if primary provider fails  
✅ **Debug Logging**: Clear logs about key configuration status

## How It Works

1. **Environment Loading**: `EnvironmentConfig` loads `.env` file on app start
2. **Secure Storage**: Keys transferred to device secure storage
3. **Runtime Access**: Services access keys from secure storage
4. **Graceful Fallback**: App continues with limited functionality if keys missing

## Development vs Production

### Development

- Use `.env` file for local development
- Keys loaded from file into secure storage
- Debug logs show configuration status

### Production

- Use platform environment variables
- Deploy with secure key management
- No `.env` file in production builds

## Common Issues

### "API key not configured" Error

```
⚠️ OpenAI API key not found in environment - configure in .env file or settings
```

**Solution**: Create `.env` file with `OPENAI_API_KEY=your_key_here`

### Keys Not Loading

1. Check `.env` file exists in project root
2. Verify format: `KEY_NAME=value` (no spaces around =)
3. Restart app after changing `.env`

### GitHub Push Rejected

If you accidentally commit API keys:

1. Remove keys from code immediately
2. Use this secure system instead
3. Revoke and regenerate compromised keys

## Best Practices

🔒 **Never commit API keys in source code**  
🔒 **Use different keys for development/production**  
🔒 **Regularly rotate API keys**  
🔒 **Monitor API usage and billing**  
🔒 **Use least-privilege API permissions**

## Example .env File

```env
# AI Provider API Keys
OPENAI_API_KEY=sk-...your-openai-key-here
CLAUDE_API_KEY=sk-ant-...your-claude-key-here
GEMINI_API_KEY=...your-gemini-key-here
HUGGINGFACE_API_KEY=hf_...your-hf-key-here

# Optional Configuration
DEBUG_MODE=true
LOG_LEVEL=debug
```

## Need Help?

- 📚 Check the main [Development Guide](DEV_GUIDE.md)
- 🔧 See [Production Setup Guide](PRODUCTION_SETUP_COMPLETE.md)
- 🚀 Review [AWS Setup Guide](AWS_SETUP_GUIDE.md)
