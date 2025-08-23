# DuaCopilot - Development Guide

## ✅ **RESOLVED: Platform Conflicts Fixed**

The development environment is now working on both Windows and Web platforms with proper platform-aware initialization.

## 🚀 **Quick Start for Development**

### Prerequisites

- Flutter SDK 3.29.1+
- Visual Studio Build Tools 2022 (for Windows)
- Chrome browser (for web development)

### Running the Development App

#### **Windows Development (Recommended)**

```bash
flutter run --target lib/main_dev.dart -d windows
```

#### **Web Development**

```bash
flutter run --target lib/main_dev.dart -d chrome --web-port 8080
```

### VS Code Tasks (Available in Command Palette)

- `Run DuaCopilot - Windows Dev` - Launch Windows development mode
- `Run DuaCopilot - Web Dev` - Launch web development mode

## 🔧 **What Was Fixed**

### ✅ Compile Issues Resolved

- **Database Platform Conflicts**: Added `sqflite_common_ffi` for Windows desktop support
- **Dependency Injection**: Made platform-aware with graceful fallbacks
- **Secure Storage**: Using mock implementation for development
- **Ad Service**: Platform detection (Android/iOS only)

### ✅ Platform-Aware Architecture

- **Windows**: Full functionality with SQLite database
- **Web**: Limited functionality without database (API calls only)
- **Cross-platform**: Proper conditional imports and initialization

### ✅ Development Entry Points

- **`main_dev.dart`**: Development-specific entry point with error handling
- **Platform Detection**: Automatic feature enabling/disabling based on platform
- **Graceful Degradation**: App continues to work even if some services fail

## 📱 **App Features Status**

### **Windows Development** ✅

- ✅ Conversational search interface
- ✅ SQLite database with query history
- ✅ Network connectivity checking
- ✅ Mock secure storage
- ✅ RAG API integration
- ✅ Material 3 Islamic theming
- ✅ Hot reload support

### **Web Development** ✅

- ✅ Basic search interface
- ✅ Network API calls
- ✅ Islamic theming
- ⚠️ Limited local storage (no SQLite)
- ⚠️ No query history persistence
- ✅ Hot reload support

## 🏗️ **Architecture Overview**

### **Clean Architecture Layers**

```
presentation/     - UI screens and widgets
├── screens/      - ConversationalSearchScreen
└── providers/    - Riverpod state management

domain/           - Business logic
├── entities/     - RagResponse, QueryHistory
├── repositories/ - Abstract interfaces
└── usecases/     - SearchRag, GetQueryHistory

data/             - External interfaces
├── datasources/  - Remote (RAG API), Local (SQLite)
├── repositories/ - Concrete implementations
└── models/       - Data transfer objects

core/             - Infrastructure
├── di/           - Dependency injection (GetIt)
├── storage/      - Database and secure storage
└── network/      - HTTP client and connectivity
```

### **Key Services**

- **RagApiService**: Islamic content search via API
- **DatabaseHelper**: Platform-aware SQLite management
- **SecureStorageService**: Mock implementation for development
- **AdService**: Platform-specific monetization
- **NetworkInfo**: Connectivity checking

## 🔍 **Development Features**

### **Logging and Debugging**

The app provides detailed initialization logs:

- 🔧 Service initialization steps
- ✅ Successful service startups
- ⚠️ Warnings for platform limitations
- ❌ Error details for troubleshooting

### **Hot Reload Support**

Both Windows and Web versions support hot reload for rapid development.

### **Error Handling**

- Graceful fallbacks for missing services
- Platform-specific feature detection
- Detailed error messages for debugging

## 🎯 **Development Workflow**

1. **Start Development Environment**

   ```bash
   flutter run --target lib/main_dev.dart -d windows
   ```

2. **Make Changes**

   - Edit source code in `lib/`
   - UI changes in `presentation/`
   - Business logic in `domain/`
   - Data layer in `data/`

3. **Hot Reload**

   - Press `r` in terminal for hot reload
   - Press `R` for full hot restart

4. **Test on Multiple Platforms**
   - Windows: Full functionality testing
   - Web: API and UI testing

## 📦 **Dependencies Status**

### **Working Dependencies**

- ✅ `flutter_riverpod` - State management
- ✅ `dio` - HTTP client
- ✅ `sqflite` + `sqflite_common_ffi` - Database
- ✅ `connectivity_plus` - Network checking
- ✅ `get_it` - Dependency injection
- ✅ `logger` - Logging
- ✅ `google_mobile_ads` - Monetization (mobile only)

### **Development Workarounds**

- ⚠️ `flutter_secure_storage` - Using mock implementation
- ⚠️ `workmanager` - Disabled for compatibility

## 🚀 **Production Considerations**

For production builds, you'll need to:

1. Replace mock `SecureStorageService` with real implementation
2. Add proper Firebase configuration
3. Configure platform-specific app signing
4. Enable `workmanager` for background tasks (mobile only)

## 🔗 **Useful Links**

- Flutter Development: https://flutter.dev/docs
- Riverpod State Management: https://riverpod.dev
- Clean Architecture: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

---

**Status**: ✅ **Development Environment Fully Operational**  
**Last Updated**: August 2025  
**Platforms Tested**: Windows ✅, Web ✅
