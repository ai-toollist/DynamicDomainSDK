import 'package:get/get.dart';
import 'package:openim/pages/merchant_search/merchant_serarch_logic.dart';

class MerchantSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MerchantSearchLogic());
  }
}
