// lib/presentation/components/ultra_modern_navigation.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/ultra_modern_theme.dart';

/// Ultra-modern navigation component with glassmorphic design
class UltraModernNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<UltraModernNavItem> items;
  final bool showLabels;
  final double? elevation;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const UltraModernNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showLabels = true,
    this.elevation,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  State<UltraModernNavigationBar> createState() => _UltraModernNavigationBarState();
}

class _UltraModernNavigationBarState extends State<UltraModernNavigationBar> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _animations = _animationControllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          ),
        )
        .toList();

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Animate initial selected item
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void didUpdateWidget(UltraModernNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateSelection(oldWidget.currentIndex, widget.currentIndex);
    }
  }

  void _updateSelection(int oldIndex, int newIndex) {
    if (oldIndex < _animationControllers.length) {
      _animationControllers[oldIndex].reverse();
    }
    if (newIndex < _animationControllers.length) {
      _animationControllers[newIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 85,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: widget.backgroundColor ??
            (isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.3)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildNavItem(context, item, index);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    UltraModernNavItem item,
    int index,
  ) {
    final isSelected = index == widget.currentIndex;
    final theme = Theme.of(context);

    return Expanded(
      child: AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap(index);
              _rippleController.forward().then(
                    (_) => _rippleController.reset(),
                  );
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected
                    ? widget.selectedItemColor?.withValues(alpha: 0.15) ??
                        UltraModernTheme.primaryGradient.colors.first.withValues(alpha: 0.15)
                    : Colors.transparent,
                border: isSelected
                    ? Border.all(
                        color: widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first,
                        width: 1,
                      )
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple effect
                  if (isSelected)
                    AnimatedBuilder(
                      animation: _rippleController,
                      builder: (context, child) {
                        return Container(
                          width: 60 * _rippleController.value,
                          height: 60 * _rippleController.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first).withValues(
                              alpha: 0.1 * (1 - _rippleController.value),
                            ),
                          ),
                        );
                      },
                    ),

                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..scale(isSelected ? 1.2 : 1.0)
                          ..translate(0.0, isSelected ? -2.0 : 0.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: isSelected
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first,
                                      widget.selectedItemColor?.withValues(
                                            alpha: 0.7,
                                          ) ??
                                          UltraModernTheme.primaryGradient.colors.last,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                )
                              : null,
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: isSelected
                                ? Colors.white
                                : widget.unselectedItemColor ?? theme.iconTheme.color?.withValues(alpha: 0.6),
                          ),
                        ),
                      ),

                      // Label with fade animation
                      if (widget.showLabels) ...[
                        const SizedBox(height: 4),
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.6,
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: isSelected ? 12 : 11,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first
                                  : widget.unselectedItemColor ??
                                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                              letterSpacing: 0.2,
                            ),
                            child: Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Selection indicator dot
                  if (isSelected)
                    Positioned(
                      top: 8,
                      child: AnimatedBuilder(
                        animation: _animations[index],
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animations[index].value,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first,
                                boxShadow: [
                                  BoxShadow(
                                    color: (widget.selectedItemColor ?? UltraModernTheme.primaryGradient.colors.first)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Navigation item model
class UltraModernNavItem {
  final IconData icon;
  final String label;
  final Widget? activeIcon;
  final Color? backgroundColor;

  const UltraModernNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.backgroundColor,
  });
}

/// Modern app bar with glassmorphic design
class UltraModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double toolbarHeight;

  const UltraModernAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.showBackButton = false,
    this.onBackPressed,
    this.toolbarHeight = 70,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: toolbarHeight + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.2)),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Leading
                    if (leading != null)
                      leading!
                    else if (showBackButton || (automaticallyImplyLeading && ModalRoute.of(context)?.canPop == true))
                      _buildBackButton(context),

                    // Title
                    Expanded(
                      child: Container(
                        alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: (leading == null && !showBackButton) ? 0 : 16,
                          right: actions?.isEmpty ?? true ? 0 : 16,
                        ),
                        child: titleWidget ??
                            (title != null
                                ? Text(
                                    title!,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: foregroundColor ?? theme.textTheme.headlineSmall?.color,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const SizedBox.shrink()),
                      ),
                    ),

                    // Actions
                    if (actions?.isNotEmpty ?? false)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!
                            .map(
                              (action) => Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: action,
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
          color: foregroundColor ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}

/// Ultra-modern side navigation drawer
class UltraModernDrawer extends StatefulWidget {
  final List<UltraModernDrawerItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Widget? header;
  final Widget? footer;
  final Color? backgroundColor;
  final double width;

  const UltraModernDrawer({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.header,
    this.footer,
    this.backgroundColor,
    this.width = 280,
  });

  @override
  State<UltraModernDrawer> createState() => _UltraModernDrawerState();
}

class _UltraModernDrawerState extends State<UltraModernDrawer> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: widget.width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor ??
              (isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.3)),
          border: Border(
            right: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header
                  if (widget.header != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: widget.header!,
                    ),

                  // Menu items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        return _buildDrawerItem(widget.items[index], index);
                      },
                    ),
                  ),

                  // Footer
                  if (widget.footer != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: widget.footer!,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(UltraModernDrawerItem item, int index) {
    final isSelected = index == widget.selectedIndex;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onItemSelected(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected
                  ? UltraModernTheme.primaryGradient.colors.first.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: UltraModernTheme.primaryGradient.colors.first.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? UltraModernTheme.primaryGradient.colors.first
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: isSelected ? Colors.white : theme.iconTheme.color?.withValues(alpha: 0.7),
                  ),
                ),

                const SizedBox(width: 16),

                // Title
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? UltraModernTheme.primaryGradient.colors.first
                          : theme.textTheme.bodyLarge?.color?.withValues(
                              alpha: 0.8,
                            ),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),

                // Trailing
                if (item.trailing != null)
                  item.trailing!
                else if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: UltraModernTheme.primaryGradient.colors.first,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Drawer item model
class UltraModernDrawerItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const UltraModernDrawerItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
}
