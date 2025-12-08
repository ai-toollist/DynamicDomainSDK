import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:openim/widgets/gradient_scaffold.dart';
import 'package:openim_common/openim_common.dart';

import 'process_friend_requests_logic.dart';

class ProcessFriendRequestsPage extends StatelessWidget {
  final logic = Get.find<ProcessFriendRequestsLogic>();

  ProcessFriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GradientScaffold(
      title: StrRes.newFriend,
      showBackButton: true,
      scrollable: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // User info card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: primaryColor.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  AvatarView(
                    width: 56.w,
                    height: 56.h,
                    url: logic.applicationInfo.fromFaceURL,
                    text: logic.applicationInfo.fromNickname,
                    isCircle: true,
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logic.applicationInfo.fromNickname ?? '',
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          'wants to add you as a friend',
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            16.verticalSpace,

            // Application message card
            if (IMUtils.isNotNullEmptyStr(logic.applicationInfo.reqMsg))
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message',
                      style: TextStyle(
                        fontFamily: 'FilsonPro',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      logic.applicationInfo.reqMsg ?? '',
                      style: TextStyle(
                        fontFamily: 'FilsonPro',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F2937),
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Flexible(
                  child: _buildRejectButton(context, primaryColor),
                ),
                12.horizontalSpace,
                Flexible(
                  child: _buildAcceptButton(context, primaryColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRejectButton(BuildContext context, Color primaryColor) =>
      Material(
        child: Ink(
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFDC2626),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDC2626).withOpacity(0.08),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: InkWell(
            onTap: logic.refuseFriendApplication,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.close_outline,
                    size: 18.sp,
                    color: const Color(0xFFDC2626),
                  ),
                  8.horizontalSpace,
                  Text(
                    StrRes.reject,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildAcceptButton(BuildContext context, Color primaryColor) =>
      Material(
        child: Ink(
          height: 44.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: InkWell(
            onTap: logic.acceptFriendApplication,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.checkmark_outline,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  8.horizontalSpace,
                  Text(
                    StrRes.accept,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
