// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../widgets/file_download_progress.dart';
import 'file_logic.dart';
import '../../../../../widgets/gradient_scaffold.dart';

class ChatHistoryFilePage extends StatelessWidget {
  final logic = Get.find<ChatHistoryFileLogic>();

  ChatHistoryFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: StrRes.file,
      showBackButton: true,
      body: Obx(() => SmartRefresher(
            controller: logic.refreshController,
            onRefresh: logic.onRefresh,
            onLoading: logic.onLoad,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            child: _buildListView(),
          )),
    );
  }

  Widget _buildListView() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        itemCount: logic.messageList.length,
        itemBuilder: (_, index) =>
            AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 400),
          child: SlideAnimation(
            verticalOffset: 40.0,
            child: FadeInAnimation(
              curve: Curves.easeOutCubic,
              child: _buildItemView(
                  logic.messageList.reversed.elementAt(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemView(Message message) => GestureDetector(
        onTap: () => logic.viewFile(message),
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9CA3AF).withOpacity(0.08),
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF60A5FA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF60A5FA).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: ChatFileIconView(
                    message: message,
                    downloadProgressView: FileDownloadProgressView(message),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithMidEllipsis(
                      message.fileElem!.fileName!,
                      style: TextStyle(
                        fontFamily: 'FilsonPro',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    6.verticalSpace,
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF60A5FA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            IMUtils.formatBytes(message.fileElem!.fileSize!),
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF60A5FA),
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            message.senderNickname!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        6.horizontalSpace,
                        Text(
                          IMUtils.getChatTimeline(message.sendTime!),
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
              ),
              10.horizontalSpace,
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF60A5FA).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  CupertinoIcons.cloud_download,
                  color: const Color(0xFF60A5FA),
                  size: 16.w,
                ),
              ),
            ],
          ),
        ),
      );
}
