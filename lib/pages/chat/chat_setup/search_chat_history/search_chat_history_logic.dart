import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../../routes/app_navigator.dart';
import 'multimedia/multimedia_logic.dart';

class SearchChatHistoryLogic extends GetxController {
  final refreshController = RefreshController();
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();
  final messageList = <Message>[].obs;
  late ConversationInfo conversationInfo;
  final searchKey = "".obs;
  final dateTime = DateTime(0).obs;
  int pageIndex = 1;
  int pageSize = 50;

  @override
  void onInit() {
    conversationInfo = Get.arguments['conversationInfo'];
    // searchCtrl.addListener(_changedSearch);
    super.onInit();
  }

  void updateSearchTime(DateTime newDateTime) {
    dateTime.value = newDateTime;
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    searchKey.value = value;
    if (value.trim().isNotEmpty) {
      search();
    }
  }

  clearDateTime() {
    dateTime.value = DateTime(0);
    messageList.clear();
  }

  clearInput() {
    searchKey.value = "";
    focusNode.requestFocus();
    messageList.clear();
  }

  bool get isSearchNotResult => (messageList.isEmpty);

  bool get isNotKey => searchKey.value.isEmpty;
  bool get isNotDate => dateTime.value.secondsSinceEpoch <= 0;

  void searchByTime() async {
    try {
      dateTime.value = dateTime.value.add(const Duration(days: 1));
      // 获取0时的时间戳
      var dateZeroTime = DateTime(
              dateTime.value.year, dateTime.value.month, dateTime.value.day)
          .secondsSinceEpoch;
      var timeDiff = DateTime.now().secondsSinceEpoch - dateZeroTime;
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.conversationID,
        //Start time point for searching. Defaults to 0, meaning searching from now. UTC timestamp, in seconds
        searchTimePosition: dateZeroTime,
        // 搜索多久时间，秒为单位
        searchTimePeriod: 24 * 60 * 60,
        pageIndex: pageIndex = 1,
        count: pageSize,
        messageTypeList: [
          MessageType.text,
          MessageType.atText,
          MessageType.quote
        ],
      );
      if (result.totalCount == 0) {
        messageList.clear();
      } else {
        var item = result.searchResultItems!.first;
        messageList.assignAll(item.messageList!);
      }
    } finally {
      if (messageList.length < pageIndex * pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  void search() async {
    try {
      // searchKey.value = searchCtrl.text.trim();
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.conversationID,
        keywordList: [searchKey.value],
        pageIndex: pageIndex = 1,
        count: pageSize,
        messageTypeList: [MessageType.text, MessageType.atText],
      );
      if (result.totalCount == 0) {
        messageList.clear();
      } else {
        var item = result.searchResultItems!.first;
        messageList.assignAll(item.messageList!);
      }
    } finally {
      if (messageList.length < pageIndex * pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  load() async {
    try {
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.conversationID,
        keywordList: [searchKey.value],
        pageIndex: ++pageIndex,
        count: pageSize,
        messageTypeList: [MessageType.text, MessageType.atText],
      );
      if (result.totalCount! > 0) {
        var item = result.searchResultItems!.first;
        messageList.addAll(item.messageList!);
      }
    } finally {
      if (messageList.length < (pageSize * pageIndex)) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  String calContent(Message message) {
    String content = IMUtils.parseMsg(message, replaceIdToNickname: true);
    // 左右间距+头像跟名称的间距+头像dax
    var usedWidth = 16.w * 2 + 10.w + 44.w;
    return IMUtils.calContent(
      content: content,
      key: searchKey.value,
      style: Styles.ts_0C1C33_17sp,
      usedWidth: usedWidth,
    );
  }

  void searchChatHistoryPicture() =>
      AppNavigator.startSearchChatHistoryMultimedia(
        conversationInfo: conversationInfo,
      );

  void searchChatHistoryByTime(DateTime dateTime) => {
        AppNavigator.startSearchChatHistoryTime(
            conversationInfo: conversationInfo, dateTime: dateTime)
      };

  void searchChatHistoryVideo() =>
      AppNavigator.startSearchChatHistoryMultimedia(
        conversationInfo: conversationInfo,
        multimediaType: MultimediaType.video,
      );

  void searchChatHistoryFile() => AppNavigator.startSearchChatHistoryFile(
        conversationInfo: conversationInfo,
      );

  void previewMessageHistory(Message message) =>
      AppNavigator.startPreviewChatHistory(
        conversationInfo: conversationInfo,
        message: message,
      );
}
