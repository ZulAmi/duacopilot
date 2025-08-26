# DuaCopilot - GitHub Pages Deployment

## Automatic Deployment

This project is automatically deployed to GitHub Pages using GitHub Actions whenever code is pushed to the `main` branch.

**Live Demo:** [https://zulami.github.io/duacopilot/](https://zulami.github.io/duacopilot/)

## Setup Instructions

### 1. Enable GitHub Pages

1. Go to your GitHub repository settings
2. Navigate to "Pages" in the left sidebar
3. Under "Source", select "GitHub Actions"
4. The deployment workflow will automatically trigger on the next push

### 2. Repository Settings

Make sure your repository has the following settings:
- **Repository name:** `duacopilot` (or update the `--base-href` in the workflow)
- **Visibility:** Public (required for free GitHub Pages)

### 3. Workflow Configuration

The deployment workflow (`.github/workflows/deploy-web.yml`) includes:
- ✅ Flutter web build with proper base href
- ✅ Code analysis and testing
- ✅ Automatic deployment to GitHub Pages
- ✅ Concurrent deployment protection

## Manual Build and Deployment

If you want to build and deploy manually:

```bash
# Enable web support
flutter config --enable-web

# Build for web
flutter build web --release --base-href "/duacopilot/"

# The built files will be in build/web/
```

## Features Deployed

- 🕌 **Islamic Du'a Search** - AI-powered Du'a recommendations
- 🕐 **Prayer Times** - Accurate prayer time calculations
- 🧭 **Qibla Direction** - Find the direction to Mecca
- 📅 **Islamic Calendar** - Hijri dates and Islamic events
- 📖 **Quran & Hadith** - Islamic texts and references
- 🎵 **Audio Recitations** - Professional Du'a recitations
- 🌙 **Ramadan Features** - Special Ramadan functionality
- 🤝 **Family Sharing** - Share Du'as with family members

## Technical Details

- **Framework:** Flutter Web
- **Deployment:** GitHub Pages via GitHub Actions
- **Build Tool:** Flutter 3.24.0+
- **Optimization:** Tree-shaking enabled, web-optimized assets
- **PWA Support:** Progressive Web App capabilities
- **Responsive Design:** Works on mobile, tablet, and desktop

## Troubleshooting

### Common Issues:

1. **404 Errors:** The `404.html` file handles client-side routing
2. **Base Href:** Ensure the `--base-href` matches your repository name
3. **Assets:** All assets are relative to the base href
4. **CORS:** Some features may be limited in web browsers due to CORS policies

### Workflow Failures:

Check the Actions tab in your repository for build logs and error details.

## Local Development

```bash
# Run in development mode
flutter run -d chrome --web-port 8080

# Run with dev configuration
flutter run --target lib/main_dev.dart -d chrome --web-port 8080
```

## Security Note

The web deployment includes:
- 🔒 Content Security Policy headers
- 🔒 Secure asset loading
- 🔒 Privacy-first approach (no tracking)
- 🔒 Offline functionality for core features
