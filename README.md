# DuaCopilot 🕌

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A comprehensive Islamic application built with Flutter, featuring AI-powered RAG (Retrieval-Augmented Generation) integration for intelligent du'a discovery and learning. The app combines traditional Islamic content with modern technology to provide an enhanced spiritual experience.

## ✨ Key Features

### 🤖 AI-Powered RAG Integration

- **Intelligent Search**: Context-aware du'a recommendations using advanced RAG technology
- **Background Processing**: Optimized text processing in isolates for smooth performance
- **Smart Caching**: Efficient caching system with memory and disk optimization
- **Arabic Text Support**: Specialized handling for Arabic script with proper RTL support

### 📱 Modern Mobile Experience

- **Material 3 Design**: Beautiful, modern UI following Google's latest design guidelines
- **Performance Optimized**: Comprehensive performance optimization system for smooth scrolling and interactions
- **Arabic-First UX**: Custom scroll physics and layout optimizations for Arabic content
- **Media Optimization**: Intelligent image and audio processing with compression

### 🎯 Core Functionality

- **Du'a Collection**: Comprehensive collection of Islamic prayers and supplications
- **Audio Playback**: High-quality audio recitations with advanced player controls
- **Habit Tracking**: Track your daily du'a practice and spiritual progress
- **Favorites System**: Save and organize your preferred du'as
- **Offline Support**: Full functionality even without internet connection

### 🏗️ Enterprise-Grade Architecture

- **Clean Architecture**: Proper separation of concerns with domain-driven design
- **Dependency Injection**: Modular and testable code structure
- **State Management**: Reactive state management with Provider pattern
- **Error Handling**: Comprehensive error handling and recovery mechanisms

## 🏗️ Project Architecture

```
lib/
├── core/                           # Core utilities and shared components
│   ├── constants/                  # Application constants and configurations
│   ├── di/                        # Dependency injection setup
│   ├── error/                     # Error handling and custom exceptions
│   ├── network/                   # HTTP client with interceptors
│   ├── performance/               # Performance optimization system
│   │   ├── arabic_scroll_physics.dart     # Custom Arabic scroll behavior
│   │   ├── background_processing.dart     # Isolate-based processing
│   │   ├── media_optimization.dart        # Image/audio optimization
│   │   ├── performance_monitoring.dart    # Firebase performance tracking
│   │   ├── platform_optimizer.dart       # Platform-specific optimizations
│   │   └── performance_integration.dart   # Main performance integration
│   ├── storage/                   # Database and secure storage
│   └── utils/                     # Helper utilities and extensions
├── data/                          # Data layer implementation
│   ├── datasources/              # Remote and local data sources
│   ├── models/                   # Data transfer objects
│   ├── repositories/             # Repository implementations
│   └── mock_dua_data_service.dart # Development data service
├── domain/                        # Business logic layer
│   ├── entities/                 # Core business entities
│   │   ├── dua_entity.dart      # Du'a data structure
│   │   ├── rag_response.dart    # RAG response entities
│   │   └── context_entity.dart  # User context and preferences
│   ├── repositories/             # Repository contracts
│   └── usecases/                # Business use cases
├── presentation/                  # UI layer
│   ├── providers/               # State management providers
│   │   ├── rag_provider.dart   # RAG functionality state
│   │   └── rag_debug_provider.dart # Development debugging
│   ├── screens/                 # Main application screens
│   │   └── dua_display_screen.dart # Primary du'a viewing interface
│   └── widgets/                 # Reusable UI components
│       ├── dua_display/         # Du'a-specific widgets
│       └── optimized_rag_list_view.dart # Performance-optimized ListView
├── services/                      # Application services
│   ├── habits/                  # Habit tracking functionality
│   └── dua_share_service.dart   # Social sharing capabilities
└── examples/                      # Usage examples and demos
    └── performance_example.dart  # Performance optimization examples
```

## � Technology Stack

### **Core Framework**

- **Flutter 3.7.0+** - Cross-platform mobile development
- **Dart 3.0+** - Modern programming language with null safety

### **State Management & Architecture**

- **Provider Pattern** - Reactive state management
- **Clean Architecture** - Separation of concerns and testability
- **Dependency Injection** - Modular and maintainable code structure

### **AI & Performance**

- **RAG Integration** - Retrieval-Augmented Generation for intelligent content discovery
- **Isolate Processing** - Background processing for heavy computations
- **Firebase Performance** - Real-time performance monitoring
- **Custom Scroll Physics** - Optimized for Arabic content

### **Storage & Networking**

- **SQLite** - Local database for offline functionality
- **Secure Storage** - Encrypted storage for sensitive data
- **HTTP Client** - Network requests with retry and caching logic

### **Media & Optimization**

- **Cached Network Image** - Efficient image loading and caching
- **Image Compression** - Optimized media processing
- **Background Compute** - CPU-intensive tasks in isolates

## 🛠️ Getting Started

### Prerequisites

- **Flutter SDK**: 3.7.0 or higher
- **Dart SDK**: 3.0 or higher
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Platform Tools**: Android SDK / Xcode (for respective platforms)

### Installation & Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/duacopilot.git
   cd duacopilot
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase (Optional)**

   ```bash
   # Add your google-services.json (Android) and GoogleService-Info.plist (iOS)
   # Configure Firebase Performance Monitoring
   ```

4. **Run the application**

   ```bash
   # Development build
   flutter run

   # Release build
   flutter run --release
   ```

### Configuration

#### Performance Optimization

The app includes a comprehensive performance optimization system. To customize:

```dart
// Configure performance settings
PerformanceIntegration.configure(
  enableArabicOptimizations: true,
  enableBackgroundProcessing: true,
  enableMediaOptimization: true,
  enablePerformanceMonitoring: true,
);
```

#### RAG Integration

Configure your RAG API endpoints:

```dart
// Set up RAG service
final ragConfig = RagConfiguration(
  apiEndpoint: 'your-rag-api-endpoint',
  apiKey: 'your-api-key',
  enableCaching: true,
  enableBackgroundProcessing: true,
);
```

## 📊 Performance Features

### Arabic Content Optimization

- **Custom Scroll Physics**: Optimized scrolling behavior for Arabic text
- **RTL Layout Support**: Proper right-to-left text rendering
- **Text Shaping**: Advanced Arabic text shaping and ligature support

### Background Processing

- **Isolate-Based Computing**: Heavy text processing in background isolates
- **Smart Caching**: Intelligent cache management with LRU eviction
- **Progressive Loading**: Gradual content loading for better UX

### Media Optimization

- **Image Compression**: Automatic image optimization and resizing
- **Lazy Loading**: On-demand resource loading
- **Memory Management**: Efficient memory usage patterns

## 🧪 Development & Testing

### Code Generation

```bash
# Generate code for models and providers
flutter packages pub run build_runner build

# Watch for changes during development
flutter packages pub run build_runner watch
```

### Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Code Analysis

```bash
# Analyze code quality
flutter analyze

# Format code
flutter format .
```

## 📱 Platform Support

| Platform   | Status          | Notes                                              |
| ---------- | --------------- | -------------------------------------------------- |
| 📱 Android | ✅ Full Support | Optimized for Android 5.0+                         |
| 🍎 iOS     | ✅ Full Support | Optimized for iOS 12.0+                            |
| 🌐 Web     | ⚠️ Limited      | Basic functionality, limited background processing |
| 🖥️ Desktop | ⚠️ Limited      | Windows/macOS/Linux support with limitations       |

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow the established architecture patterns
- Write comprehensive tests for new features
- Ensure code passes analysis (`flutter analyze`)
- Update documentation for significant changes

## 📖 Documentation

- [Performance Optimization Guide](lib/core/performance/README.md)
- [API Documentation](docs/api.md)
- [Architecture Guide](docs/architecture.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## � Security & Privacy

- **Data Encryption**: Sensitive data encrypted at rest
- **Secure Storage**: API keys and tokens stored securely
- **Privacy First**: No unnecessary data collection
- **Offline Capable**: Core functionality works without internet

## �📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## � Acknowledgments

- **Flutter Team** - For the amazing framework
- **Firebase Team** - For performance monitoring tools
- **Islamic Content Contributors** - For du'a collections and translations
- **Open Source Community** - For the incredible packages and tools

## 💬 Support & Community

- 📧 **Email**: support@duacopilot.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/duacopilot/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/duacopilot/discussions)
- 📚 **Wiki**: [Project Wiki](https://github.com/yourusername/duacopilot/wiki)

---

**Made with ❤️ for the Muslim Community**
