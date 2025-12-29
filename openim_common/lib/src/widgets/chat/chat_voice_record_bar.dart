import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

double kVoiceRecordBarHeight = 36.h;

enum RecordBarStatus {
  idle, // Not recording
  recording, // Currently recording
}

class ChatVoiceRecordBar extends StatefulWidget {
  const ChatVoiceRecordBar({
    super.key,
    this.speakBarColor,
    this.speakTextStyle,
    this.interruptListener,
    this.onRecordingChanged,
  });

  final Color? speakBarColor;
  final TextStyle? speakTextStyle;
  final Stream<bool>? interruptListener;

  /// Called when recording state changes (true = started, false = stopped)
  final Function(bool isRecording)? onRecordingChanged;

  @override
  State<ChatVoiceRecordBar> createState() => _ChatVoiceRecordBarState();
}

class _ChatVoiceRecordBarState extends State<ChatVoiceRecordBar> {
  bool _isRecording = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    _sub = widget.interruptListener?.listen((interrupt) {
      if (!mounted) return;
      if (interrupt && _isRecording) {
        setState(() {
          _isRecording = false;
        });
        widget.onRecordingChanged?.call(false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _startRecording() {
    // Only allow starting recording, not stopping
    // User must use Cancel or Send buttons to stop recording
    if (_isRecording) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _isRecording = true;
    });
    widget.onRecordingChanged?.call(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _startRecording,
      child: Container(
        height: kVoiceRecordBarHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.speakBarColor ??
              (_isRecording ? Styles.c_FF381F_opacity10 : Styles.c_FFFFFF),
          borderRadius: BorderRadius.circular(4.r),
          border: _isRecording
              ? Border.all(color: Styles.c_FF381F, width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording) ...[
              Icon(
                Icons.mic,
                color: Styles.c_FF381F,
                size: 18.w,
              ),
              4.horizontalSpace,
            ],
            Text(
              _isRecording ? StrRes.voice : StrRes.holdTalk,
              style: widget.speakTextStyle ??
                  (_isRecording
                      ? Styles.ts_FF381F_14sp
                      : Styles.ts_0C1C33_14sp),
            ),
          ],
        ),
      ),
    );
  }
}
