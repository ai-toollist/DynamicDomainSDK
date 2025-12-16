import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';
import '../../home/home_logic.dart';

class FriendRequestsLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final applicationList = <FriendApplicationInfo>[].obs;
  final selectedTab = 'waiting'.obs;
  late StreamSubscription faSub;

  @override
  void onInit() {
    faSub = imLogic.friendApplicationChangedSubject.listen((value) {
      _getFriendRequestsList();
    });
    super.onInit();
  }

  @override
  void onReady() {
    _getFriendRequestsList();
    super.onReady();
  }

  @override
  void onClose() {
    faSub.cancel();
    homeLogic.getUnhandledFriendApplicationCount();
    super.onClose();
  }

  /// 获取好友申请列表
  void _getFriendRequestsList() async {
    final list = await Future.wait([
      OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient(),
      OpenIM.iMManager.friendshipManager.getFriendApplicationListAsApplicant(),
    ]);

    final allList = <FriendApplicationInfo>[];
    allList
      ..addAll(list[0])
      ..addAll(list[1]);

    allList.sort((a, b) {
      if (a.createTime! > b.createTime!) {
        return -1;
      } else if (a.createTime! < b.createTime!) {
        return 1;
      }
      return 0;
    });

    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication();
    haveReadList ??= <String>[];
    for (var e in list[0]) {
      var id = IMUtils.buildFriendApplicationID(e);
      if (!haveReadList.contains(id)) {
        haveReadList.add(id);
      }
    }
    DataSp.putHaveReadUnHandleFriendApplication(haveReadList);
    applicationList.assignAll(allList);
  }

  bool isISendRequest(FriendApplicationInfo info) =>
      info.fromUserID == OpenIM.iMManager.userID;

  /// 接受好友申请 - 直接处理
  void acceptFriendApplication(FriendApplicationInfo info) async {
    try {
      await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.friendshipManager
            .acceptFriendApplication(
          userID: info.fromUserID ?? '',
          handleMsg: '',
        ),
      );
      
      // 更新该条申请的状态
      final index = applicationList.indexWhere((item) => 
        item.fromUserID == info.fromUserID && 
        item.toUserID == info.toUserID &&
        item.createTime == info.createTime
      );
      
      if (index != -1) {
        final updatedInfo = FriendApplicationInfo(
          fromUserID: info.fromUserID,
          fromNickname: info.fromNickname,
          fromFaceURL: info.fromFaceURL,
          toUserID: info.toUserID,
          toNickname: info.toNickname,
          toFaceURL: info.toFaceURL,
          reqMsg: info.reqMsg,
          createTime: info.createTime,
          handleTime: DateTime.now().millisecondsSinceEpoch,
          handleMsg: '',
          handleResult: 1, // Agreed status
        );
        applicationList[index] = updatedInfo;
      }
      
      IMViews.showToast(StrRes.approved,type:1);
      homeLogic.getUnhandledFriendApplicationCount();
    } catch (e) {
      IMViews.showToast(StrRes.addFailed);
    }
  }

  /// 拒绝好友申请 - 直接处理
  void refuseFriendApplication(FriendApplicationInfo info) async {
    try {
      await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.friendshipManager
            .refuseFriendApplication(
          userID: info.fromUserID ?? '',
          handleMsg: '',
        ),
      );
      
      // 更新该条申请的状态
      final index = applicationList.indexWhere((item) => 
        item.fromUserID == info.fromUserID && 
        item.toUserID == info.toUserID &&
        item.createTime == info.createTime
      );
      
      if (index != -1) {
        final updatedInfo = FriendApplicationInfo(
          fromUserID: info.fromUserID,
          fromNickname: info.fromNickname,
          fromFaceURL: info.fromFaceURL,
          toUserID: info.toUserID,
          toNickname: info.toNickname,
          toFaceURL: info.toFaceURL,
          reqMsg: info.reqMsg,
          createTime: info.createTime,
          handleTime: DateTime.now().millisecondsSinceEpoch,
          handleMsg: '',
          handleResult: -1, // Rejected status
        );
        applicationList[index] = updatedInfo;
      }
      
      IMViews.showToast(StrRes.rejectSuccessfully,type:1);
      homeLogic.getUnhandledFriendApplicationCount();
    } catch (e) {
      IMViews.showToast(StrRes.rejectFailed);
    }
  }
}
