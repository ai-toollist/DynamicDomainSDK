import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable main content card widget that wraps page content
/// with white background and top border radius
class MainContentCard extends StatelessWidget {
  final Widget child;
  final double topMargin;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const MainContentCard({
    super.key,
    required this.child,
    this.topMargin = 100,
    this.borderRadius = 30,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius.r),
        ),
      ),
      child: padding != null
          ? Padding(
              padding: padding!,
              child: child,
            )
          : child,
    );
  }
}
