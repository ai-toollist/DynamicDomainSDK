// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable menu item widget with optional icon, value, and text color.
/// Used in group_setup_view, chat_setup_view, and similar pages.
class MenuItemWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final String? value;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const MenuItemWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.value,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20.w,
                color: textColor ?? const Color(0xFF1F2937),
              ),
              12.horizontalSpace,
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? const Color(0xFF1F2937),
                ),
              ),
            ),
            if (value != null) ...[
              8.horizontalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 150.w),
                child: Text(
                  value!,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 14.w,
              color: const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable toggle menu item widget with a custom toggle switch.
/// Used in group_setup_view, chat_setup_view, and similar pages.
class ToggleMenuItemWidget extends StatelessWidget {
  final String label;
  final bool isOn;
  final IconData? icon;
  final dynamic iconWidget;
  final ValueChanged<bool> onChanged;
  final EdgeInsetsGeometry? padding;
  final Color? activeColor;
  final bool isWarning;

  const ToggleMenuItemWidget({
    super.key,
    required this.label,
    this.icon,
    this.iconWidget,
    required this.isOn,
    required this.onChanged,
    this.padding,
    this.activeColor,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            if (iconWidget != null) ...[
              iconWidget,
              12.horizontalSpace,
            ] else if (icon != null) ...[
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: isWarning
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 20.w,
                    color: isWarning
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF424242),
                  ),
                ),
              ),
              12.horizontalSpace,
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            ToggleSwitchWidget(
              isOn: isOn,
              onChanged: onChanged,
              activeColor: activeColor,
            ),
          ],
        ),
      );
  }
}

/// A reusable custom toggle switch widget.
/// Used in group_setup_view, chat_setup_view, and similar pages.
class ToggleSwitchWidget extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final double? width;
  final double? height;

  const ToggleSwitchWidget({
    super.key,
    required this.isOn,
    required this.onChanged,
    this.activeColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isOn),
      child: Container(
        width: width ?? 52.w,
        height: height ?? 30.h,
        decoration: BoxDecoration(
          color: isOn
              ? (activeColor ?? Theme.of(context).primaryColor)
              : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: AnimatedAlign(
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Container(
            width: 26.w,
            height: 26.h,
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64748B).withOpacity(0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
