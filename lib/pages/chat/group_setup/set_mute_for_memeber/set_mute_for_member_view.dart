// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/widgets/gradient_scaffold.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim/widgets/settings_menu.dart';
import 'package:flutter/cupertino.dart';

import 'set_mute_for_member_logic.dart';

class SetMuteForGroupMemberPage extends StatelessWidget {
  final logic = Get.find<SetMuteForGroupMemberLogic>();
  final GlobalKey _confirmButtonKey = GlobalKey();

  SetMuteForGroupMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: StrRes.setMute,
      showBackButton: true,
      trailing: GestureDetector(
        key: _confirmButtonKey,
        onTap: logic.completed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            StrRes.confirm,
            style: TextStyle(
              fontFamily: 'FilsonPro',
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            16.verticalSpace,
            Obx(() => SettingsMenuSection(
                  items: [
                    _buildRadioItem(
                      label: StrRes.tenMinutes,
                      index: 0,
                    ),
                    _buildRadioItem(
                      label: StrRes.oneHour,
                      index: 1,
                    ),
                    _buildRadioItem(
                      label: StrRes.twelveHours,
                      index: 2,
                    ),
                    _buildRadioItem(
                      label: StrRes.oneDay,
                      index: 3,
                    ),
                    _buildRadioItem(
                      label: StrRes.unmute,
                      index: 4,
                      isDestructive: true,
                    ),
                  ],
                )),
            24.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 12.h), // Increased padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9CA3AF).withOpacity(0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    StrRes.custom,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp, // Slightly larger
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const Spacer(), // Push input to the right
                  Container(
                    width: 120.w, // Fixed width for the input box
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB), // Light gray background
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: const Color(0xFFE5E7EB)), // Subtle border
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: logic.controller,
                            focusNode: logic.focusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign
                                .center, // Center text in the small box
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                              color: const Color(0xFF111827),
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: '0',
                              hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          StrRes.day,
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioItem({
    required String label,
    required int index,
    bool isDestructive = false,
  }) {
    return SettingsMenuItem(
      label: label,
      showArrow: false,
      isDestroy: isDestructive,
      valueWidget: logic.index.value == index
          ? Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(Get.context!).primaryColor.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.checkmark,
                  size: 14.w,
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
            ),
      onTap: () => logic.checkedIndex(index),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }
}
