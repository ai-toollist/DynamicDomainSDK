import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Two-line title for AppBar with title and subtitle
/// Used in many pages for custom app bar title styling
class TwoLineAppBarTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final CrossAxisAlignment alignment;

  const TwoLineAppBarTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontWeight: FontWeight.w500,
            fontSize: 23.sp,
            color: titleColor ?? const Color(0xFF1F2937),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: subtitleColor ?? const Color(0xFFBDBDBD),
          ),
        ),
      ],
    );
  }
}

/// App bar title with icon and text
class IconAppBarTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? titleColor;

  const IconAppBarTitle({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24.w,
          color: iconColor ?? const Color(0xFF374151),
        ),
        12.horizontalSpace,
        Text(
          title,
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: titleColor ?? const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}

/// Customized AppBar following app design system
class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final VoidCallback? onBack;
  final bool showBackButton;

  const StyledAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation = 0,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ??
          (titleText != null
              ? Text(
                  titleText!,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: const Color(0xFF374151),
                  ),
                )
              : null),
      leading: leading ??
          (showBackButton
              ? IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.w,
                    color: const Color(0xFF374151),
                  ),
                )
              : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/// App bar action button with optional badge
class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int badgeCount;
  final Color? iconColor;

  const AppBarActionButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badgeCount = 0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Stack(
          children: [
            Icon(
              icon,
              size: 24.w,
              color: iconColor ?? const Color(0xFF374151),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14.w,
                    minHeight: 14.w,
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
