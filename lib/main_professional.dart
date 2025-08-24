import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/professional_theme.dart';
import 'presentation/screens/professional_home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ProfessionalDuaCopilotApp(),
    ),
  );
}

class ProfessionalDuaCopilotApp extends StatelessWidget {
  const ProfessionalDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot - Islamic AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const ProfessionalHomeScreen(),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: ProfessionalTheme.surfaceColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: ProfessionalTheme.primaryEmerald,
        brightness: Brightness.light,
        primary: ProfessionalTheme.primaryEmerald,
        secondary: ProfessionalTheme.secondaryGold,
        surface: ProfessionalTheme.surfaceColor,
        background: ProfessionalTheme.backgroundColor,
        onPrimary: ProfessionalTheme.surfaceColor,
        onSecondary: ProfessionalTheme.surfaceColor,
        onSurface: ProfessionalTheme.textPrimary,
        onBackground: ProfessionalTheme.textPrimary,
      ),
      
      // Scaffold theme
      scaffoldBackgroundColor: ProfessionalTheme.backgroundColor,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: ProfessionalTheme.surfaceColor,
        foregroundColor: ProfessionalTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: ProfessionalTheme.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: ProfessionalTheme.textPrimary,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: ProfessionalTheme.surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          side: const BorderSide(
            color: ProfessionalTheme.borderLight,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ProfessionalTheme.primaryEmerald,
          foregroundColor: ProfessionalTheme.surfaceColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfessionalTheme.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ProfessionalTheme.spaceMd,
            vertical: 12,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ProfessionalTheme.primaryEmerald,
          side: const BorderSide(
            color: ProfessionalTheme.primaryEmerald,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfessionalTheme.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ProfessionalTheme.spaceMd,
            vertical: 12,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ProfessionalTheme.primaryEmerald,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProfessionalTheme.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ProfessionalTheme.spaceMd,
            vertical: 8,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ProfessionalTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: ProfessionalTheme.borderLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: ProfessionalTheme.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: ProfessionalTheme.primaryEmerald,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(ProfessionalTheme.spaceMd),
        hintStyle: const TextStyle(
          color: ProfessionalTheme.textTertiary,
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          color: ProfessionalTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ProfessionalTheme.primaryEmerald,
        foregroundColor: ProfessionalTheme.surfaceColor,
        elevation: 4,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ProfessionalTheme.surfaceColor,
        selectedItemColor: ProfessionalTheme.primaryEmerald,
        unselectedItemColor: ProfessionalTheme.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Tab bar theme
      tabBarTheme: const TabBarTheme(
        labelColor: ProfessionalTheme.primaryEmerald,
        unselectedLabelColor: ProfessionalTheme.textTertiary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: ProfessionalTheme.primaryEmerald,
            width: 2,
          ),
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: ProfessionalTheme.borderLight,
        thickness: 1,
        space: 1,
      ),
      
      // List tile theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ProfessionalTheme.spaceMd,
          vertical: 4,
        ),
        titleTextStyle: TextStyle(
          color: ProfessionalTheme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: ProfessionalTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: ProfessionalTheme.gray100,
        labelStyle: const TextStyle(
          color: ProfessionalTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(
          color: ProfessionalTheme.borderLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusSm),
        ),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ProfessionalTheme.textPrimary,
        contentTextStyle: const TextStyle(
          color: ProfessionalTheme.surfaceColor,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: ProfessionalTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
        ),
        titleTextStyle: const TextStyle(
          color: ProfessionalTheme.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: ProfessionalTheme.textSecondary,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ProfessionalTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ProfessionalTheme.radiusXl),
            topRight: Radius.circular(ProfessionalTheme.radiusXl),
          ),
        ),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ProfessionalTheme.primaryEmerald,
      ),
    );
  }
}
