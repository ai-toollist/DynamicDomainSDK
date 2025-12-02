class GroupOnlineInfo {
  final String groupId;
  final int memberCount;
  final List<String> onlineUserId;
  final List<String> onlineUserIdDay;
  final List<String> onlineUserId3Day;
  final List<String> onlineUserIdWeek;

  GroupOnlineInfo({
    required this.groupId,
    required this.memberCount,
    required this.onlineUserId,
    required this.onlineUserIdDay,
    required this.onlineUserId3Day,
    required this.onlineUserIdWeek,
  });

  factory GroupOnlineInfo.fromJson(Map<String, dynamic> json) {
    return GroupOnlineInfo(
      groupId: json['groupId'] as String,
      memberCount: json['memberCount'] as int,
      onlineUserId: List<String>.from(json['onlineUserId']),
      onlineUserIdDay: List<String>.from(json['onlineUserIdDay']),
      onlineUserId3Day: List<String>.from(json['onlineUserId3Day']),
      onlineUserIdWeek: List<String>.from(json['onlineUserIdWeek']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'memberCount': memberCount,
      'onlineUserId': onlineUserId,
      'onlineUserIdDay': onlineUserIdDay,
      'onlineUserId3Day': onlineUserId3Day,
      'onlineUserIdWeek': onlineUserIdWeek,
    };
  }
}
