import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatText extends StatelessWidget {
  const ChatText({
    super.key,
    this.isISend = false,
    required this.text,
    this.allAtMap = const <String, String>{},
    this.prefixSpan,
    this.patterns = const <MatchPattern>[],
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.textStyle,
    this.maxLines,
    this.textScaleFactor = 1.0,
    this.model = TextModel.match,
    this.onVisibleTrulyText,
  });
  final bool isISend;
  final String text;
  final TextStyle? textStyle;
  final InlineSpan? prefixSpan;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double textScaleFactor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final TextModel model;
  final Function(String? text)? onVisibleTrulyText;

  @override
  Widget build(BuildContext context) {
    // Sử dụng màu từ DefaultTextStyle của context thay vì hard-code
    final defaultStyle = DefaultTextStyle.of(context).style;
    final effectiveStyle = textStyle ??
        defaultStyle.copyWith(
          fontSize: 17.sp,
          fontWeight: FontWeight.normal,
        );

    // Sử dụng màu từ defaultStyle cho @ mention để đồng nhất với màu text chính
    final matchStyle = effectiveStyle.copyWith(
      fontWeight: FontWeight.w700,
    );

    return MatchTextView(
      text: text,
      textStyle: effectiveStyle,
      matchTextStyle: matchStyle,
      prefixSpan: prefixSpan,
      textAlign: textAlign,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      allAtMap: allAtMap,
      patterns: patterns,
      model: model,
      maxLines: maxLines,
      onVisibleTrulyText: onVisibleTrulyText,
    );
  }
}
