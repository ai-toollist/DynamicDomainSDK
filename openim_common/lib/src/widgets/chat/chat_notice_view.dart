import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

/// 群公告
class ChatNoticeView extends StatelessWidget {
  const ChatNoticeView({
    super.key,
    required this.isISend,
    required this.content,
  });
  final bool isISend;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: Border.all(color: Styles.c_E8EAEF, width: 1),
        borderRadius: borderRadius(isISend),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volume_down_rounded, size: 24.w, color: Colors.blue),
              StrRes.groupAc.toText..style = Styles.ts_0089FF_17sp,
            ],
          ),
          6.verticalSpace,
          content.toText..style = Styles.ts_0C1C33_17sp,
        ],
      ),
    );
  }
}

class TopNoticeView extends StatelessWidget {
  const TopNoticeView({
    super.key,
    required this.content,
    this.onPreview,
    this.onClose,
  });
  final String content;
  final Function()? onPreview;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Styles.c_F2F8FF,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onPreview,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volume_down_rounded, size: 24.w, color: Colors.blue),
                2.horizontalSpace,
                StrRes.groupAc.toText..style = Styles.ts_0089FF_17sp,
                const Spacer(),
                GestureDetector(
                    onTap: onClose,
                    child: Icon(Icons.close, color: Colors.grey, size: 16.w))
              ],
            ),
            8.verticalSpace,
            content.toText
              ..style = Styles.ts_0C1C33_14sp
              ..maxLines = 2
              ..overflow = TextOverflow.ellipsis,
          ],
        ),
      ),
    );
  }
}
