import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatDisableInputBox extends StatelessWidget {
  const ChatDisableInputBox({super.key, this.type = 0});

  /// 0：不在群里
  final int type;

  @override
  Widget build(BuildContext context) {
    return type == 0
        ? Container(
            height: 56.h,
            color: Styles.c_F0F2F6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 14.w, color: Colors.grey),
                6.horizontalSpace,
                Expanded(
                  child: StrRes.notSendMessageNotInGroup.toText
                    ..maxLines = 2
                    ..overflow = TextOverflow.ellipsis
                    ..style = Styles.ts_8E9AB0_14sp,
                ),
              ],
            ),
          )
        : Container();
  }
}
