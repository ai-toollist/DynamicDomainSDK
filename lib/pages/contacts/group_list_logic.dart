import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/client_config_controller.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/core/im_callback.dart';

class GroupListLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final clientConfigLogic = Get.find<ClientConfigController>();

  final RxList<GroupInfo> allGroups = <GroupInfo>[].obs;

  int offset = 0;
  final int count = 1000;

  StreamSubscription? _joinedGroupAddedSub;
  StreamSubscription? _joinedGroupDeletedSub;
  StreamSubscription? _groupInfoUpdatedSub;

  @override
  void onInit() {
    imLogic.imSdkStatusPublishSubject.last.then((con) {
      if (con.status == IMSdkStatus.syncEnded) {
        initialLoad();
      }
    });
    initialLoad();
    _initListeners();
    super.onInit();
  }

  @override
  void onClose() {
    _joinedGroupAddedSub?.cancel();
    _joinedGroupDeletedSub?.cancel();
    _groupInfoUpdatedSub?.cancel();
    super.onClose();
  }

  void _initListeners() {
    // Listen for new groups joined
    _joinedGroupAddedSub = imLogic.joinedGroupAddedSubject.listen((groupInfo) {
      print('📢 Group joined: ${groupInfo.groupName} (${groupInfo.groupID})');
      // Check if group already exists
      final index = allGroups.indexWhere((g) => g.groupID == groupInfo.groupID);
      if (index == -1) {
        allGroups.add(groupInfo);
        print('  - Added to group list');
      } else {
        print('  - Group already exists, updating info');
        allGroups[index] = groupInfo;
      }
    });

    // Listen for groups deleted/left
    _joinedGroupDeletedSub =
        imLogic.joinedGroupDeletedSubject.listen((groupInfo) {
      print(
          '📢 Group deleted/left: ${groupInfo.groupName} (${groupInfo.groupID})');
      allGroups.removeWhere((g) => g.groupID == groupInfo.groupID);
      print('  - Removed from group list');
    });

    // Listen for group info updates
    _groupInfoUpdatedSub = imLogic.groupInfoUpdatedSubject.listen((groupInfo) {
      print(
          '📢 Group info updated: ${groupInfo.groupName} (${groupInfo.groupID})');
      final index = allGroups.indexWhere((g) => g.groupID == groupInfo.groupID);
      if (index != -1) {
        allGroups[index] = groupInfo;
        print('  - Updated group info in list');
      }
    });
  }

  void initialLoad() async {
    offset = 0;
    allGroups.clear();
    final length = await _load(offset);

    if (length >= count) offset += length;
  }

  void loadMore() async {
    final length = await _load(offset);
    if (length >= count) offset += length;
  }

  Future<int> _load(int offset) async {
    try {
      final list = await OpenIM.iMManager.groupManager.getJoinedGroupListPage(
        offset: offset,
        count: count,
      );

      allGroups.addAll(list);
      return list.length;
    } catch (e) {
      print('Error loading groups: $e');
      return 0;
    }
  }

  List<GroupInfo> get joinedList =>
      allGroups.where((g) => g.ownerUserID != OpenIM.iMManager.userID).toList();

  List<GroupInfo> get createdList =>
      allGroups.where((g) => g.ownerUserID == OpenIM.iMManager.userID).toList();

  bool shouldShowMemberCount(String ownerUserID) {
    return clientConfigLogic.shouldShowMemberCount(ownerUserID: ownerUserID);
  }
}
