import 'package:get/get.dart';

import 'real_name_auth_logic.dart';

class RealNameAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RealNameAuthLogic());
  }
}
