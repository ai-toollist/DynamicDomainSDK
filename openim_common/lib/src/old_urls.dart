class OldUrls {
  static const onlineStatus = "manager/get_users_online_status";
  static const queryAllUsers = "manager/get_all_users_uid";

  static const getVerificationCode = "account/code/send";
  static const checkVerificationCode = "account/code/verify";

  static const register = "account/register";
  static const resetPwd = "account/password/reset";
  static const changePwd = "account/password/change";
  static const login = "account/login";

  static const upgrade = "app/check";

  /// office
  static const tag = "office/tag";
  static const getUserTags = "$tag/find/user";
  static const createTag = "$tag/add";
  static const deleteTag = "$tag/del";
  static const updateTag = "$tag/set";
  static const sendTagNotification = "$tag/send";
  static const getTagNotificationLog = "$tag/send/log";
  static const delTagNotificationLog = "$tag/send/log/del";

  /// 小程序
  static const uniMPUrl = 'applet/list';
}
