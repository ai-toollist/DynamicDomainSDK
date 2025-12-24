// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PreviewChatHistoryLogic extends GetxController {
  late CustomChatListViewController<Message> controller;
  final scrollController = AutoScrollController();
  late ConversationInfo conversationInfo;
  late Message searchMessage;

  final copyTextMap = <String?, String?>{};

  List<Message> get messageList => controller.list;

  int? upLastMinSeq;
  int? downLostMinSeq;

  // Audio player for voice messages
  final _audioPlayer = AudioPlayer();
  final _currentPlayClientMsgID = ''.obs;

  @override
  void onReady() {
    scrollToTopLoad();
    scrollToBottomLoad();
    _initPlayListener();
    super.onReady();
  }

  @override
  void onInit() {
    var arguments = Get.arguments;
    conversationInfo = arguments['conversationInfo'];
    searchMessage = arguments['message'];
    controller = CustomChatListViewController<Message>([searchMessage]);
    super.onInit();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  /// Initialize audio player listener
  void _initPlayListener() {
    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _currentPlayClientMsgID.value = "";
          break;
      }
    });
  }

  /// Check if voice message is playing
  bool isPlaySound(Message message) {
    return _currentPlayClientMsgID.value == message.clientMsgID!;
  }

  /// Play voice message
  void _playVoiceMessage(Message message) async {
    var isClickSame = _currentPlayClientMsgID.value == message.clientMsgID;
    if (_audioPlayer.playerState.playing) {
      _currentPlayClientMsgID.value = "";
      _audioPlayer.stop();
    }
    if (!isClickSame) {
      bool isValid = await _initVoiceSource(message);
      if (isValid) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
        _currentPlayClientMsgID.value = message.clientMsgID!;
      }
    }
  }

  /// Initialize voice source (path or url)
  Future<bool> _initVoiceSource(Message message) async {
    bool isReceived = message.sendID != OpenIM.iMManager.userID;
    String? path = message.soundElem?.soundPath;
    String? url = message.soundElem?.sourceUrl;
    bool isExistSource = false;
    if (isReceived) {
      if (null != url && url.trim().isNotEmpty) {
        isExistSource = true;
        _audioPlayer.setUrl(url);
      }
    } else {
      bool existFile = false;
      if (path != null && path.trim().isNotEmpty) {
        var file = File(path);
        existFile = await file.exists();
      }
      if (existFile) {
        isExistSource = true;
        _audioPlayer.setFilePath(path!);
      } else if (null != url && url.trim().isNotEmpty) {
        isExistSource = true;
        _audioPlayer.setUrl(url);
      }
    }
    return isExistSource;
  }

  /// Stop voice playback
  void stopVoice() {
    if (_audioPlayer.playerState.playing) {
      _currentPlayClientMsgID.value = '';
      _audioPlayer.stop();
    }
  }

  Future<bool> scrollToTopLoad() async {
    var result =
        await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
      startMsg: messageList.first,
      conversationID: conversationInfo.conversationID,
      count: 20,
    );

    upLastMinSeq = result.lastMinSeq;
    var list = result.messageList ?? [];

    final hasMore = list.length == 20;
    controller.insertAllToTop(list);
    IMUtils.calChatTimeInterval(controller.list);
    controller.topLoadCompleted(hasMore);
    return hasMore;
  }

  Future<bool> scrollToBottomLoad() async {
    var result = await OpenIM.iMManager.messageManager
        .getAdvancedHistoryMessageListReverse(
      startMsg: messageList.last,
      conversationID: conversationInfo.conversationID,
      count: 20,
    );
    downLostMinSeq = result.lastMinSeq;
    var list = result.messageList ?? [];

    final hasMore = list.length == 20;

    controller.insertAllToBottom(list);
    IMUtils.calChatTimeInterval(controller.list);
    controller.bottomLoadCompleted(hasMore);
    return hasMore;
  }

  /// 处理消息点击事件
  void parseClickEvent(Message msg) async {
    log('parseClickEvent:${jsonEncode(msg)}');
    if (msg.contentType == MessageType.custom) {
      var data = msg.customElem!.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      if (CustomMessageType.call == customType) {
        var type = map['data']['type'];
      } else if (CustomMessageType.tag == customType) {
        final data = map['data'];
        if (null != data['soundElem']) {
          final soundElem = SoundElem.fromJson(data['soundElem']);
          msg.soundElem = soundElem;
          _playVoiceMessage(msg);
        }
      }
      return;
    }
    if (msg.contentType == MessageType.voice) {
      _playVoiceMessage(msg);
      return;
    }
    IMUtils.parseClickEvent(
      msg,
      messageList: messageList,
      onViewUserInfo: viewUserInfo,
    );
  }

  /// View user profile (for card messages)
  void viewUserInfo(UserInfo userInfo) {
    AppNavigator.startUserProfilePane(
      userID: userInfo.userID!,
      nickname: userInfo.nickname,
      faceURL: userInfo.faceURL,
    );
  }

  /// 点击引用消息
  void onTapQuoteMsg(Message message) {
    if (message.contentType == MessageType.quote) {
      parseClickEvent(message.quoteElem!.quoteMessage!);
    } else if (message.contentType == MessageType.atText) {
      parseClickEvent(message.atTextElem!.quoteMessage!);
    }
  }

  void copy(Message message) {
    IMUtils.copy(
        text: copyTextMap[message.clientMsgID] ?? message.textElem!.content!);
  }

  ValueKey itemKey(Message message) => ValueKey(message.clientMsgID!);

  String? getShowTime(Message message) {
    if (message.exMap['showTime'] == true) {
      return IMUtils.getChatTimeline(message.sendTime!);
    }
    return null;
  }
}

/// 新版聊天列表控件
mixin ListViewDataCtrl {
  final controller = CustomChatListViewController<Message>([]).obs;
  final scrollController = AutoScrollController();

  List<Message> get messageList => controller.value.list;

  bool get isScrollBottom =>
      scrollController.offset == scrollController.position.maxScrollExtent;

  final newMessageCount = 0.obs;
  int newMessageStartPosition = -1;

  add(Message message, {bool scrollToBottom = false}) {
    controller.update((val) {
      val?.insertToBottom(message);
    });
    _scrollToBottom(scroll: scrollToBottom, count: 1);
  }

  addAll(List<Message> iterable, {bool scrollToBottom = false}) {
    controller.update((val) {
      // if (scrollToBottom) {
      //   if (iterable.length > 10) {
      //     val?.insertAllToTop(iterable);
      //     val?.insertAllToBottom([iterable.last]);
      //   }
      // }
      val?.insertAllToBottom(iterable);
    });
    _scrollToBottom(scroll: scrollToBottom, count: iterable.length);
  }

  insert(Message message) {
    controller.update((val) {
      val?.insertToTop(message);
    });
  }

  insertAll(List<Message> iterable) {
    controller.value.insertAllToTop(iterable);
  }

  void jumpToTop() async {
    await scrollController.scrollToTop();
  }

  void jumpToBottom() async {
    await scrollController.scrollToBottom(() {});
  }

  _scrollToBottom({
    bool scroll = false,
    int count = 0,
  }) {
    if (scroll) {
      newMessageCount.value = 0;
      newMessageStartPosition = -1;
      jumpToBottom();
    } else {
      if (newMessageStartPosition == -1) {
        newMessageStartPosition = messageList.length - 1;
        Logger.print('newMessageStartPosition: $newMessageStartPosition');
      }
      newMessageCount.value += count;
    }
  }

  scrollToIndex() {
    scrollController.scrollToIndex(
      newMessageStartPosition,
      duration: const Duration(milliseconds: 10),
    );
    newMessageCount.value = 0;
    newMessageStartPosition = -1;
  }
}
