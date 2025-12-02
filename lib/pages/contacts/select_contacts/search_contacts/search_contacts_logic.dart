import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../global_search/global_search_logic.dart';
import '../select_contacts_logic.dart';

class SelectContactsFromSearchLogic extends CommonSearchLogic {
  final selectContactsLogic = Get.find<SelectContactsLogic>();
  final resultList = <dynamic>{}.obs;

  bool get isSearchNotResult =>
      searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

  @override
  void clearList() {
    resultList.clear();
  }

  void search() async {
    final results = await LoadingView.singleton.wrap(
      asyncFunction: () => Future.wait(
        [
          searchFriendWithSDK(),
          if (!selectContactsLogic.hiddenGroup) searchGroup(),
        ],
      ),
    );

    final List<SearchFriendsInfo> searchFriendList =
        results.isNotEmpty && results[0] is List<SearchFriendsInfo>
            ? results[0] as List<SearchFriendsInfo>
            : [];

    final groupList = (results.length > 1 && results[1] is List<GroupInfo>)
        ? results[1] as List<GroupInfo>
        : <GroupInfo>[];

    clearList();
    resultList
      ..addAll(searchFriendList)
      ..addAll(groupList);

    if (selectContactsLogic.action == SelAction.addMember) {
      if (searchFriendList.isNotEmpty) {
        final userIds = searchFriendList.map((e) => e.userID!).toList();
        final memberInfoList = await getMemberInfo(userIds);
        for (var element in memberInfoList) {
          selectContactsLogic.defaultCheckedIDList.add(element.userID!);
        }
      }
    }
  }

  Future<List<GroupMembersInfo>> getMemberInfo(List<String> uidList) async {
    return await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: selectContactsLogic.groupID!, userIDList: uidList);
  }
}
