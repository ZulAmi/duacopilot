import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/revolutionary_islamic_theme.dart';

/// Revolutionary UI Components - Next-Generation Islamic Design System
class RevolutionaryComponents {
  // Modern App Bar with Hamburger Menu & Back Button
  static PreferredSizeWidget modernAppBar({
    required String title,
    bool showBackButton = false,
    bool showHamburger = true,
    VoidCallback? onBackPressed,
    VoidCallback? onMenuPressed,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return AppBar(
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: onBackPressed ?? () {},
                style: IconButton.styleFrom(
                  backgroundColor: RevolutionaryIslamicTheme.neutralGray100,
                  foregroundColor: RevolutionaryIslamicTheme.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusXl,
                    ),
                  ),
                ),
              )
              : showHamburger
              ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: onMenuPressed ?? () {},
                style: IconButton.styleFrom(
                  backgroundColor: RevolutionaryIslamicTheme.neutralGray100,
                  foregroundColor: RevolutionaryIslamicTheme.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusXl,
                    ),
                  ),
                ),
              )
              : null),
      title: Row(
        children: [
          if (showBackButton || showHamburger)
            const SizedBox(width: RevolutionaryIslamicTheme.space2),
          Container(
            padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space2),
            decoration: BoxDecoration(
              gradient: RevolutionaryIslamicTheme.heroGradient,
              borderRadius: BorderRadius.circular(
                RevolutionaryIslamicTheme.radiusLg,
              ),
            ),
            child: const Icon(
              Icons.mosque_rounded,
              color: RevolutionaryIslamicTheme.textOnColor,
              size: 20,
            ),
          ),
          const SizedBox(width: RevolutionaryIslamicTheme.space3),
          Text(
            title,
            style: RevolutionaryIslamicTheme.headline3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: RevolutionaryIslamicTheme.neutralGray100,
                foregroundColor: RevolutionaryIslamicTheme.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    RevolutionaryIslamicTheme.radiusXl,
                  ),
                ),
              ),
            ),
            const SizedBox(width: RevolutionaryIslamicTheme.space2),
          ],
      backgroundColor: RevolutionaryIslamicTheme.backgroundSecondary,
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  // Modern Drawer/Menu
  static Widget modernDrawer({
    required VoidCallback onHomePressed,
    required List<DrawerMenuItem> menuItems,
    String? userName,
    String? userEmail,
    VoidCallback? onSettingsPressed,
    VoidCallback? onHelpPressed,
  }) {
    return Drawer(
      backgroundColor: RevolutionaryIslamicTheme.backgroundSecondary,
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                20,
              ), // Reduced from space6 (32px) to 20px
              decoration: BoxDecoration(
                gradient: RevolutionaryIslamicTheme.heroGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(
                    20,
                  ), // Reduced radius for cleaner look
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48, // Fixed compact size
                    height: 48, // Fixed compact size
                    padding: const EdgeInsets.all(
                      12,
                    ), // Reduced from space4 (16px) to 12px
                    decoration: BoxDecoration(
                      color: RevolutionaryIslamicTheme.textOnColor.withOpacity(
                        0.2,
                      ),
                      borderRadius: BorderRadius.circular(
                        RevolutionaryIslamicTheme.radiusFull,
                      ),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: RevolutionaryIslamicTheme.textOnColor,
                      size: 24, // Reduced from 32 to 24
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ), // Reduced from space4 (16px) to 12px
                  Text(
                    'DuaCopilot',
                    style: RevolutionaryIslamicTheme.headline3.copyWith(
                      // Changed from headline2 to headline3 for smaller text
                      color: RevolutionaryIslamicTheme.textOnColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4), // Reduced from space1 (4px) to 4px
                  Text(
                    'Your AI Islamic Companion',
                    style: RevolutionaryIslamicTheme.body2.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor.withOpacity(
                        0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ), // More compact padding
                children: [
                  _modernDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: onHomePressed,
                    isSelected: true,
                  ),
                  ...menuItems.map(
                    (item) => _modernDrawerItem(
                      icon: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      onTap: item.onTap,
                      badge: item.badge,
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ), // More compact padding
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 4), // Reduced spacing
                  _modernDrawerItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: onSettingsPressed ?? () {},
                  ),
                  _modernDrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: onHelpPressed ?? () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _modernDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isSelected = false,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1), // Minimal margin
      child: Material(
        color:
            isSelected
                ? RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.05)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ), // Very compact padding
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 28, // Even smaller icon container
                  height: 28,
                  padding: const EdgeInsets.all(4), // Minimal icon padding
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? RevolutionaryIslamicTheme.primaryEmerald
                                .withOpacity(0.1)
                            : RevolutionaryIslamicTheme.neutralGray100,
                    borderRadius: BorderRadius.circular(6), // Smaller radius
                  ),
                  child: Icon(
                    icon,
                    color:
                        isSelected
                            ? RevolutionaryIslamicTheme.primaryEmerald
                            : RevolutionaryIslamicTheme.textSecondary,
                    size: 16, // Smaller icon
                  ),
                ),
                const SizedBox(width: 12), // Compact spacing
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Minimize vertical space
                    children: [
                      Text(
                        title,
                        style: RevolutionaryIslamicTheme.body2.copyWith(
                          color:
                              isSelected
                                  ? RevolutionaryIslamicTheme.primaryEmerald
                                  : RevolutionaryIslamicTheme.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14, // Smaller title text
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 1,
                          ), // Minimal spacing
                          child: Text(
                            subtitle,
                            style: RevolutionaryIslamicTheme.caption.copyWith(
                              color: RevolutionaryIslamicTheme.textTertiary,
                              fontSize: 10, // Very small subtitle
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Badge or chevron
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: RevolutionaryIslamicTheme.accentPurple,
                      borderRadius: BorderRadius.circular(
                        RevolutionaryIslamicTheme.radiusFull,
                      ),
                    ),
                    child: Text(
                      badge,
                      style: RevolutionaryIslamicTheme.caption.copyWith(
                        color: RevolutionaryIslamicTheme.textOnColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 9, // Very small badge text
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: RevolutionaryIslamicTheme.textTertiary,
                    size: 14, // Smaller chevron
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern Search Bar
  static Widget modernSearchBar({
    required TextEditingController controller,
    required ValueChanged<String> onSubmitted,
    ValueChanged<String>? onChanged,
    bool isLoading = false,
    VoidCallback? onVoiceSearch,
    bool isVoiceListening = false,
    String hintText = 'Search Islamic knowledge...',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(
          RevolutionaryIslamicTheme.radius3Xl,
        ),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: RevolutionaryIslamicTheme.shadowSm,
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        style: RevolutionaryIslamicTheme.body1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: RevolutionaryIslamicTheme.body2.copyWith(
            color: RevolutionaryIslamicTheme.textTertiary,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(RevolutionaryIslamicTheme.space3),
            padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space2),
            decoration: BoxDecoration(
              gradient: RevolutionaryIslamicTheme.heroGradient,
              borderRadius: BorderRadius.circular(
                RevolutionaryIslamicTheme.radiusFull,
              ),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: RevolutionaryIslamicTheme.textOnColor,
              size: 20,
            ),
          ),
          suffixIcon:
              isLoading
                  ? Container(
                    margin: const EdgeInsets.all(
                      RevolutionaryIslamicTheme.space4,
                    ),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        RevolutionaryIslamicTheme.primaryEmerald,
                      ),
                    ),
                  )
                  : onVoiceSearch != null
                  ? IconButton(
                    icon: Icon(
                      isVoiceListening
                          ? Icons.mic_rounded
                          : Icons.mic_none_rounded,
                      color:
                          isVoiceListening
                              ? RevolutionaryIslamicTheme.errorRose
                              : RevolutionaryIslamicTheme.textSecondary,
                    ),
                    onPressed: onVoiceSearch,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          isVoiceListening
                              ? RevolutionaryIslamicTheme.errorRose.withOpacity(
                                0.1,
                              )
                              : RevolutionaryIslamicTheme.neutralGray100,
                      foregroundColor:
                          isVoiceListening
                              ? RevolutionaryIslamicTheme.errorRose
                              : RevolutionaryIslamicTheme.textSecondary,
                    ),
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: RevolutionaryIslamicTheme.space4,
            vertical: RevolutionaryIslamicTheme.space4,
          ),
        ),
      ),
    );
  }

  // Modern Feature Card
  static Widget modernFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    String? badge,
    List<Color>? gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: RevolutionaryIslamicTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(
            16,
          ), // Reduced from radius3Xl to 16px
          border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
          boxShadow: RevolutionaryIslamicTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon and Badge - Much more compact
            Container(
              padding: const EdgeInsets.all(
                12,
              ), // Reduced from space4 (16px) to 12px
              child: Row(
                children: [
                  Container(
                    width: 40, // Fixed compact size
                    height: 40, // Fixed compact size
                    padding: const EdgeInsets.all(
                      8,
                    ), // Reduced from space3 (12px) to 8px
                    decoration: BoxDecoration(
                      gradient:
                          gradientColors != null
                              ? LinearGradient(colors: gradientColors)
                              : RevolutionaryIslamicTheme.heroGradient,
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Reduced from radius2Xl to 12px
                      boxShadow: RevolutionaryIslamicTheme.shadowXs,
                    ),
                    child: Icon(
                      icon,
                      color: RevolutionaryIslamicTheme.textOnColor,
                      size: 20,
                    ), // Reduced from 24 to 20
                  ),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ), // Reduced padding
                      decoration: BoxDecoration(
                        color: RevolutionaryIslamicTheme.accentPurple,
                        borderRadius: BorderRadius.circular(
                          RevolutionaryIslamicTheme.radiusFull,
                        ),
                      ),
                      child: Text(
                        badge,
                        style: RevolutionaryIslamicTheme.caption.copyWith(
                          color: RevolutionaryIslamicTheme.textOnColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10, // Smaller badge text
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content - More compact spacing
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  12,
                ), // Reduced all padding from 16px to 12px
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: RevolutionaryIslamicTheme.subtitle2.copyWith(
                        // Changed from subtitle1 to subtitle2 for smaller text
                        fontWeight: FontWeight.w700,
                        color: RevolutionaryIslamicTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ), // Reduced from space2 (8px) to 6px
                    Expanded(
                      child: Text(
                        description,
                        style: RevolutionaryIslamicTheme.body2.copyWith(
                          color: RevolutionaryIslamicTheme.textSecondary,
                          height: 1.3, // Reduced line height from 1.4 to 1.3
                          fontSize: 12, // Smaller description text
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ), // Reduced from space3 (12px) to 8px
                    Row(
                      children: [
                        Text(
                          'Explore',
                          style: RevolutionaryIslamicTheme.body2.copyWith(
                            color: RevolutionaryIslamicTheme.primaryEmerald,
                            fontWeight: FontWeight.w600,
                            fontSize: 12, // Smaller explore text
                          ),
                        ),
                        const SizedBox(width: 4), // Reduced spacing
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: RevolutionaryIslamicTheme.primaryEmerald,
                          size: 12, // Reduced from 14 to 12
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Stats Card
  static Widget modernStatsCard({
    required String value,
    required String label,
    required IconData icon,
    Color? accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(
          RevolutionaryIslamicTheme.radius2Xl,
        ),
        border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
        boxShadow: RevolutionaryIslamicTheme.shadowXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space2),
                decoration: BoxDecoration(
                  color: (accentColor ??
                          RevolutionaryIslamicTheme.primaryEmerald)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    RevolutionaryIslamicTheme.radiusLg,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                      accentColor ?? RevolutionaryIslamicTheme.primaryEmerald,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space3),
          Text(
            value,
            style: RevolutionaryIslamicTheme.headline2.copyWith(
              fontWeight: FontWeight.w800,
              color: RevolutionaryIslamicTheme.textPrimary,
            ),
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space1),
          Text(
            label,
            style: RevolutionaryIslamicTheme.caption.copyWith(
              color: RevolutionaryIslamicTheme.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Modern Snack Bar
  static void showModernSnackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space2),
            decoration: BoxDecoration(
              color: RevolutionaryIslamicTheme.textOnColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                RevolutionaryIslamicTheme.radiusLg,
              ),
            ),
            child: Icon(
              icon,
              color: RevolutionaryIslamicTheme.textOnColor,
              size: 20,
            ),
          ),
          const SizedBox(width: RevolutionaryIslamicTheme.space3),
          Expanded(
            child: Text(
              message,
              style: RevolutionaryIslamicTheme.body2.copyWith(
                color: RevolutionaryIslamicTheme.textOnColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor:
          backgroundColor ?? RevolutionaryIslamicTheme.primaryEmerald,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          RevolutionaryIslamicTheme.radius2Xl,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

// Data class for drawer menu items
class DrawerMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final String? badge;

  DrawerMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.badge,
  });
}
