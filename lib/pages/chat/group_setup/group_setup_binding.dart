import 'package:get/get.dart';
import 'package:openim/core/controller/link_controller.dart';

import 'group_setup_logic.dart';

class GroupSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupSetupLogic());
    Get.lazyPut(() => LinkController());
  }
}
