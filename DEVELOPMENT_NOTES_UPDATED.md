# Development Notes

## ✅ RESOLVED: Development Mode Issues

### Issue (FIXED)

1. `flutter_secure_storage` package was causing ATL header compilation errors on Windows
2. Missing `atlstr.h` required for Windows build
3. **App was launching Ad Demo instead of main search interface**
4. **AdService crashing on Windows due to unsupported platform**

### Solution Applied

1. **pubspec.yaml**: Temporarily commented out `flutter_secure_storage: ^9.0.0`
2. **secure_storage_service.dart**: Created mock implementation using in-memory storage
3. **rag_api_service.dart**: Updated to use mock SecureStorageService
4. **main.dart**:
   - ✅ **Changed home from `AdDemoScreen()` to `ConversationalSearchScreen()`**
   - ✅ **Added dependency injection initialization**
   - ✅ **Added ProviderScope for Riverpod state management**
5. **ad_service.dart**:
   - ✅ **Added platform detection for ad initialization**
   - ✅ **Graceful fallback for unsupported platforms (Windows, Web)**
   - ✅ **Updated `shouldShowAds` to only show ads on Android/iOS**

### Current Development Status

- ✅ **Windows Desktop**: Main search app running with hot reload ✓
- ✅ **Web Browser**: Main search app running on http://localhost:3000 ✓
- ✅ **Secure Storage**: Working with mock implementation ✓
- ✅ **RagApiService**: Working with mock secure storage ✓
- ✅ **AdService**: Platform-aware, no crashes ✓
- ✅ **Main App Interface**: ConversationalSearchScreen loading ✓
- ✅ **All Dependencies**: Resolved ✓

### Development Commands

```bash
# Windows Desktop
flutter run -d windows

# Web Browser
flutter run -d chrome --web-port 3000

# Clean build
flutter clean && flutter pub get
```

### For Production

- **Security Warning**: Current storage is in-memory only (not persistent or secure)
- **To restore secure storage**: Re-enable `flutter_secure_storage` in pubspec.yaml and revert service implementations
- **Alternative**: Consider `shared_preferences` for persistent but non-secure storage

## Development Features Available

- ✅ Hot Reload (`r` key)
- ✅ Hot Restart (`R` key)
- ✅ Debug Console
- ✅ Breakpoint Debugging
- ✅ Widget Inspector
- ✅ Network Monitoring
- ✅ Error Tracking
