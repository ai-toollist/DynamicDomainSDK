import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:vibration/vibration.dart';

import 'im_controller.dart';
import 'push_controller.dart';

class AppController extends GetxController {
  var isRunningBackground = false;
  var isAppBadgeSupported = false;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  final _ring = 'assets/audio/message_ring.wav';
  final _audioPlayer = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      // handleInterruptions: false,
      // androidApplyAudioAttributes: false,
      // handleAudioSessionActivation: false,
      );

  Future<void> runningBackground(bool run) async {
    Logger.print('-----App running background : $run-------------');

    if (isRunningBackground && !run) {}
    isRunningBackground = run;
    if (!run) {
      _cancelAllNotifications();
    }
  }

  @override
  void onInit() async {
    _requestPermissions();
    _initPlayer();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {},
    );
    super.onInit();
  }

  void checkAppBadgeSupport() async {
    isAppBadgeSupported = await AppBadgePlus.isSupported();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(im.Message message) async {
    if (!await _shouldNotify(message)) return;
    await promptSoundOrNotification(message);
  }

  Future<bool> _shouldNotify(im.Message message) async {
    if (_isGlobalNotDisturb()) return false;
    if (message.attachedInfoElem?.notSenderNotificationPush == true) {
      return false;
    }
    if (message.contentType == im.MessageType.typing) return false;
    if (message.sendID == OpenIM.iMManager.userID) return false;
    if (message.contentType! >= 1000 && message.contentType != 1400) {
      return false;
    }

    var sourceID = message.sessionType == ConversationType.single
        ? message.sendID
        : message.groupID;
    if (sourceID == null || message.sessionType == null) return false;

    try {
      final conv =
          await OpenIM.iMManager.conversationManager.getOneConversation(
        sourceID: sourceID,
        sessionType: message.sessionType!,
      );
      return conv.recvMsgOpt == 0;
    } catch (e) {
      // 如果获取会话失败，保守起见不通知
      return false;
    }
  }

  Future<void> promptSoundOrNotification(im.Message message) async {
    // final sdkStatus = Get.find<IMController>().imSdkStatusSubject.values.lastOrNull?.status;
    // if (sdkStatus != null && sdkStatus != IMSdkStatus.syncEnded) return;
    final userRemarkMap = Get.find<IMController>().userRemarkMap;
    final renderName =
        userRemarkMap[message.sendID] ?? message.senderNickname ?? '';
    final seq = message.seq!;
    if (!isRunningBackground) {
      _playMessageSound();
      return;
    }

    final notificationDetails = Platform.isAndroid
        ? _androidNotificationDetails()
        : _iosNotificationDetails();

    await flutterLocalNotificationsPlugin.show(
      seq,
      '新消息',
      '$renderName: 您收到了一条新消息',
      notificationDetails,
      payload: '',
    );
  }

  NotificationDetails _androidNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'chat',
      '${Config.appName}聊天消息',
      channelDescription: '来自${Config.appName}聊天的信息',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    return const NotificationDetails(android: androidDetails);
  }

  NotificationDetails _iosNotificationDetails() {
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return const NotificationDetails(iOS: iosDetails);
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void showBadge(count) {
    if (isAppBadgeSupported) {
      OpenIM.iMManager.messageManager.setAppBadge(count);

      if (count == 0) {
        removeBadge();
        PushController.resetBadge();
      } else {
        AppBadgePlus.updateBadge(count);
        PushController.setBadge(count);
      }
    }
  }

  void removeBadge() {
    AppBadgePlus.updateBadge(0);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Locale? getLocale() {
    var local = Get.locale;
    var index = DataSp.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = const Locale('zh', 'CN');
        break;
      case 2:
        local = const Locale('en', 'US');
        break;
    }
    return local;
  }

  @override
  void onReady() {
    _cancelAllNotifications();
    super.onReady();
  }

  /// 全局免打扰
  bool _isGlobalNotDisturb() {
    bool isRegistered = Get.isRegistered<IMController>();
    if (isRegistered) {
      var logic = Get.find<IMController>();
      return logic.userInfo.value.globalRecvMsgOpt == 2;
    }
    return false;
  }

  void _initPlayer() {
    _audioPlayer.setAsset(_ring, package: 'openim_common');
    // _audioPlayer.setLoopMode(LoopMode.off);
    // _audioPlayer.setVolume(1.0);
    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _stopMessageSound();
          // _audioPlayer.seek(null);
          break;
      }
    });
  }

  /// 播放提示音
  void _playMessageSound() async {
    bool isRegistered = Get.isRegistered<IMController>();
    bool isAllowVibration = true;
    bool isAllowBeep = true;
    if (isRegistered) {
      var logic = Get.find<IMController>();
      isAllowVibration = logic.userInfo.value.allowVibration == 1;
      isAllowBeep = logic.userInfo.value.allowBeep == 1;
    }
    // 获取系统静音、震动状态
    RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;

    if (!_audioPlayer.playerState.playing &&
        isAllowBeep &&
        (ringerStatus == RingerModeStatus.normal ||
            ringerStatus == RingerModeStatus.unknown)) {
      _audioPlayer.setAsset(_ring, package: 'openim_common');
      _audioPlayer.setLoopMode(LoopMode.off);
      _audioPlayer.setVolume(1.0);
      _audioPlayer.play();
    }

    if (isAllowVibration &&
        (ringerStatus == RingerModeStatus.normal ||
            ringerStatus == RingerModeStatus.vibrate ||
            ringerStatus == RingerModeStatus.unknown)) {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate();
      }
    }
  }

  /// 关闭提示音
  void _stopMessageSound() async {
    if (_audioPlayer.playerState.playing) {
      _audioPlayer.stop();
    }
  }
}
