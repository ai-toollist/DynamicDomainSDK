// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A customizable button widget that supports:
/// - Icon only button (circular)
/// - Text only button
/// - Icon with label below (action button style)
/// - Badge count indicator
class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final IconData? icon;
  final double iconSize;
  final Color color;
  final int? badgeCount;
  final double fontSize;

  /// Optional label displayed below the button.
  /// When provided, creates an action button with icon above and label below.
  final String? label;

  /// Color for the label text. Defaults to Color(0xFF374151).
  final Color? labelColor;

  const CustomButton({
    super.key,
    this.onTap,
    this.text = "",
    this.margin,
    this.padding,
    this.icon,
    this.iconSize = 16,
    required this.color,
    this.badgeCount,
    this.fontSize = 14,
    this.label,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        (label != null
            ? EdgeInsets.all(16.w)
            : EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h));

    final isIconOnly = icon != null && text.isEmpty;
    final borderRadius = BorderRadius.circular(isIconOnly ? 100.r : 16.r);

    final button = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color.withOpacity(0.15),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // Base background
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.08),
                color.withOpacity(0.15),
              ],
            ),
            borderRadius: borderRadius,
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.0,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            splashColor: color.withOpacity(0.2),
            highlightColor: color.withOpacity(0.1),
            child: Padding(
              padding: effectivePadding,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  IntrinsicWidth(
                    child: icon != null
                        ? Icon(
                            icon,
                            color: color,
                            size: iconSize.w,
                          )
                        : Text(
                            text,
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              color: color,
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  if (badgeCount != null && badgeCount! > 0)
                    Positioned(
                      top: -8.h,
                      right: -8.w,
                      child: Container(
                        constraints:
                            BoxConstraints(minWidth: 20.w, minHeight: 20.w),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.w),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            badgeCount! > 99 ? '99+' : badgeCount.toString(),
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // If label is provided, wrap button with Column to show label below
    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          8.verticalSpace,
          Text(
            label!,
            style: TextStyle(
              fontFamily: 'FilsonPro',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: labelColor ?? const Color(0xFF374151),
            ),
          ),
        ],
      );
    }

    return button;
  }
}
