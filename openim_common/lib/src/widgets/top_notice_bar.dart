import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class TopNoticeBar extends StatelessWidget {
  final String text;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  const TopNoticeBar({
    super.key,
    required this.text,
    this.onClose,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      height: 40,
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Marquee(
                text: text,
                style: const TextStyle(
      fontFamily: 'FilsonPro',
      fontSize: 16, color: Colors.black87,
    ),
                scrollAxis: Axis.horizontal,
                blankSpace: 80.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
