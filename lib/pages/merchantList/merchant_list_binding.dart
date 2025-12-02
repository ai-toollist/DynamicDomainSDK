import 'package:get/get.dart';
import 'package:openim/pages/merchantList/merchant_list_logic.dart';

class MerchantListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MerchantListLogic());
  }
}
