// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A reusable gradient header widget used across multiple pages
/// Supports multiple layouts: main pages (with title/subtitle), detail pages (with back button), etc.
class GradientHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final Widget? customContent;
  final double height;
  final bool showSafeArea;
  final bool showBackButton;
  final bool centerTitle;
  final VoidCallback? onBack;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const GradientHeader({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.customContent,
    this.height = 180,
    this.showSafeArea = true,
    this.showBackButton = false,
    this.centerTitle = false,
    this.onBack,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Factory constructor for main pages (Conversation, Contacts, Mine)
  factory GradientHeader.main({
    required String title,
    String? subtitle,
    Widget? trailing,
    double height = 210,
  }) {
    return GradientHeader(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      height: height,
    );
  }

  /// Factory constructor for detail pages with back button (ChatSetup, GroupSetup, AccountSetup)
  factory GradientHeader.detail({
    required String title,
    VoidCallback? onBack,
    Widget? trailing,
    double height = 180,
    bool centerTitle = true,
  }) {
    return GradientHeader(
      title: title,
      showBackButton: true,
      centerTitle: centerTitle,
      onBack: onBack,
      trailing: trailing,
      height: height,
    );
  }

  /// Factory constructor for pages with custom content
  factory GradientHeader.custom({
    required Widget content,
    double height = 180,
    bool showSafeArea = true,
    EdgeInsetsGeometry? padding,
  }) {
    return GradientHeader(
      customContent: content,
      height: height,
      showSafeArea: showSafeArea,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.7),
            primaryColor,
            primaryColor.withOpacity(0.9),
          ],
        ),
      ),
      child: showSafeArea
          ? SafeArea(child: _buildContent(context))
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (customContent != null) {
      return Padding(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: customContent!,
      );
    }

    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: showBackButton
          ? _buildDetailHeader(context)
          : _buildMainHeader(context),
    );
  }

  Widget _buildMainHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leading != null) ...[
              leading!,
              12.horizontalSpace,
            ],
            Expanded(
              child: Text(
                title ?? '',
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (subtitle != null) ...[
          4.verticalSpace,
          Text(
            subtitle!,
            style: TextStyle(
              fontFamily: 'FilsonPro',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            color: Colors.transparent,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
        if (centerTitle) ...[
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
          // Balance spacer for centered title
          trailing ?? SizedBox(width: 36.w),
        ] else ...[
          12.horizontalSpace,
          Expanded(
            child: Text(
              title ?? '',
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: Colors.white,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ],
    );
  }
}

/// Header action button with white opacity background
class HeaderActionButton extends StatelessWidget {
  final GlobalKey? buttonKey;
  final VoidCallback onTap;
  final IconData icon;

  const HeaderActionButton({
    super.key,
    this.buttonKey,
    required this.onTap,
    this.icon = Icons.grid_view,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.w,
        ),
      ),
    );
  }
}
