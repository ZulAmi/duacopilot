import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/professional_theme.dart';

/// Professional UI Components for Islamic App
class ProfessionalComponents {
  /// Professional App Bar with Islamic branding
  static PreferredSizeWidget appBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    VoidCallback? onMenuPressed,
    bool showBack = false,
  }) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!showBack) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ProfessionalTheme.primaryEmerald.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ProfessionalTheme.radiusSm),
              ),
              child: const Icon(
                Icons.mosque_rounded,
                color: ProfessionalTheme.primaryEmerald,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ProfessionalTheme.textPrimary,
            ),
          ),
        ],
      ),
      centerTitle: centerTitle,
      leading: leading ??
          (onMenuPressed != null
              ? IconButton(
                  onPressed: onMenuPressed,
                  icon: const Icon(Icons.menu_rounded),
                  color: ProfessionalTheme.textPrimary,
                )
              : null),
      actions: actions,
      backgroundColor: ProfessionalTheme.surfaceColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: ProfessionalTheme.borderLight),
      ),
    );
  }

  /// Professional Search Bar
  static Widget searchBar({
    required TextEditingController controller,
    required Function(String) onSubmitted,
    String hintText = 'Search Islamic guidance...',
    bool isLoading = false,
    VoidCallback? onVoiceSearch,
    bool enableVoice = true,
    bool isVoiceListening = false,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ProfessionalTheme.surfaceColor,
        borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
        border: Border.all(color: ProfessionalTheme.borderLight),
        boxShadow: ProfessionalTheme.subtleShadow,
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ProfessionalTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: isLoading ? 'Searching...' : hintText,
          hintStyle: const TextStyle(
            color: ProfessionalTheme.textTertiary,
            fontSize: 16,
          ),
          prefixIcon: isLoading
              ? Container(
                  padding: const EdgeInsets.all(12),
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ProfessionalTheme.primaryEmerald,
                      ),
                    ),
                  ),
                )
              : const Icon(
                  Icons.search_rounded,
                  color: ProfessionalTheme.textSecondary,
                  size: 24,
                ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (enableVoice && onVoiceSearch != null)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isVoiceListening
                        ? ProfessionalTheme.primaryEmerald
                        : ProfessionalTheme.gray100,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isVoiceListening ? Icons.mic : Icons.mic_none_rounded,
                      color: isVoiceListening
                          ? ProfessionalTheme.surfaceColor
                          : ProfessionalTheme.textSecondary,
                    ),
                    onPressed: onVoiceSearch,
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ProfessionalTheme.primaryEmerald,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: ProfessionalTheme.surfaceColor,
                  ),
                  onPressed: () {
                    final query = controller.text.trim();
                    if (query.isNotEmpty) {
                      onSubmitted(query);
                    }
                  },
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(ProfessionalTheme.spaceMd),
        ),
      ),
    );
  }

  /// Professional Card
  static Widget card({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    bool showShadow = true,
    Color? backgroundColor,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? ProfessionalTheme.surfaceColor,
        borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
        border: Border.all(color: ProfessionalTheme.borderLight),
        boxShadow: showShadow ? ProfessionalTheme.cardShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusLg),
          onTap: onTap != null
              ? () {
                  HapticFeedback.lightImpact();
                  onTap();
                }
              : null,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(ProfessionalTheme.spaceMd),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Professional Button
  static Widget button({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isOutlined = false,
    IconData? icon,
    double? width,
    bool enabled = true,
  }) {
    return SizedBox(
      width: width,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: enabled && !isLoading ? onPressed : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ProfessionalTheme.primaryEmerald,
                        ),
                      ),
                    )
                  : Icon(icon ?? Icons.arrow_forward_rounded),
              label: Text(text),
              style: OutlinedButton.styleFrom(
                foregroundColor: enabled
                    ? ProfessionalTheme.primaryEmerald
                    : ProfessionalTheme.textTertiary,
                side: BorderSide(
                  color: enabled
                      ? ProfessionalTheme.primaryEmerald
                      : ProfessionalTheme.borderLight,
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: enabled && !isLoading ? onPressed : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ProfessionalTheme.surfaceColor,
                        ),
                      ),
                    )
                  : Icon(icon ?? Icons.arrow_forward_rounded),
              label: Text(text),
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled
                    ? ProfessionalTheme.primaryEmerald
                    : ProfessionalTheme.gray300,
              ),
            ),
    );
  }

  /// Professional Feature Card
  static Widget featureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    Color? iconColor,
    String? badge,
  }) {
    return card(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? ProfessionalTheme.primaryEmerald)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ProfessionalTheme.radiusMd,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? ProfessionalTheme.primaryEmerald,
                  size: 24,
                ),
              ),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ProfessionalTheme.secondaryGold,
                    borderRadius: BorderRadius.circular(
                      ProfessionalTheme.radiusSm,
                    ),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: ProfessionalTheme.surfaceColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: ProfessionalTheme.spaceMd),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ProfessionalTheme.textPrimary,
            ),
          ),
          const SizedBox(height: ProfessionalTheme.spaceXs),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: ProfessionalTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Professional Stats Card
  static Widget statsCard({
    required String value,
    required String label,
    IconData? icon,
    Color? accentColor,
  }) {
    return card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: accentColor ?? ProfessionalTheme.primaryEmerald,
              size: 28,
            ),
            const SizedBox(height: ProfessionalTheme.spaceXs),
          ],
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: accentColor ?? ProfessionalTheme.primaryEmerald,
            ),
          ),
          const SizedBox(height: ProfessionalTheme.spaceXs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: ProfessionalTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Professional Loading Indicator
  static Widget loadingIndicator({String? message, double size = 24}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ProfessionalTheme.primaryEmerald,
            ),
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: ProfessionalTheme.spaceMd),
          Text(
            message,
            style: const TextStyle(
              color: ProfessionalTheme.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Professional Empty State
  static Widget emptyState({
    required IconData icon,
    required String title,
    required String description,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ProfessionalTheme.space2Xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(ProfessionalTheme.spaceLg),
              decoration: BoxDecoration(
                color: ProfessionalTheme.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: ProfessionalTheme.textTertiary,
              ),
            ),
            const SizedBox(height: ProfessionalTheme.spaceLg),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ProfessionalTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ProfessionalTheme.spaceXs),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: ProfessionalTheme.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: ProfessionalTheme.spaceLg),
              action,
            ],
          ],
        ),
      ),
    );
  }

  /// Professional Bottom Sheet
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: ProfessionalTheme.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ProfessionalTheme.radiusXl),
            topRight: Radius.circular(ProfessionalTheme.radiusXl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Container(
                padding: const EdgeInsets.all(ProfessionalTheme.spaceMd),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ProfessionalTheme.borderLight,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ProfessionalTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: ProfessionalTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: ProfessionalTheme.borderMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  /// Professional Snackbar
  static void showSnackBar({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: ProfessionalTheme.surfaceColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: ProfessionalTheme.surfaceColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? ProfessionalTheme.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProfessionalTheme.radiusMd),
        ),
        action: action,
      ),
    );
  }

  /// Professional Section Header
  static Widget buildSectionHeader(
    String title,
    String? subtitle, {
    Widget? trailing,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ProfessionalTheme.textPrimary,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: ProfessionalTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
