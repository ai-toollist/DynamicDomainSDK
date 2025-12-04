import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable badge/count indicator widget
/// Used for unread counts, notification badges, etc.
class BadgeCount extends StatelessWidget {
  final int count;
  final double? size;
  final double? fontSize;
  final Color backgroundColor;
  final Color textColor;
  final int maxCount;
  final bool showZero;

  const BadgeCount({
    super.key,
    required this.count,
    this.size,
    this.fontSize,
    this.backgroundColor = const Color(0xFFEF4444),
    this.textColor = Colors.white,
    this.maxCount = 99,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0 && !showZero) {
      return const SizedBox.shrink();
    }

    final displayText = count > maxCount ? '$maxCount+' : count.toString();
    final isLargeNumber = displayText.length > 2;
    final defaultSize = isLargeNumber ? 20.w : 16.w;
    final actualSize = size ?? defaultSize;
    final actualFontSize = fontSize ?? (isLargeNumber ? 9.sp : 10.sp);

    return Container(
      constraints: BoxConstraints(
        minWidth: actualSize,
        minHeight: actualSize,
      ),
      padding: EdgeInsets.symmetric(horizontal: isLargeNumber ? 4.w : 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(actualSize / 2),
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontWeight: FontWeight.w700,
            fontSize: actualFontSize,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

/// A simple dot badge without count
class DotBadge extends StatelessWidget {
  final double size;
  final Color color;
  final bool show;

  const DotBadge({
    super.key,
    this.size = 8,
    this.color = const Color(0xFFEF4444),
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Badge positioned on top-right of a widget
class BadgeWrapper extends StatelessWidget {
  final Widget child;
  final Widget badge;
  final double? top;
  final double? right;

  const BadgeWrapper({
    super.key,
    required this.child,
    required this.badge,
    this.top,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top ?? -4.h,
          right: right ?? -4.w,
          child: badge,
        ),
      ],
    );
  }
}
