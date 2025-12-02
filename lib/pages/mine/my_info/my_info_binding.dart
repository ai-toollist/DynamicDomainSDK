import 'package:get/get.dart';
import 'package:openim/core/controller/link_controller.dart';
import 'my_info_logic.dart';

class MyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyInfoLogic());
    Get.lazyPut(() => LinkController());
  }
}
