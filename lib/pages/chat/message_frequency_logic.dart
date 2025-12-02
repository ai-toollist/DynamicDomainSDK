import 'package:get/get.dart';
import 'package:openim/core/controller/client_config_controller.dart';

class MessageFrequencyController extends GetxController {

  final clientConfigLogic = Get.find<ClientConfigController>();

  // 用于存储每个会话的时间戳数据
  RxMap<String, RxList<int>> sessionMessageTimestamps = <String, RxList<int>>{}.obs;

  // 时间窗口：1分钟（单位：毫秒）
  final int timeInterval = 60000;

  // 获取当前时间戳
  int get currentTimestamp => DateTime.now().millisecondsSinceEpoch;

  // 获取指定会话的时间戳列表
  RxList<int> getSessionTimestamps(String conversationID) {
    if (!sessionMessageTimestamps.containsKey(conversationID)) {
      // 如果该会话还没有数据，初始化一个空的时间戳列表
      sessionMessageTimestamps[conversationID] = <int>[].obs;
    }
    return sessionMessageTimestamps[conversationID]!;
  }

  // 移除指定会话中过期的时间戳
  void removeExpiredTimestamps(String conversationID) {
    var timestamps = getSessionTimestamps(conversationID);
    timestamps.removeWhere((timestamp) => currentTimestamp - timestamp > timeInterval);
  }

  // 添加时间戳到指定会话
  void addTimestamp(String conversationID, int timestamp) {
    getSessionTimestamps(conversationID).add(timestamp);
  }

  // 检查指定会话是否可以发送消息
  bool canSendMessage(String conversationID) {
    removeExpiredTimestamps(conversationID);

    // 获取该会话的时间戳列表
    var timestamps = getSessionTimestamps(conversationID);

    final maxMessagesPerInterval = clientConfigLogic.maxMessagesPerInterval;
    if (maxMessagesPerInterval == -1) {
      return true;
    }
    // 如果消息数量超过限制，返回 false
    return timestamps.length < maxMessagesPerInterval;
  }
}
