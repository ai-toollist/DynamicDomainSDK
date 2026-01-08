import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatFileView extends StatelessWidget {
  const ChatFileView({
    super.key,
    required this.message,
    required this.isISend,
    this.sendProgressStream,
    this.fileDownloadProgressView,
  });
  final Message message;
  final Stream<MsgStreamEv<int>>? sendProgressStream;
  final bool isISend;
  final Widget? fileDownloadProgressView;

  @override
  Widget build(BuildContext context) {
    final fileName = message.fileElem?.fileName ?? '';
    final fileSize = IMUtils.formatBytes(message.fileElem?.fileSize ?? 0);
    final textColor = Styles.c_8E9AB0;
    final nameStyle = TextStyle(
      fontSize: 11.sp,
      color: textColor,
      fontWeight: FontWeight.w500,
    );
    final sizeStyle = TextStyle(
      fontSize: 10.sp,
      color: textColor,
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 180.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // File icon
          ChatFileIconView(
            message: message,
            sendProgressStream: sendProgressStream,
            downloadProgressView: fileDownloadProgressView,
          ),
          8.verticalSpace,
          // File name
          Text(
            "$fileName ($fileSize)",
            style: nameStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
