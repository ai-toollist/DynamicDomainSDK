// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:openim/widgets/common_widgets.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../../routes/app_navigator.dart';
import 'group_requests_logic.dart';

class GroupRequestsPage extends StatelessWidget {
  final logic = Get.find<GroupRequestsLogic>();

  GroupRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: StrRes.groupJoinRequests,
      showBackButton: true,
      scrollable: true,
      body: Obx(() {
        if (logic.list.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Ionicons.people_outline,
                        size: 60.w,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  Text(
                    StrRes.noGroupRequests,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return AnimationLimiter(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: List.generate(
                  logic.list.length,
                  (index) => AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 40.0,
                      curve: Curves.easeOutCubic,
                      child: FadeInAnimation(
                        child: _buildItemView(
                          context,
                          logic.list[index],
                          index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildItemView(
      BuildContext context, GroupApplicationInfo info, int index) {
    final isISendRequest = info.userID == OpenIM.iMManager.userID;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          AppNavigator.startUserProfilePane(
            userID: info.userID!,
            nickname: info.nickname,
            faceURL: info.userFaceURL,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            children: [
              Row(
                children: [
                  AvatarView(
                    width: 55.w,
                    height: 55.h,
                    url: info.userFaceURL,
                    text: info.nickname,
                    isCircle: true,
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.nickname ?? '',
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        6.verticalSpace,
                        _buildActionDescription(context, info),
                      ],
                    ),
                  ),
                  12.horizontalSpace,
                  _buildActionWidget(context, info, isISendRequest),
                ],
              ),
              // Application reason (if available)
              if (null != IMUtils.emptyStrToNull(info.reqMsg)) ...[
                12.verticalSpace,
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    sprintf(StrRes.applyReason, [info.reqMsg!]),
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionDescription(
      BuildContext context, GroupApplicationInfo info) {
    final primaryColor = Theme.of(context).primaryColor;

    if (!logic.isInvite(info)) {
      // Apply join case
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          children: [
            const TextSpan(
              text: 'applied to join ',
              style: TextStyle(
                fontFamily: 'FilsonPro',
                color: Color(0xFF6B7280),
              ),
            ),
            TextSpan(
              text: logic.getGroupName(info),
              style: TextStyle(
                fontFamily: 'FilsonPro',
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      // Invite case
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: logic.getInviterNickname(info),
              style: TextStyle(
                fontFamily: 'FilsonPro',
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(
              text: ' invited you to ',
              style: TextStyle(
                fontFamily: 'FilsonPro',
                color: Color(0xFF6B7280),
              ),
            ),
            TextSpan(
              text: logic.getGroupName(info),
              style: TextStyle(
                fontFamily: 'FilsonPro',
                color: primaryColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActionWidget(
    BuildContext context,
    GroupApplicationInfo info,
    bool isISendRequest,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    if (isISendRequest) {
      if (info.handleResult == 0) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Ionicons.time_outline,
                size: 16.w,
                color: primaryColor,
              ),
              6.horizontalSpace,
              Text(
                StrRes.waitingForVerification,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (info.handleResult == 0) {
        return GestureDetector(
          onTap: () => logic.handle(info),
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                StrRes.lookOver,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
    }

    // Status indicators
    if (info.handleResult == -1) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Ionicons.close_circle_outline,
              size: 16.w,
              color: const Color(0xFFDC2626),
            ),
            6.horizontalSpace,
            Text(
              StrRes.rejected,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      );
    }

    if (info.handleResult == 1) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Ionicons.checkmark_circle_outline,
              size: 16.w,
              color: const Color(0xFF059669),
            ),
            6.horizontalSpace,
            Text(
              StrRes.approved,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF059669),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
