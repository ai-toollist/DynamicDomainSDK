import 'dart:async';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../../core/controller/im_controller.dart';
import '../../core/im_callback.dart';

class FriendListLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final friendList = <ISUserInfo>[].obs;

  Map<String, String> userRemarkMap = <String, String>{};
  Map<String, bool> friendIDMap = <String, bool>{};

  late StreamSubscription delSub;
  late StreamSubscription addSub;
  late StreamSubscription infoChangedSub;
  late StreamSubscription syncStatusSub;

  @override
  void onInit() {
    delSub = imLogic.friendDelSubject.listen(_delFriend);
    addSub = imLogic.friendAddSubject.listen(_addFriend);
    infoChangedSub =
        imLogic.friendInfoChangedSubject.listen(_friendInfoChanged);
    // Don't auto-remove friends when added to blacklist
    // imLogic.onBlacklistAdd = _delFriend;
    // imLogic.onBlacklistDeleted = _addFriend;

    // Listen to SDK sync status to refresh friend list when sync completes
    syncStatusSub = imLogic.imSdkStatusPublishSubject.listen((status) {
      if (status.status == IMSdkStatus.syncEnded) {
        Logger.print('SDK sync ended, refreshing friend list...');
        refreshFriendList();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    delSub.cancel();
    addSub.cancel();
    infoChangedSub.cancel();
    syncStatusSub.cancel();
    super.onClose();
  }

  Future<bool> refreshFriendList() async {
    const int initialBatchSize = 10000;
    const int subsequentBatchSize = 1000;
    int offset = 0;
    int batchSize = initialBatchSize;
    List<FriendInfo> allFriends = [];

    try {
      // 分页拉取好友数据
      while (true) {
        final batch =
            await OpenIM.iMManager.friendshipManager.getFriendListPage(
          offset: offset,
          count: batchSize,
        );

        if (batch.isEmpty) break;

        allFriends.addAll(batch);
        offset += batch.length;
        batchSize = subsequentBatchSize;
      }

      // 转换为内部数据模型
      final users =
          allFriends.map((e) => ISUserInfo.fromJson(e.toJson())).toList();

      final uniqueUsersMap = <String, ISUserInfo>{};
      for (var user in users) {
        if (user.userID != null) {
          uniqueUsersMap[user.userID!] = user;
        }
      }
      final uniqueUsers = uniqueUsersMap.values.toList();

      // 排序后赋值给 UI 列表
      final sortedUsers = IMUtils.convertToAZList(uniqueUsers);
      friendList.assignAll(sortedUsers.cast<ISUserInfo>());

      // 构建缓存
      imLogic.userRemarkMap = {
        for (var user in friendList)
          if (user.remark?.isNotEmpty ?? false) user.userID!: user.remark!
      };
      imLogic.friendIDMap = {for (var user in friendList) user.userID!: true};

      return true;
    } catch (e) {
      return false;
    }
  }

  _addFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      _addUser(user.toJson());
    }
  }

  _delFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      friendList.removeWhere((e) => e.userID == user.userID);
      // A-Z sort.
      SuspensionUtil.sortListBySuspensionTag(friendList);

      // show sus tag.
      SuspensionUtil.setShowSuspensionStatus(friendList);
    }
  }

  _friendInfoChanged(FriendInfo user) {
   friendList.removeWhere((e) => e.userID == user.userID);
    _addUser(user.toJson());
  }

  void _addUser(Map<String, dynamic> json) {
    final info = ISUserInfo.fromJson(json);
    friendList.add(IMUtils.setAzPinyinAndTag(info) as ISUserInfo);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(friendList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(friendList);
    // IMUtil.convertToAZList(friendList);

    // friendList.refresh();
  }

  void friendListRefresh() {
    friendList.refresh();
  }

  void viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
        userID: info.userID!,
        nickname: info.nickname,
        faceURL: info.faceURL,
      );
}
