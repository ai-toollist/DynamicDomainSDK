///
///
/// 网关接口路径
///
///
class GatewayUrls {
  /// 注册
  /// register_im 不需要邀请码
  /// register_v3
  /// register_v4
  static const register = 'register_v4';

  /// 登录
  /// login
  /// login_v3
  /// login_v4
  static const login = 'login_v4';

  /// 登录IM
  /// login_im
  /// login_im_v3
  static const loginIM = 'login_im';

  /// 商户列表
  static const merchantList = 'user/organization';

  /// 搜索商户
  static const searchMerchant = 'invitationCode';

  static const searchMerchantByID = 'organizationById';

  /// 绑定商户
  static const bindMerchant = 'bind_im';

  /// 发送短信验证码
  static const sendSMSCode = 'sms_code';

  /// 发送短信验证码(带返回值)
  static const sendSMSCodeV2 = 'sms_code_v2';

  /// 图形验证码ID
  static const getCaptchaID = 'image_code_id';

  /// 图形验证码
  static const getCaptcha = 'image_code';

  /// 更改密码
  static const changePassword = 'password_change';

  /// 重置密码
  static const resetPassword = 'password_reset';

  /// 获取最新版本信息
  static const latestVersion = 'version_latest';

  /// 商户认证信息
  static const authInfo = 'organization/item';

  /// 网关配置
  static const gatewayConfig = 'config';

  /// 网关配置(所有)
  static const gatewayConfigAll = 'config_all';

  /// 上报不可用域名
  static const reportUnavailableDomains = 'api_url_lose';

  /// 提交实名认证申请
  static const submitRealNameAuth = 'user/identity_submit';

  /// 查询实名认证信息
  static const getRealNameAuthInfo = 'user/identity_info';

  /// 上传文件
  static const uploadFile = 'upload/file';

  static const geminiAPIBaseURL =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyAuCrnDr7pOkMGX0JXkn6rjt_t3PpkPnsQ';

  /// 检查邀请码是否可用
  static const checkInvitationCode = 'invite_code/verify';
}
