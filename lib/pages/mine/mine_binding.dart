import 'package:get/get.dart';

import 'mine_logic.dart';
import '../chat_analytics/chat_analytics_logic.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => ChatAnalyticsLogic());
  }
}
