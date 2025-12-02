import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:search_keyword_text/search_keyword_text.dart';
import 'package:sprintf/sprintf.dart';

class GroupItemView extends StatelessWidget {
  final GroupInfo info;
  final bool showMemberCount;
  final bool showDivider;
  final String? keyText;
  final VoidCallback? onTap;

  const GroupItemView({
    super.key,
    required this.info,
    this.showMemberCount = true,
    this.showDivider = false,
    this.keyText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          height: 64.h,
          color: Styles.c_FFFFFF,
          child: InkWell(
            onTap: onTap,
            child: Container(
              color: const Color(0xFFF9FAFB),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  AvatarView(
                    url: info.faceURL,
                    text: info.groupName,
                    isCircle: true,
                    isGroup: true,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (keyText != null && keyText!.isNotEmpty)
                          SearchKeywordText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: info.groupName ?? '',
                            keyText: RegExp.escape(keyText!),
                            style: Styles.ts_0C1C33_17sp,
                            keyStyle: Styles.ts_0089FF_17sp,
                          ),
                        if (keyText == null || keyText!.isEmpty)
                          Text(
                            info.groupName ?? '',
                            style: Styles.ts_0C1C33_17sp,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (showMemberCount)
                          sprintf(StrRes.nPerson, [info.memberCount]).toText
                            ..style = Styles.ts_8E9AB0_14sp,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: EdgeInsets.only(left: 70.w),
            height: 0.5,
            color: Styles.c_E8EAEF,
          ),
      ],
    );
  }
}
