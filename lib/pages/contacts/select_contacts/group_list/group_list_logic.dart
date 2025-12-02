import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import '../../../../routes/app_navigator.dart';
import '../select_contacts_logic.dart';

class SelectContactsFromGroupLogic extends GetxController {
  final selectContactsLogic = Get.find<SelectContactsLogic>();
  final allList = <GroupInfo>[].obs;

  @override
  void onReady() {
    _getGroupRelatedToMe();
    super.onReady();
  }

  void _getGroupRelatedToMe() async {
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    allList.addAll(list);
  }

  Iterable<GroupInfo> get operableList => allList.where(_remove);

  bool _remove(GroupInfo info) => !selectContactsLogic.isDefaultChecked(info);

  void searchGroup() async {
    final result = await AppNavigator.startSelectContactsFromSearchGroup();
    if (null != result) {
      Get.back(result: result);
    }
  }
}
