import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../group_requests_logic.dart';

class ProcessGroupRequestsLogic extends GetxController {
  final groupRequestsLogic = Get.find<GroupRequestsLogic>();
  late GroupApplicationInfo applicationInfo;

  @override
  void onInit() {
    applicationInfo = Get.arguments['applicationInfo'];
    super.onInit();
  }

  bool get isInvite => groupRequestsLogic.isInvite(applicationInfo);

  String get groupName => groupRequestsLogic.getGroupName(applicationInfo);

  String get inviterNickname =>
      groupRequestsLogic.getInviterNickname(applicationInfo);

  GroupMembersInfo? getMemberInfo(inviterUserID) =>
      groupRequestsLogic.getMemberInfo(inviterUserID);

  UserInfo? getUserInfo(inviterUserID) =>
      groupRequestsLogic.getUserInfo(inviterUserID);

  /// 2：通过邀请  3：通过搜索  4：通过二维码
  String get sourceFrom {
    if (applicationInfo.joinSource == 2) {
      return '$inviterNickname ${StrRes.byMemberInvite}';
    } else if (applicationInfo.joinSource == 4) {
      return StrRes.byScanQrcode;
    }
    return StrRes.bySearch;
  }

  void approve() async {
    try {
      await LoadingView.singleton.wrap(
        asyncFunction: () =>
            OpenIM.iMManager.groupManager.acceptGroupApplication(
          groupID: applicationInfo.groupID!,
          userID: applicationInfo.userID!,
          handleMsg: "reason",
        ),
      );

      // Update local storage immediately for instant UI feedback
      await groupRequestsLogic.updateApplicationStatus(
        groupID: applicationInfo.groupID!,
        userID: applicationInfo.userID!,
        handleResult: 1,
      );

      // Schedule background refresh to sync with server
      Future.delayed(const Duration(seconds: 2), () {
        groupRequestsLogic.getApplicationList();
      });

      Get.back(result: 1);
    } catch (e) {
      _parse(e);
    }
  }

  void reject() async {
    try {
      await LoadingView.singleton.wrap(
        asyncFunction: () =>
            OpenIM.iMManager.groupManager.refuseGroupApplication(
          groupID: applicationInfo.groupID!,
          userID: applicationInfo.userID!,
          handleMsg: "reason",
        ),
      );

      // Update local storage immediately for instant UI feedback
      await groupRequestsLogic.updateApplicationStatus(
        groupID: applicationInfo.groupID!,
        userID: applicationInfo.userID!,
        handleResult: -1,
      );

      // Schedule background refresh to sync with server
      Future.delayed(const Duration(seconds: 2), () {
        groupRequestsLogic.getApplicationList();
      });

      Get.back(result: -1);
    } catch (e) {
      if (e is PlatformException &&
          e.code == '${SDKErrorCode.groupApplicationHasBeenProcessed}') {
        IMViews.showToast(StrRes.groupRequestHandled);
      } else {
        IMViews.showToast(StrRes.rejectFailed);
      }
    }
  }

  _parse(e) {
    if (e is PlatformException) {
      if (e.code == '${SDKErrorCode.groupApplicationHasBeenProcessed}') {
        IMViews.showToast(StrRes.groupRequestHandled);
        return;
      }
    }
    throw e;
  }
}
