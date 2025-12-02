import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class WeChatTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final VoidCallback? onBack;
  final VoidCallback? onAdd;
  final bool showBack;
  final bool showAdd;
  final List<Widget>? actions;

  const WeChatTitleBar({
    super.key,
    this.title,
    this.titleText,
    this.onBack,
    this.onAdd,
    this.showBack = false,
    this.showAdd = true,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(48.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Styles.c_EDEDED,
      titleSpacing: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: onBack,
            )
          : null,
      title: title ??
          Text(
            titleText ?? '',
            style: TextStyle(
      fontFamily: 'FilsonPro',
      color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
    ),
          ),
      actions: actions ??
          (showAdd
              ? [
                  GestureDetector(
                    onTap: onAdd,
                    child: Icon(
                      Icons.person_add,
                      color: Styles.c_0C1C33,
                      size: 28.w,
                    ),
                  )
                ]
              : []),
    );
  }
}
