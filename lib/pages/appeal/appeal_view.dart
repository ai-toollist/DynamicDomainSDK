// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim/pages/appeal/appeal_logic.dart';
import 'package:openim/widgets/custom_buttom.dart';
import 'package:openim_common/openim_common.dart';

import '../../widgets/gradient_scaffold.dart';

class AppealPage extends StatelessWidget {
  AppealPage({super.key});

  final logic = Get.find<AppealLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: GradientScaffold(
        title: StrRes.appealSubmit,
        showBackButton: true,
        trailing: CustomButton(
          onTap: logic.submitAppeal,
          title: StrRes.confirm,
          color: const Color(0xFF34D399),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          fontSize: 14.sp,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StrRes.restrictedUseReason
                      .replaceFirst('%s', logic.blockReason.value),
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 15.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                20.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: TextField(
                    controller: logic.descriptionController,
                    focusNode: logic.descriptionFocusNode,
                    maxLines: 6,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 14.sp,
                      color: const Color(0xFF111827),
                    ),
                    decoration: InputDecoration(
                      hintText: StrRes.enterAppealDetails,
                      hintStyle: TextStyle(
                        fontFamily: 'FilsonPro',
                        fontSize: 14.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.w),
                    ),
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
