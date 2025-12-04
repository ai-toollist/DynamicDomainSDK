import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable search box widget with unified styling
class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool showClearButton;
  final Widget? leading;
  final Widget? trailing;

  const SearchBox({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.showClearButton = true,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 12.w),
            child: leading ??
                Icon(
                  Icons.search,
                  color: const Color(0xFF9CA3AF),
                  size: 20.w,
                ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: const Color(0xFF374151),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (showClearButton)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                if (value.text.isEmpty) {
                  return trailing ?? const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: () {
                      controller.clear();
                      onClear?.call();
                      onChanged?.call('');
                    },
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9CA3AF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            )
          else if (trailing != null)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: trailing,
            ),
        ],
      ),
    );
  }
}

/// Search box with action button on the right
class SearchBoxWithAction extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onActionTap;
  final IconData actionIcon;
  final bool autofocus;

  const SearchBoxWithAction({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onActionTap,
    this.actionIcon = Icons.tune,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBox(
            controller: controller,
            focusNode: focusNode,
            hintText: hintText,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onClear: onClear,
            autofocus: autofocus,
          ),
        ),
        12.horizontalSpace,
        GestureDetector(
          onTap: onActionTap,
          child: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              actionIcon,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
      ],
    );
  }
}
