import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class MessageVisibilityCache {
  static final MessageVisibilityCache instance = MessageVisibilityCache._internal();

  final Map<String, bool> _messageVisibilityMap = {};

  MessageVisibilityCache._internal();

  void setVisibility(Message message, bool visible) {
    final key = _getMessageKey(message);
    if (key != null) _messageVisibilityMap[key] = visible;
  }

  bool? getVisibility(Message message) {
    final key = _getMessageKey(message);
    return key != null ? _messageVisibilityMap[key] : null;
  }

  void clear() {
    _messageVisibilityMap.clear();
  }

  String? _getMessageKey(Message message) {
    final msgID = message.clientMsgID ?? message.serverMsgID;
    final userID = OpenIM.iMManager.userID;
    if (msgID == null) return null;
    return '$userID::$msgID';
  }
}
