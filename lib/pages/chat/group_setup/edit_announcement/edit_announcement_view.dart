// ignore_for_file: deprecated_member_use

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../widgets/custom_buttom.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim/widgets/gradient_scaffold.dart';

import 'edit_announcement_logic.dart';

class EditGroupAnnouncementPage extends StatelessWidget {
  final logic = Get.find<EditGroupAnnouncementLogic>();

  EditGroupAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() => GradientScaffold(
          title: StrRes.groupAc,
          showBackButton: true,
          bodyColor: const Color(0xFFF9FAFB),
          trailing: logic.hasEditPermissions.value
              ? CustomButton(
                  title: logic.onlyRead.value ? StrRes.edit : StrRes.publish,
                  color: primaryColor,
                  onTap: () {
                    if (logic.onlyRead.value) {
                      logic.editing();
                    } else {
                      logic.publish();
                    }
                  },
                )
              : null,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 200.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9CA3AF).withOpacity(0.1),
                        offset: const Offset(0, 10),
                        blurRadius: 30,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author Info
                      if ((logic.updateMember.value.nickname ?? '').isNotEmpty)
                        Row(
                          children: [
                            AvatarView(
                              url: logic.updateMember.value.faceURL,
                              text: logic.updateMember.value.nickname,
                              width: 44.w,
                              height: 44.h,
                            ),
                            12.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  logic.updateMember.value.nickname ?? '',
                                  style: TextStyle(
                                    fontFamily: 'FilsonPro',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                                2.verticalSpace,
                                Text(
                                  '${StrRes.updatedAt} ${DateUtil.formatDateMs(
                                    (logic.groupInfo.value
                                            .notificationUpdateTime ??
                                        0),
                                    format: IMUtils.getTimeFormat3(),
                                  )}',
                                  style: TextStyle(
                                    fontFamily: 'FilsonPro',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      if ((logic.updateMember.value.nickname ?? '').isNotEmpty)
                        20.verticalSpace,

                      // Content
                      logic.onlyRead.value
                          ? SelectableText(
                              logic.inputCtrl.text,
                              style: TextStyle(
                                fontFamily: 'FilsonPro',
                                fontSize: 16.sp,
                                height: 1.6,
                                color: const Color(0xFF374151),
                              ),
                            )
                          : TextField(
                              controller: logic.inputCtrl,
                              focusNode: logic.focusNode,
                              style: TextStyle(
                                fontFamily: 'FilsonPro',
                                fontSize: 16.sp,
                                height: 1.6,
                                color: const Color(0xFF374151),
                              ),
                              enabled: !logic.onlyRead.value,
                              maxLines: null,
                              minLines: 5,
                              maxLength: 250,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: StrRes.plsEnterGroupAc,
                                hintStyle: TextStyle(
                                  fontFamily: 'FilsonPro',
                                  fontSize: 16.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                                counterStyle: TextStyle(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 12.sp),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                    ],
                  ),
                ),
                // Footer Tip
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info_circle_fill,
                        size: 16.w,
                        color: const Color(0xFF9CA3AF),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          StrRes.groupAcPermissionTips,
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 13.sp,
                            color: const Color(0xFF9CA3AF),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
