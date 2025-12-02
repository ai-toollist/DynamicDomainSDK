import 'package:get/get.dart';
import 'package:openim/pages/reset_password/reset_password_logic.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordLogic());
  }
}
