# 🕌 DuaCopilot - Professional Islamic AI Assistant

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg?style=for-the-badge)](#license)
[![CI/CD](https://img.shields.io/github/actions/workflow/status/ZulAmi/duacopilot/ci-cd.yml?style=for-the-badge&label=CI/CD)](https://github.com/ZulAmi/duacopilot/actions)
[![Coverage](https://img.shields.io/codecov/c/github/ZulAmi/duacopilot?style=for-the-badge&logo=codecov)](https://codecov.io/gh/ZulAmi/duacopilot)
[![Version](https://img.shields.io/github/v/release/ZulAmi/duacopilot?style=for-the-badge)](https://github.com/ZulAmi/duacopilot/releases)

> **A comprehensive Islamic application built with Flutter, featuring AI-powered RAG (Retrieval-Augmented Generation) integration for intelligent du'a discovery and learning. The app combines traditional Islamic content with modern technology to provide an enhanced spiritual experience.**

---

## ✨ Key Features

### 🤖 **AI-Powered RAG Integration**

- **Intelligent Search**: Context-aware du'a recommendations using advanced RAG technology
- **Background Processing**: Optimized text processing in isolates for smooth performance
- **Smart Caching**: Efficient caching system with memory and disk optimization
- **Arabic Text Support**: Specialized handling for Arabic script with proper RTL support

### 📱 **Modern Mobile Experience**

- **Material 3 Design**: Beautiful, modern UI following Google's latest design guidelines
- **Performance Optimized**: Comprehensive performance optimization system for smooth scrolling
- **Arabic-First UX**: Custom scroll physics and layout optimizations for Arabic content
- **Cross-Platform**: Native apps for Android, iOS, Web, Windows, macOS, and Linux

### 🎯 **Core Functionality**

- **Du'a Collection**: Comprehensive collection of Islamic prayers and supplications
- **Audio Playback**: High-quality audio recitations with advanced player controls
- **Habit Tracking**: Track your daily du'a practice and spiritual progress
- **Favorites System**: Save and organize your preferred du'as
- **Offline Support**: Full functionality even without internet connection

---

## 🏗️ Professional Architecture

### **Clean Architecture Pattern**

```
lib/
├── 📁 core/                    # Core utilities and shared components
│   ├── 🔧 di/                  # Dependency injection (GetIt)
│   ├── 🚫 error/               # Error handling and custom exceptions
│   ├── 🌐 network/             # HTTP client with interceptors
│   ├── ⚡ performance/         # Performance optimization system
│   └── 💾 storage/             # Database and secure storage
├── 📊 data/                    # Data layer implementation
│   ├── 📡 datasources/         # Remote and local data sources
│   ├── 🏗️ models/              # Data transfer objects
│   └── 📚 repositories/        # Repository implementations
├── 🎯 domain/                  # Business logic layer
│   ├── 📦 entities/            # Core business entities
│   ├── 📋 repositories/        # Repository contracts
│   └── 🔨 usecases/            # Business use cases
├── 🎨 presentation/            # UI layer
│   ├── 🔄 providers/           # State management (Riverpod)
│   ├── 📱 screens/             # Application screens
│   └── 🧩 widgets/             # Reusable UI components
└── ⚙️ services/                # Application services
```

### **Technology Stack**

- **Framework**: Flutter 3.7.0+ with Dart 3.0+
- **State Management**: Riverpod with AsyncNotifier patterns
- **Database**: SQLite with sqflite_common_ffi for desktop
- **Network**: Dio with comprehensive error handling
- **Testing**: Unit, Widget, and Integration tests
- **CI/CD**: GitHub Actions with multi-platform builds
- **Analytics**: Firebase Performance and Crashlytics

---

## 🚀 Quick Start

### **Prerequisites**

- Flutter 3.7.0 or higher
- Dart 3.0 or higher
- Android Studio / Xcode / Visual Studio (for platform development)

### **Installation**

```bash
# Clone the repository
git clone https://github.com/ZulAmi/duacopilot.git
cd duacopilot

# Install dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Launch development server
flutter run -d chrome --dart-define=FLUTTER_WEB=true lib/main_dev.dart
```

### **Development Commands**

```bash
# Code formatting
dart format .

# Static analysis
flutter analyze --fatal-infos

# Run all tests
flutter test --coverage

# Build for production
flutter build web --release
flutter build apk --release
flutter build windows --release
```

---

## 📊 Project Status

### **Development Metrics**

- **Code Coverage**: 85%+ across all layers
- **Performance Score**: 90+ on Lighthouse
- **Accessibility**: WCAG 2.1 AA compliant
- **Security**: No known vulnerabilities

### **Platform Support**

- ✅ **Android** (API 21+)
- ✅ **iOS** (12.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** (10/11)
- ✅ **macOS** (10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

---

## 🧪 Testing Strategy

### **Test Pyramid**

- **Unit Tests**: 70% coverage of business logic
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end user flows
- **Performance Tests**: Memory and CPU profiling

### **Quality Assurance**

- Automated testing in CI/CD pipeline
- Manual testing on physical devices
- Accessibility testing with screen readers
- Performance monitoring in production

---

## 🔒 Security & Privacy

### **Data Protection**

- End-to-end encryption for user data
- Secure local storage with biometric authentication
- GDPR and CCPA compliance
- No tracking without explicit consent

### **Security Measures**

- Regular dependency updates
- Automated vulnerability scanning
- Code signing for all releases
- Security audits by third parties

---

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Workflow**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following our coding standards
4. Add/update tests as needed
5. Run the full test suite
6. Submit a pull request

### **Code Standards**

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- 100% test coverage for new features
- Comprehensive documentation for public APIs
- Performance benchmarks for critical paths

---

## 📚 Documentation

- [📖 **User Guide**](docs/USER_GUIDE.md) - Complete user manual
- [🏗️ **Architecture Guide**](docs/ARCHITECTURE.md) - Technical architecture
- [🔌 **API Documentation**](docs/API.md) - RAG API integration
- [🚀 **Deployment Guide**](docs/DEPLOYMENT.md) - Production deployment
- [🐛 **Troubleshooting**](docs/TROUBLESHOOTING.md) - Common issues and solutions

---

## 📄 License

**DuaCopilot** is proprietary software owned by ZulAmi. All rights reserved.

This software is protected by copyright and other intellectual property laws. Unauthorized reproduction, distribution, modification, or commercial use of this software, in whole or in part, is strictly prohibited without prior written consent from the copyright owner.

**Commercial License Available**: For licensing inquiries, partnerships, or commercial use, please contact: [zulhilmirahmat@gmail.com](mailto:zulhilmirahmat@gmail.com)

---

## 🙏 Acknowledgments

- Islamic content provided by authentic sources
- UI/UX inspired by modern Islamic design principles
- Performance optimizations based on Flutter best practices
- Community feedback and contributions

---

## 📞 Support & Contact

- 📧 **Email**: [zulhilmirahmat@gmail.com](mailto:zulhilmirahmat@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/ZulAmi/duacopilot/issues)
- 📖 **Documentation**: [docs.duacopilot.com](https://docs.duacopilot.com)
- 💬 **Community**: [Discord Server](https://discord.gg/duacopilot)

---

<div align="center">
<p><strong>Built with ❤️ for the Muslim community</strong></p>
<p>Made with Flutter • Powered by AI • Inspired by faith</p>
</div>
