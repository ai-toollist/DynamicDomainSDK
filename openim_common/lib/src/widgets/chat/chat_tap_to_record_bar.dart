import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:openim_common/openim_common.dart';
import 'package:record/record.dart';

/// A tap-to-record voice bar that starts recording immediately on mount
/// and provides callbacks for cancel and send actions
class ChatTapToRecordBar extends StatefulWidget {
  const ChatTapToRecordBar({
    super.key,
    required this.onCancel,
    required this.onSend,
    this.maxRecordSec = 60,
  });

  final VoidCallback onCancel;
  final Function(int sec, String path) onSend;
  final int maxRecordSec;

  @override
  State<ChatTapToRecordBar> createState() => ChatTapToRecordBarState();
}

class ChatTapToRecordBarState extends State<ChatTapToRecordBar> {
  static const _dir = "voice";
  static const _ext = ".m4a";
  late String _path;
  int _startTimestamp = 0;
  final _audioRecorder = AudioRecorder();
  Timer? _timer;
  int _duration = 0;
  bool _isRecording = false;
  bool _isCancelled = false;
  bool _isSending = false;

  static int _now() => DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      _path = '${await IMUtils.createTempDir(dir: _dir)}/${_now()}$_ext';
      await _audioRecorder.start(const RecordConfig(), path: _path);
      _startTimestamp = _now();
      _isRecording = true;
      _timer?.cancel();
      _timer = null;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (!mounted) return;
        setState(() {
          _duration = ((_now() - _startTimestamp) ~/ 1000);
          if (_duration >= widget.maxRecordSec) {
            sendVoice();
          }
        });
      });
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _timer = null;
    if (_isRecording && await _audioRecorder.isRecording()) {
      await _audioRecorder.stop();
      _isRecording = false;
    }
  }

  /// Called externally to cancel the voice recording
  void cancelVoice() async {
    _isCancelled = true;
    await _stopRecording();
    // Delete the file
    try {
      final file = File(_path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting voice file: $e');
    }
    widget.onCancel();
  }

  /// Called externally to send the voice message
  void sendVoice() async {
    if (_isCancelled || _isSending) return;
    if (_duration < 2) return;

    _isSending = true;
    await _stopRecording();
    widget.onSend(_duration, _path);
  }

  @override
  void dispose() {
    _stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Recording pulse animation
          Container(
            width: 10.w,
            height: 10.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEF4444),
            ),
          ),
          8.horizontalSpace,
          // Duration text
          Text(
            IMUtils.seconds2HMS(_duration),
            style: TextStyle(
              fontFamily: 'FilsonPro',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          8.horizontalSpace,
          // Recording waveform
          SizedBox(
            width: 40.w,
            height: 20.h,
            child: Lottie.asset(
              'assets/anim/voice_record.json',
              fit: BoxFit.contain,
              package: 'openim_common',
            ),
          ),
        ],
      ),
    );
  }
}
