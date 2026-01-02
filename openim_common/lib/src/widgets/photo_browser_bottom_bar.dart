import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

enum OperateType {
  forward,
  save,
}

class PhotoBrowserBottomBar {
  PhotoBrowserBottomBar._();

  static void show(BuildContext context,
      {ValueChanged<OperateType>? onPressedButton}) {
    final primaryColor = Theme.of(context).primaryColor;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
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
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        CupertinoIcons.photo,
                        size: 20.w,
                        color: primaryColor,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        StrRes.selectAction,
                        style: TextStyle(
                          fontFamily: 'FilsonPro',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Options Container
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFF3F4F6),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Forward option
                    _buildOptionItem(
                      icon: CupertinoIcons.arrowshape_turn_up_right,
                      label: StrRes.menuForward,
                      primaryColor: primaryColor,
                      showDivider: true,
                      onTap: () {
                        Get.back();
                        onPressedButton?.call(OperateType.forward);
                      },
                    ),
                    // Save option
                    _buildOptionItem(
                      icon: CupertinoIcons.arrow_down_to_line,
                      label: StrRes.download,
                      primaryColor: primaryColor,
                      showDivider: false,
                      onTap: () {
                        Get.back();
                        onPressedButton?.call(OperateType.save);
                      },
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  static Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required Color primaryColor,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: showDivider
            ? BorderRadius.vertical(top: Radius.circular(16.r))
            : BorderRadius.vertical(bottom: Radius.circular(16.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: showDivider
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFF3F4F6),
                      width: 1,
                    ),
                  ),
                )
              : null,
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 20.w,
                  color: const Color(0xFF374151),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 18.w,
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
