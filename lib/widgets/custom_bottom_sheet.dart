// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'custom_buttom.dart';

/// A reusable custom bottom sheet widget with consistent styling
///
/// Features:
/// - Backdrop blur effect
/// - Handle bar for drag indication
/// - Optional icon with gradient background
/// - Customizable title with primary color
/// - Flexible body content
/// - Optional confirm and cancel buttons
///
/// Example usage:
/// ```dart
/// CustomBottomSheet.show(
///   title: 'Change Password',
///   icon: CupertinoIcons.lock,
///   body: YourCustomWidget(),
///   onConfirm: () {
///     // Handle confirm action
///   },
///   confirmText: 'Save',
///   showCancelButton: true,
/// );
/// ```
class CustomBottomSheet {
  /// Shows a custom bottom sheet with the specified configuration
  ///
  /// Parameters:
  /// - [title]: The title text displayed at the top
  /// - [icon]: Optional icon displayed next to the title
  /// - [body]: The main content widget
  /// - [onConfirm]: Callback when confirm button is tapped
  /// - [confirmText]: Text for the confirm button (defaults to "Confirm")
  /// - [showCancelButton]: Whether to show a cancel button (defaults to false)
  /// - [onCancel]: Optional callback when cancel button is tapped
  /// - [cancelText]: Text for the cancel button (defaults to "Cancel")
  /// - [isDismissible]: Whether the bottom sheet can be dismissed by tapping outside (defaults to true)
  /// - [enableDrag]: Whether the bottom sheet can be dragged to dismiss (defaults to true)
  static Future<T?> show<T>({
    String? title,
    IconData? icon,
    required Widget body,
    VoidCallback? onConfirm,
    String? confirmText,
    bool showCancelButton = false,
    VoidCallback? onCancel,
    String? cancelText,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return Get.bottomSheet<T>(
      barrierColor: Colors.transparent,
      Stack(
        children: [
          // Backdrop blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Bottom sheet content
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9CA3AF).withOpacity(0.08),
                  offset: const Offset(0, -3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // Title Section
                if (title != null && title.isNotEmpty) ...[
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.primaryColor.withOpacity(0.1),
                                  Get.theme.primaryColor.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              icon,
                              size: 24.w,
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          12.horizontalSpace,
                        ],
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Get.theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Body content
                body,

                // Buttons section
                if (onConfirm != null || showCancelButton) ...[
                  SizedBox(height: 24.h),
                  if (showCancelButton && onConfirm != null)
                    // Both cancel and confirm buttons - each 37.5% width
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Cancel Button
                        FractionallySizedBox(
                          widthFactor: 0.375,
                          child: CustomButton(
                            onTap: onCancel ?? () => Get.back(),
                            title: cancelText ?? StrRes.cancel,
                            color: Colors.blueGrey,
                            expand: true,
                          ),
                        ),
                        16.horizontalSpace,
                        // Confirm Button
                        FractionallySizedBox(
                          widthFactor: 0.375,
                          child: CustomButton(
                            onTap: onConfirm,
                            title: confirmText ?? 'Confirm',
                            color: Get.theme.primaryColor,
                            expand: true,
                          ),
                        ),
                      ],
                    )
                  else if (onConfirm != null)
                    // Only confirm button - 37.5% width, centered
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.375,
                        child: CustomButton(
                          onTap: onConfirm,
                          title: confirmText ?? 'Confirm',
                          color: Get.theme.primaryColor,
                          expand: true,
                        ),
                      ),
                    )
                  else if (showCancelButton)
                    // Only cancel button - 37.5% width, centered
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.375,
                        child: CustomButton(
                          onTap: onCancel ?? () => Get.back(),
                          title: cancelText ?? StrRes.cancel,
                          color: Colors.blueGrey,
                          expand: true,
                        ),
                      ),
                    ),
                ],

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }
}
