import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'chat_logic.dart';
import 'group_setup/group_setup_logic.dart';
import '../conversation/conversation_logic.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ConversationLogic is registered (it may already be if coming from conversation list)
    if (!Get.isRegistered<ConversationLogic>()) {
      Get.lazyPut(() => ConversationLogic());
    }
    Get.lazyPut(() => ChatLogic(), tag: GetTags.chat);
    Get.lazyPut(() => GroupSetupLogic());
  }
}
