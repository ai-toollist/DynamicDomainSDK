import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable empty state widget for empty lists/search results
class EmptyStateWidget extends StatelessWidget {
  final String? text;
  final String? imagePath;
  final Widget? image;
  final double imageSize;
  final TextStyle? textStyle;

  const EmptyStateWidget({
    super.key,
    this.text,
    this.imagePath,
    this.image,
    this.imageSize = 200,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            image!
          else if (imagePath != null)
            Image.asset(
              imagePath!,
              width: imageSize.w,
              height: imageSize.w,
              fit: BoxFit.contain,
            )
          else
            Icon(
              Icons.inbox_outlined,
              size: imageSize.w * 0.5,
              color: const Color(0xFF9CA3AF),
            ),
          if (text != null) ...[
            16.verticalSpace,
            Text(
              text!,
              style: textStyle ??
                  TextStyle(
                    fontFamily: 'FilsonPro',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state with search context
class SearchEmptyState extends StatelessWidget {
  final String query;
  final String? message;

  const SearchEmptyState({
    super.key,
    required this.query,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      image: Icon(
        Icons.search_off_rounded,
        size: 80.w,
        color: const Color(0xFF9CA3AF),
      ),
      text: message ?? 'No results found for "$query"',
    );
  }
}

/// Initial empty state before search
class InitialEmptyState extends StatelessWidget {
  final String? message;

  const InitialEmptyState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      image: Icon(
        Icons.search_rounded,
        size: 80.w,
        color: const Color(0xFFD1D5DB),
      ),
      text: message ?? 'Enter keywords to search',
    );
  }
}
