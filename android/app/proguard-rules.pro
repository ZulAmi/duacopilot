# Add any ProGuard configurations specific to your app here.
# By default, the flags in this file are appended to flags specified in
# /android/app/proguard-android.txt
# For more details, see http://developer.android.com/guide/developing/tools/proguard.html

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

# Keep Firebase classes (if using Firebase)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Dio HTTP client classes
-keep class dio.** { *; }

# Keep Islamic content classes
-keep class ** extends java.lang.Enum { *; }

# Preserve line numbers for debugging stack traces
-keepattributes SourceFile,LineNumberTable

# If your app crashes, you may want to uncomment this to preserve more info
# -printmapping mapping.txt
# -printusage usage.txt
# -printseeds seeds.txt
