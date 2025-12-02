import 'package:get/get.dart';
import 'package:openim/core/controller/client_config_controller.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

class WorkbenchLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final clientConfigLogic = Get.find<ClientConfigController>();

  String get discoverPageURL => clientConfigLogic.discoverPageURL;
}
