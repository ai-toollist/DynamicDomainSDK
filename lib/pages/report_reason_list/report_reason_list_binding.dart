import 'package:get/get.dart';
import 'package:openim/pages/report_reason_list/report_reason_list_logic.dart';


class ReportReasonListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportReasonListLogic());
  }
}
