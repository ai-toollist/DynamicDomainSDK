import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatMultiSelToolbox extends StatelessWidget {
  const ChatMultiSelToolbox(
      {super.key, this.onDelete, this.onMergeForward, this.onCancel});
  final Function()? onDelete;
  final Function()? onMergeForward;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.c_F0F2F6,
      height: 92.h,
      // padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // 98.horizontalSpace, // Removed fixed spacing
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline_outlined,
                      size: 24.w, color: Colors.red),
                ),
                4.verticalSpace,
                StrRes.delete.toText..style = Styles.ts_FF381F_12sp,
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onMergeForward,
                  child: Icon(Icons.ios_share_outlined, size: 24.w),
                ),
                4.verticalSpace,
                StrRes.mergeForward.toText..style = Styles.ts_0C1C33_10sp,
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onCancel,
                  child: Icon(Icons.close, size: 24.w),
                ),
                4.verticalSpace,
                StrRes.cancel.toText..style = Styles.ts_0C1C33_10sp,
              ],
            ),
          ),
          // 98.horizontalSpace,
        ],
      ),
    );
  }
}
