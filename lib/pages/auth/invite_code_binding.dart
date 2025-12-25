import 'package:get/get.dart';

import 'invite_code_logic.dart';

class InviteCodeBinding extends Bindings {
  @override
  void dependencies() {
    // Delete old instance if exists to avoid disposed controller issue
    if (Get.isRegistered<InviteCodeLogic>()) {
      Get.delete<InviteCodeLogic>();
    }
    Get.put(InviteCodeLogic());
  }
}
