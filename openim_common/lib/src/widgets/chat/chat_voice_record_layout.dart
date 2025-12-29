import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';

typedef SpeakViewChildBuilder = Widget Function(Widget voiceWidget);

class ChatVoiceRecordLayout extends StatefulWidget {
  const ChatVoiceRecordLayout({
    super.key,
    required this.builder,
    this.locale,
    this.onCompleted,
    this.speakTextStyle,
    this.speakBarColor,
    this.maxRecordSec = 60,
  });

  final SpeakViewChildBuilder builder;
  final Locale? locale;
  final Function(int sec, String path)? onCompleted;
  final Color? speakBarColor;
  final TextStyle? speakTextStyle;

  /// 最大记录时长s
  final int maxRecordSec;

  @override
  State<ChatVoiceRecordLayout> createState() => ChatVoiceRecordLayoutState();
}

class ChatVoiceRecordLayoutState extends State<ChatVoiceRecordLayout> {
  final _interruptSub = PublishSubject<bool>();
  bool _showVoiceRecordView = false;
  bool _isCancelSend = false;

  /// Expose isRecording state for parent widgets to check
  bool get isRecording => _showVoiceRecordView;

  void _completed(int sec, String path) {
    if (_isCancelSend) {
      File(path).delete();
      _isCancelSend = false;
    } else {
      if (sec == 0) {
        File(path).delete();
        IMViews.showToast(StrRes.talkTooShort);
      } else {
        widget.onCompleted?.call(sec, path);
      }
    }
    setState(() {
      _showVoiceRecordView = false;
    });
  }

  /// Cancel recording externally (e.g., when navigating away)
  void cancelRecording() {
    if (_showVoiceRecordView) {
      _isCancelSend = true;
      _interruptSub.add(true);
      setState(() {
        _showVoiceRecordView = false;
      });
    }
  }

  /// Called when user taps Cancel button
  void _onCancelPressed() {
    _isCancelSend = true;
    _interruptSub.add(true);
    setState(() {
      _showVoiceRecordView = false;
    });
  }

  /// Called when user taps Send button
  void _onSendPressed() {
    // Recording will stop and onCompleted will be called by ChatRecordVoiceView dispose
    _isCancelSend = false;
    _interruptSub.add(true);
    // Note: _showVoiceRecordView will be set to false in _completed callback
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _interruptSub.close();
    super.dispose();
  }

  /// The voice bar that user taps to start recording
  ChatVoiceRecordBar get _createSpeakBar => ChatVoiceRecordBar(
        speakBarColor: widget.speakBarColor,
        speakTextStyle: widget.speakTextStyle,
        interruptListener: _interruptSub.stream,
        onRecordingChanged: (isRecording) {
          setState(() {
            _showVoiceRecordView = isRecording;
            if (!isRecording) {
              _isCancelSend = false;
            }
          });
        },
      );

  /// The recording controls with Cancel, Timer, and Send buttons
  Widget _buildRecordingControls(int sec) {
    return Container(
      height: kVoiceRecordBarHeight,
      decoration: BoxDecoration(
        color: Styles.c_0C1C33_opacity60,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          // Cancel button
          GestureDetector(
            onTap: _onCancelPressed,
            child: Container(
              width: 36.w,
              height: 36.w,
              margin: EdgeInsets.only(left: 4.w),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Styles.c_FF381F,
                size: 24.w,
              ),
            ),
          ),
          // Recording indicator and timer
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: _lottieAnimWidget,
                ),
                8.horizontalSpace,
                Text(
                  IMUtils.seconds2HMS(sec),
                  style: Styles.ts_FFFFFF_14sp,
                ),
              ],
            ),
          ),
          // Send button
          GestureDetector(
            onTap: _onSendPressed,
            child: Container(
              width: 36.w,
              height: 36.w,
              margin: EdgeInsets.only(right: 4.w),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Styles.c_0089FF,
                size: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the voice widget - either the speak bar or recording controls
  Widget get _voiceWidget {
    if (_showVoiceRecordView) {
      // Show recording controls with ChatRecordVoiceView for actual recording
      return ChatRecordVoiceView(
        onCompleted: _completed,
        onInterrupt: () {
          setState(() {
            _showVoiceRecordView = false;
          });
        },
        builder: (_, sec) => _buildRecordingControls(sec),
      );
    } else {
      // Show normal speak bar
      return _createSpeakBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pass the voice widget to the builder - it will be placed where the bar should be
    return widget.builder(_voiceWidget);
  }

  Widget get _lottieAnimWidget => Lottie.asset(
        'assets/anim/voice_record.json',
        fit: BoxFit.contain,
        package: 'openim_common',
      );
}
