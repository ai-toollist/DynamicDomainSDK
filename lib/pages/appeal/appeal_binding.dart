import 'package:get/get.dart';

import 'appeal_logic.dart';

class AppealBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppealLogic());
  }
}
