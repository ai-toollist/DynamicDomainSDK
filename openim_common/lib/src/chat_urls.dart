///
///
/// 业务系统接口路径
/// 🏛️ 代表业务系统原有
///
///
class ChatURLs {
  /// 举报
  static const report = 'later/report/add';

  /// 申诉
  static const appeal = 'later/appeal/submit';

  /// 全局配置 🏛️
  static const getClientConfig = 'client_config/get';

  /// 更新用户信息 🏛️
  static const updateUserInfo = 'user/update';

  /// 搜索好友 🏛️
  static const searchFriendInfo = "friend/search";

  /// 获取用户信息 🏛️
  static const getUsersFullInfo = "user/find/full";

  /// 搜索用户信息 🏛️
  static const searchUserFullInfo = 'user/search/full';

  /// 获取群链接
  static const getGroupLink = 'user/search/full';

  /// 修改群链接有效期
  static const updateGroupLink = 'later/sharelink/group/set';

  /// 修改用户链接有效期
  static const updateUserLink = 'later/sharelink/user/set';

  /// 获取用户链接
  static const getUserLink = 'later/sharelink/user';

  /// 获取公告
  static const getAnnouncement = 'later/announcement';

  /// 公告已读回执
  static const readAnnouncement = 'later/announcement/read';

  /// 所有被封禁群ID
  static const getBlockedGroupIDs = 'later/group/block/ids';

  /// 获取群组封禁信息
  static const getGroupBlockInfo = 'later/group/block';

  /// 获取商户信息
  static const getMchantInfo = "later/info";

  /// 获取TRTC服务的sign
  static const getTRTCSign = "later/user/trtc/sign";

  static const getGroupMemberOnlineInfo = 'later/group/online/count';
}
