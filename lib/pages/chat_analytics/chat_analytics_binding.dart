import 'package:get/get.dart';
import 'chat_analytics_logic.dart';

class ChatAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatAnalyticsLogic());
  }
}
