import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatVoiceView extends StatefulWidget {
  final bool isISend;
  final String? soundPath;
  final String? soundUrl;
  final int? duration;
  final bool isPlaying;

  const ChatVoiceView({
    super.key,
    required this.isISend,
    this.soundPath,
    this.soundUrl,
    this.duration,
    this.isPlaying = false,
  });

  @override
  State<ChatVoiceView> createState() => _ChatVoiceViewState();
}

class _ChatVoiceViewState extends State<ChatVoiceView>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isPlaying) {
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(ChatVoiceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _waveController.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _waveController.stop();
      _waveController.reset();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  String _formatDuration() {
    final d = widget.duration ?? 0;
    if (d >= 60) {
      final minutes = d ~/ 60;
      final seconds = d % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return '0:${d.toString().padLeft(2, '0')}';
  }

  /// Build static or animated waveform bars
  Widget _buildWaveformBars() {
    const int barCount = 20;
    const double maxHeight = 16.0;
    const double minHeight = 4.0;

    // Generate random but consistent heights for static waveform
    final random = math.Random(widget.duration ?? 0);
    final staticHeights = List.generate(
      barCount,
      (index) => minHeight + random.nextDouble() * (maxHeight - minHeight),
    );

    if (!widget.isPlaying) {
      // Static waveform when not playing
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(barCount, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            width: 2.w,
            height: staticHeights[index].h,
            decoration: BoxDecoration(
              color: widget.isISend
                  ? Colors.white.withOpacity(0.8)
                  : Styles.c_0089FF.withOpacity(0.6),
              borderRadius: BorderRadius.circular(1.r),
            ),
          );
        }),
      );
    }

    // Animated waveform when playing
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(barCount, (index) {
            // Stagger the phase for each bar
            final phase = index * (math.pi * 2 / barCount);
            final animValue =
                math.sin(_waveController.value * 2 * math.pi + phase);
            final height =
                minHeight + (maxHeight - minHeight) * ((animValue + 1) / 2);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: 2.w,
              height: height.h,
              decoration: BoxDecoration(
                color: widget.isISend ? Colors.white : Styles.c_0089FF,
                borderRadius: BorderRadius.circular(1.r),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildVoiceContent() {
    final durationText = _formatDuration();
    final textColor = widget.isISend ? Colors.white : Styles.c_0089FF;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.isISend
          ? [
              // Duration first for sent messages
              Text(
                durationText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              8.horizontalSpace,
              _buildWaveformBars(),
            ]
          : [
              // Waveform first for received messages
              _buildWaveformBars(),
              8.horizontalSpace,
              Text(
                durationText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVoiceContent();
  }
}
