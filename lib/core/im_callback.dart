import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/trtc_controller.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';

import '../pages/conversation/conversation_logic.dart';
import 'controller/app_controller.dart';

enum IMSdkStatus {
  connectionFailed,
  connecting,
  connectionSucceeded,
  syncStart,
  synchronizing,
  syncEnded,
  syncFailed,
  syncProgress,
}

enum KickoffType {
  kickedOffline,
  userTokenInvalid,
  userTokenExpired,
}

typedef CallEventSub = ({
  String userId,
  String groupId,
  CallStatus status,
  bool isSender,
  int roomId,
  CallType type,
  int? duration
});

final callEventSubject = PublishSubject<CallEventSub>();

mixin IMCallback {
  final initLogic = Get.find<AppController>();

  final Set<String> _dismissedGroupIds = <String>{};
  final Set<String> _quitGroupIds = <String>{};

  /// 收到消息撤回
  Function(RevokedInfo info)? onRecvMessageRevoked;

  /// 收到C2C消息已读回执
  Function(List<ReadReceiptInfo> list)? onRecvC2CReadReceipt;

  /// 收到新消息
  Function(Message msg)? onRecvNewMessage;

  /// 收到新消息
  Function(Message msg)? onRecvOfflineMessage;

  /// 消息发送进度回执
  Function(String msgId, int progress)? onMsgSendProgress;

  /// 已加入黑名单
  Function(BlacklistInfo u)? onBlacklistAdd;

  /// 已从黑名单移除
  Function(BlacklistInfo u)? onBlacklistDeleted;

  /// upload logs
  Function(int current, int size)? onUploadProgress;

  /// 新增会话
  final conversationAddedSubject = BehaviorSubject<List<ConversationInfo>>();

  /// 旧会话更新
  final conversationChangedSubject = BehaviorSubject<List<ConversationInfo>>();

  /// 未读消息数
  final unreadMsgCountEventSubject = PublishSubject<int>();

  /// 好友申请列表变化（包含自己发出的以及收到的）
  final friendApplicationChangedSubject =
      BehaviorSubject<FriendApplicationInfo>();

  /// 新增好友
  final friendAddSubject = BehaviorSubject<FriendInfo>();

  /// 删除好友
  final friendDelSubject = BehaviorSubject<FriendInfo>();

  /// 好友信息改变
  final friendInfoChangedSubject = BehaviorSubject<FriendInfo>();

  /// 加入黑名单
  final blacklistAddedSubject = BehaviorSubject<BlacklistInfo>();

  /// 从黑名单移除
  final blacklistDeletedSubject = BehaviorSubject<BlacklistInfo>();

  /// 自己信息更新
  final selfInfoUpdatedSubject = BehaviorSubject<UserInfo>();

  /// 用户在线状态更新
  final userStatusChangedSubject = BehaviorSubject<UserStatusInfo>();

  /// 组信息更新
  final groupInfoUpdatedSubject = BehaviorSubject<GroupInfo>();

  /// 组申请列表变化（包含自己发出的以及收到的）
  final groupApplicationChangedSubject =
      BehaviorSubject<GroupApplicationInfo>();

  final initializedSubject = PublishSubject<bool>();

  /// 群成员收到：群成员已进入
  final memberAddedSubject = BehaviorSubject<GroupMembersInfo>();

  /// 群成员收到：群成员已退出
  final memberDeletedSubject = BehaviorSubject<GroupMembersInfo>();

  /// 群成员信息变化
  final memberInfoChangedSubject = PublishSubject<GroupMembersInfo>();

  /// 被踢
  final joinedGroupDeletedSubject = BehaviorSubject<GroupInfo>();

  /// 拉人
  final joinedGroupAddedSubject = BehaviorSubject<GroupInfo>();

  final onKickedOfflineSubject = PublishSubject<KickoffType>();

  final imSdkStatusSubject =
      ReplaySubject<({IMSdkStatus status, bool reInstall, int? progress})>();

  final imSdkStatusPublishSubject =
      PublishSubject<({IMSdkStatus status, bool reInstall, int? progress})>();

  final momentsSubject = PublishSubject<WorkMomentsNotification>();

  final inputStateChangedSubject = PublishSubject<InputStatusChangedData>();

  // 是否获取系统公告
  final switchConversationStream = PublishSubject<bool>();

  void imSdkStatus(IMSdkStatus status,
      {bool reInstall = false, int? progress}) {
    imSdkStatusSubject
        .add((status: status, reInstall: reInstall, progress: progress));
    imSdkStatusPublishSubject
        .add((status: status, reInstall: reInstall, progress: progress));
  }

  void kickedOffline() {
    onKickedOfflineSubject.add(KickoffType.kickedOffline);
  }

  void userTokenInvalid() {
    onKickedOfflineSubject.add(KickoffType.userTokenInvalid);
  }

  void selfInfoUpdated(UserInfo u) {
    selfInfoUpdatedSubject.addSafely(u);
  }

  void userStausChanged(UserStatusInfo u) {
    userStatusChangedSubject.addSafely(u);
  }

  void uploadLogsProgress(int current, int size) {
    onUploadProgress?.call(current, size);
  }

  void recvMessageRevoked(RevokedInfo info) {
    onRecvMessageRevoked?.call(info);
  }

  void recvC2CMessageReadReceipt(List<ReadReceiptInfo> list) {
    onRecvC2CReadReceipt?.call(list);
  }

  void recvNewMessage(Message msg) {
    initLogic.showNotification(msg);
    onRecvNewMessage?.call(msg);
  }

  void recvCustomBusinessMessage(String s) {}

  void recvOfflineMessage(Message msg) {
    initLogic.showNotification(msg);
    onRecvOfflineMessage?.call(msg);
  }

  void progressCallback(String msgId, int progress) {
    onMsgSendProgress?.call(msgId, progress);
  }

  void blacklistAdded(BlacklistInfo u) {
    onBlacklistAdd?.call(u);
    blacklistAddedSubject.addSafely(u);
  }

  void blacklistDeleted(BlacklistInfo u) {
    onBlacklistDeleted?.call(u);
    blacklistDeletedSubject.addSafely(u);
  }

  void friendApplicationAccepted(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationAdded(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationDeleted(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationRejected(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendInfoChanged(FriendInfo u) {
    print('📝 FRIEND INFO CHANGED CALLBACK - userID: ${u.userID}, nickname: ${u.nickname}');
    friendInfoChangedSubject.addSafely(u);
    print('  - Published to friendInfoChangedSubject stream');
  }

  void friendAdded(FriendInfo u) {
    print('🎉 FRIEND ADDED CALLBACK - userID: ${u.userID}, nickname: ${u.nickname}');
    friendAddSubject.addSafely(u);
    print('  - Published to friendAddSubject stream');
  }

  void friendDeleted(FriendInfo u) {
    print('👋 FRIEND DELETED CALLBACK - userID: ${u.userID}, nickname: ${u.nickname}');
    friendDelSubject.addSafely(u);
    print('  - Published to friendDelSubject stream');
  }

  void conversationChanged(List<ConversationInfo> list) {
    conversationChangedSubject.addSafely(list);
  }

  void newConversation(List<ConversationInfo> list) {
    conversationAddedSubject.addSafely(list);
  }

  void groupApplicationAccepted(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupApplicationAdded(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupApplicationDeleted(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupApplicationRejected(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupInfoChanged(GroupInfo info) {
    groupInfoUpdatedSubject.addSafely(info);
  }

  void groupMemberAdded(GroupMembersInfo info) {
    memberAddedSubject.add(info);
  }

  void groupMemberDeleted(GroupMembersInfo info) {
    memberDeletedSubject.add(info);
  }

  void groupMemberInfoChanged(GroupMembersInfo info) {
    memberInfoChangedSubject.add(info);
  }

  /// 创建群： 初始成员收到；邀请进群：被邀请者收到
  void joinedGroupAdded(GroupInfo info) {
    joinedGroupAddedSubject.add(info);
  }

  Future<void> onGroupDismissed(GroupInfo info) async {
    _dismissedGroupIds.add(info.groupID);

    final conversationLogic = Get.find<ConversationLogic>();
    bool isOwner = info.ownerUserID == OpenIM.iMManager.userID;
    if (!isOwner) {
      List<ConversationInfo> result =
          await OpenIM.iMManager.conversationManager.getAllConversationList();
      ConversationInfo conversation =
          result.where((conv) => info.groupID == conv.groupID).toList().first;
      IMViews.showToast('${StrRes.groupDisbanded}: ${info.groupName}',
      );
      await OpenIM.iMManager.conversationManager
          .deleteConversationAndDeleteAllMsg(
        conversationID: conversation.conversationID,
      );
      conversationLogic.removeConversation(conversation.conversationID);
    }
  }

  /// 退出群：退出者收到；踢出群：被踢者收到
  Future<void> joinedGroupDeleted(GroupInfo info) async {
    joinedGroupDeletedSubject.add(info);

    if (_dismissedGroupIds.contains(info.groupID)) {
      _dismissedGroupIds.remove(info.groupID);
      return;
    }

    if (_quitGroupIds.contains(info.groupID)) {
      _quitGroupIds.remove(info.groupID);
      return;
    }

    final conversationLogic = Get.find<ConversationLogic>();
    bool isOwner = info.ownerUserID == OpenIM.iMManager.userID;
    if (!isOwner) {
      List<ConversationInfo> result =
          await OpenIM.iMManager.conversationManager.getAllConversationList();
      ConversationInfo conversation =
          result.where((conv) => info.groupID == conv.groupID).toList().first;
      IMViews.showToast('${StrRes.removedFromGroupHint}: ${info.groupName}');
      await OpenIM.iMManager.conversationManager
          .deleteConversationAndDeleteAllMsg(
        conversationID: conversation.conversationID,
      );
      conversationLogic.removeConversation(conversation.conversationID);
    }
  }

  void totalUnreadMsgCountChanged(int count) {
    initLogic.showBadge(count);
    unreadMsgCountEventSubject.addSafely(count);
  }

  void inputStateChanged(InputStatusChangedData status) {
    inputStateChangedSubject.addSafely(status);
  }

  void markGroupAsQuitting(String groupID) {
    _quitGroupIds.add(groupID);
  }

  void markGroupAsDismissing(String groupID) {
    _dismissedGroupIds.add(groupID);
  }

  void close() {
    initializedSubject.close();
    friendApplicationChangedSubject.close();
    friendAddSubject.close();
    friendDelSubject.close();
    friendInfoChangedSubject.close();
    blacklistAddedSubject.close();
    blacklistDeletedSubject.close();
    selfInfoUpdatedSubject.close();
    groupInfoUpdatedSubject.close();
    conversationAddedSubject.close();
    conversationChangedSubject.close();
    memberAddedSubject.close();
    memberDeletedSubject.close();
    memberInfoChangedSubject.close();
    onKickedOfflineSubject.close();
    groupApplicationChangedSubject.close();
    imSdkStatusSubject.close();
    imSdkStatusPublishSubject.close();
    joinedGroupDeletedSubject.close();
    joinedGroupAddedSubject.close();
  }
}
