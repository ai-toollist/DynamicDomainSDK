import 'package:get/get.dart';
import 'package:openim/core/controller/auth_controller.dart';
import 'package:openim/core/controller/gateway_config_controller.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

class MerchantListLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MerchantController merchantController = Get.find<MerchantController>();
  final AuthController authController = Get.find<AuthController>();
  final gatewayConfigController = Get.find<GatewayConfigController>();

  final merchantList = <Merchant>[].obs;
  final noData = false.obs;

  final fromLogin = false.obs;

  get defaultMerchantID => gatewayConfigController.defaultMerchantID;

  @override
  void onInit() {
    fromLogin.value = Get.arguments['fromLogin'] ?? false;
    refreshData();
    super.onInit();
  }

  void refreshData() async {
    LoadingView.singleton.wrap(
      asyncFunction: () async {
        merchantList.value = await GatewayApi.getMerchantList();
        noData.value = merchantList.isEmpty;
      },
    );
  }

  bool isExists(Merchant merchant) {
    for (var m in merchantList) {
      if (m.id == merchant.id) {
        return true;
      }
    }
    return false;
  }

  void startMerchantSearch() async {
    final changed = await AppNavigator.startMerchantSearch();
    if (changed == true) {
      noData.value = false;
      refreshData();
    }
  }

  void onSwitch(Merchant merchant) async {
    authController.switchMerchant(
        merchant: merchant, fromLogin: fromLogin.value);
  }

  void onRefresh(Merchant merchant) async {
    await authController.refreshIm();
    AppNavigator.startMain();
  }
}
