// Modern, award-winning theme for DuaCopilot
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernIslamicTheme {
  static const Color primaryGreen = Color(0xFF1B5E20); // Deep Islamic green
  static const Color _accentGreen = Color(0xFF2E7D32); // Medium Islamic green
  static const Color _lightGreen = Color(0xFF4CAF50); // Light Islamic green
  static const Color _goldAccent = Color(0xFFD4AF37); // Islamic gold
  static const Color _warmWhite = Color(0xFFFAFAFA); // Warm white
  static const Color _pureWhite = Color(0xFFFFFFFF); // Pure white

  // Gradient colors for modern effects
  static const List<Color> primaryGradient = [Color(0xFF1B5E20), Color(0xFF2E7D32)];

  static const List<Color> accentGradient = [Color(0xFF4CAF50), Color(0xFF66BB6A)];

  static const List<Color> goldGradient = [Color(0xFFD4AF37), Color(0xFFB8860B)];

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: _accentGreen,
      secondary: _lightGreen,
      tertiary: _goldAccent,
      surface: _warmWhite,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      surfaceContainerHighest: Color(0xFFF5F5F5),
      outline: Color(0xFFE0E0E0),
      shadow: Color(0x1A000000),
    ),

    // Typography - Using Google Fonts for modern feel
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        // Headlines
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.8, height: 1.2),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.5, height: 1.3),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.3, height: 1.3),

        // Titles
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.2, height: 1.4),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4),

        // Body text
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.3, height: 1.6),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.5),

        // Labels
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.3),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.3),
      ),
    ).apply(bodyColor: const Color(0xFF2C2C2C), displayColor: const Color(0xFF1A1A1A)),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: _accentGreen,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _accentGreen,
        letterSpacing: -0.2,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _pureWhite,
      surfaceTintColor: Colors.transparent,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: _accentGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.white.withOpacity(0.1);
          }
          return null;
        }),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _accentGreen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _accentGreen,
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: _accentGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _pureWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _accentGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade500),
      labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: _accentGreen),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: _lightGreen.withOpacity(0.1),
      deleteIconColor: _accentGreen,
      disabledColor: Colors.grey.shade300,
      selectedColor: _accentGreen,
      secondarySelectedColor: _lightGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: _accentGreen),
      secondaryLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: _accentGreen.withOpacity(0.3)),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: _accentGreen, size: 24),

    // Primary Icon Theme
    primaryIconTheme: const IconThemeData(color: Colors.white, size: 24),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _accentGreen,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: CircleBorder(),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _pureWhite,
      selectedItemColor: _accentGreen,
      unselectedItemColor: Colors.grey.shade500,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: _accentGreen,
      unselectedLabelColor: Colors.grey.shade500,
      labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: _accentGreen, width: 3),
        insets: EdgeInsets.symmetric(horizontal: 16),
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF2C2C2C)),
      subtitleTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1, space: 1),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _accentGreen;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightGreen.withOpacity(0.3);
        }
        return Colors.grey.shade300;
      }),
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: _accentGreen,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: _accentGreen,
      overlayColor: _accentGreen.withOpacity(0.2),
      valueIndicatorColor: _accentGreen,
      valueIndicatorTextStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _accentGreen,
      linearTrackColor: Color(0xFFE8F5E8),
      circularTrackColor: Color(0xFFE8F5E8),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: _pureWhite,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF2C2C2C)),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF2C2C2C),
        height: 1.5,
      ),
    ),

    // Snack Bar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey.shade800,
      contentTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: _lightGreen,
      secondary: Color(0xFF66BB6A),
      tertiary: _goldAccent,
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onTertiary: Colors.black,
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF2D2D2D),
      outline: Color(0xFF404040),
      shadow: Color(0x40000000),
    ),

    // Apply similar styling as light theme but with dark colors
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white),

    // Continue with dark theme specific styling...
    // (Similar structure as light theme but with dark colors)
  );

  // Custom decoration mixins for modern effects
  static BoxDecoration glassmorphicDecoration({
    required Color backgroundColor,
    double borderRadius = 16,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [backgroundColor.withOpacity(opacity), backgroundColor.withOpacity(opacity * 0.7)],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
    );
  }

  static BoxDecoration modernCardDecoration({
    Color? backgroundColor,
    double borderRadius = 16,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? _pureWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow:
          withShadow
              ? [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 8)),
              ]
              : null,
    );
  }

  static Gradient primaryGradientStyle = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: primaryGradient,
  );

  static Gradient accentGradientStyle = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: accentGradient,
  );

  static Gradient goldGradientStyle = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: goldGradient,
  );
}
