import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

class ReportReasonListLogic extends GetxController {
  final reportTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final isGroup = Get.arguments['chatType'] == 'groupChat';
    reportTitle.value = isGroup
        ? StrRes.reportSelectGroupReason
        : StrRes.reportSelectUserReason;
  }

  Future<void> handleReport({
    required String reportReason,
  }) async {
    final result = await AppNavigator.startReportSubmit(
        chatType: Get.arguments['chatType'],
        reportReason: reportReason,
        groupID: Get.arguments['groupID'],
        userID: Get.arguments['userID']);
    if (result == true) {
      Get.back();
    }
  }
}
