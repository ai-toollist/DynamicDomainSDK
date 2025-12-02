import 'dart:io';

import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';

import 'app.dart';
import 'tracking_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
    if (Platform.isIOS) {
      TrackingService.requestTrackingAuthorizationIfNeeded();
    }
  });
  Config.init(() => runApp(const ChatApp()));
}
