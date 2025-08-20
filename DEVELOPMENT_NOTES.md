# Development Notes

## Temporary Changes for Windows Development

### Issue

- `flutter_secure_storage` package was causing ATL header compilation errors on Windows
- Missing `atlstr.h` required for Windows build

### Temporary Fixes Applied

1. **pubspec.yaml**: Commented out `flutter_secure_storage: ^9.0.0`
2. **injection_container.dart**:
   - Commented out FlutterSecureStorage import
   - Disabled SecureStorageService registration
   - Disabled RagApiService registration (depends on secure storage)

### Current Development Status

- ✅ **Windows Desktop**: Working with hot reload
- ✅ **Web Browser**: Working on http://localhost:3000
- ⚠️ **Secure Storage**: Temporarily disabled
- ⚠️ **RagApiService**: Temporarily disabled

### To Re-enable Later

1. Uncomment secure storage in pubspec.yaml
2. Uncomment imports and registrations in injection_container.dart
3. Consider alternative storage solutions for Windows if needed

### Development Commands

```bash
# Windows Desktop
flutter run -d windows

# Web Browser
flutter run -d chrome --web-port 3000

# Clean build
flutter clean && flutter pub get
```
