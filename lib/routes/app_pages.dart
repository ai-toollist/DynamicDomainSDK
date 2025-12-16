import 'package:get/get.dart';
import 'package:openim/pages/auth/invite_code_binding.dart';
import 'package:openim/pages/auth/invite_code_view.dart';
import 'package:openim/pages/chat/group_online_info/group_online_info_binding.dart';
import 'package:openim/pages/chat/group_online_info/group_online_info_view.dart';
import 'package:openim/pages/contacts/contacts_binding.dart';
import 'package:openim/pages/contacts/contacts_view.dart';

import 'package:openim/pages/merchantList/merchant_list_binding.dart';
import 'package:openim/pages/merchantList/merchant_list_view.dart';
import 'package:openim/pages/merchant_search/merchant_search_binding.dart';
import 'package:openim/pages/merchant_search/merchant_search_view.dart';
import 'package:openim/pages/mine/privacy_policy/privacy_policy_view.dart';
import 'package:openim/pages/mine/real_name_auth/real_name_auth_binding.dart';
import 'package:openim/pages/mine/real_name_auth/real_name_auth_view.dart';
import 'package:openim/pages/reset_password/reset_password_binding.dart';
import 'package:openim/pages/reset_password/reset_password_view.dart';
import '../pages/appeal/appeal_binding.dart';
import '../pages/appeal/appeal_view.dart';
import '../pages/chat/chat_binding.dart';
import '../pages/chat/chat_setup/chat_setup_binding.dart';
import '../pages/chat/chat_setup/chat_setup_view.dart';
import '../pages/chat/chat_setup/search_chat_history/file/file_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/file/file_view.dart';
import '../pages/chat/chat_setup/search_chat_history/multimedia/multimedia_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/multimedia/multimedia_view.dart';
import '../pages/chat/chat_setup/search_chat_history/preview_chat_history/preview_chat_history_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/preview_chat_history/preview_chat_history_view.dart';
import '../pages/chat/chat_setup/search_chat_history/search_chat_history_binding.dart';
import '../pages/chat/chat_setup/search_chat_history/search_chat_history_view.dart';
import '../pages/chat/chat_view.dart';
import '../pages/chat/group_setup/edit_announcement/edit_announcement_binding.dart';
import '../pages/chat/group_setup/edit_announcement/edit_announcement_view.dart';
import '../pages/chat/group_setup/group_manage/group_manage_binding.dart';
import '../pages/chat/group_setup/group_manage/group_manage_view.dart';
import '../pages/chat/group_setup/group_member_list/group_member_list_binding.dart';
import '../pages/chat/group_setup/group_member_list/group_member_list_view.dart';
import '../pages/chat/group_setup/group_member_list/search_group_member/search_group_member_binding.dart';
import '../pages/chat/group_setup/group_member_list/search_group_member/search_group_member_view.dart';
import '../pages/chat/group_setup/group_setup_binding.dart';
import '../pages/chat/group_setup/group_setup_view.dart';
import '../pages/chat/group_setup/set_mute_for_memeber/set_mute_for_member_binding.dart';
import '../pages/chat/group_setup/set_mute_for_memeber/set_mute_for_member_view.dart';
import '../pages/contacts/add_by_search/add_by_search_binding.dart';
import '../pages/contacts/add_by_search/add_by_search_view.dart';
import '../pages/contacts/add_method/add_method_binding.dart';
import '../pages/contacts/add_method/add_method_view.dart';
import '../pages/contacts/create_group/create_group_binding.dart';
import '../pages/contacts/create_group/create_group_view.dart';
import '../pages/contacts/friend_requests/friend_requests_binding.dart';
import '../pages/contacts/friend_requests/friend_requests_view.dart';
import '../pages/contacts/friend_requests/process_friend_requests/process_friend_requests_binding.dart';
import '../pages/contacts/friend_requests/process_friend_requests/process_friend_requests_view.dart';
import '../pages/contacts/group_requests/group_requests_binding.dart';
import '../pages/contacts/group_requests/group_requests_view.dart';
import '../pages/contacts/group_requests/process_group_requests/process_group_requests_binding.dart';
import '../pages/contacts/group_requests/process_group_requests/process_group_requests_view.dart';
import '../pages/contacts/search_group/search_group_binding.dart';
import '../pages/contacts/search_group/search_group_view.dart';
import '../pages/contacts/select_contacts/friend_list/friend_list_binding.dart';
import '../pages/contacts/select_contacts/friend_list/friend_list_view.dart';
import '../pages/contacts/select_contacts/friend_list/search_friend/search_friend_binding.dart';
import '../pages/contacts/select_contacts/friend_list/search_friend/search_friend_view.dart';
import '../pages/contacts/select_contacts/group_list/group_list_binding.dart';
import '../pages/contacts/select_contacts/group_list/group_list_view.dart';
import '../pages/contacts/select_contacts/group_list/search_group/search_group_binding.dart';
import '../pages/contacts/select_contacts/group_list/search_group/search_group_view.dart';
import '../pages/contacts/select_contacts/search_contacts/search_contacts_binding.dart';
import '../pages/contacts/select_contacts/search_contacts/search_contacts_view.dart';
import '../pages/contacts/select_contacts/select_contacts_binding.dart';
import '../pages/contacts/select_contacts/select_contacts_view.dart';
import '../pages/contacts/send_verification_application/send_verification_application_binding.dart';
import '../pages/contacts/send_verification_application/send_verification_application_view.dart';
import '../pages/contacts/user_profile_panel/friend_setup/friend_setup_binding.dart';
import '../pages/contacts/user_profile_panel/friend_setup/friend_setup_view.dart';
import '../pages/contacts/user_profile_panel/personal_info/personal_info_binding.dart';
import '../pages/contacts/user_profile_panel/personal_info/personal_info_view.dart';
import '../pages/contacts/user_profile_panel/set_remark/set_remark_binding.dart';
import '../pages/contacts/user_profile_panel/set_remark/set_remark_view.dart';
import '../pages/contacts/user_profile_panel/user_profile _panel_binding.dart';
import '../pages/contacts/user_profile_panel/user_profile _panel_view.dart';

import '../pages/gateway_switcher/gateway_switcher_view.dart';
import '../pages/global_search/expand_chat_history/expand_chat_history_binding.dart';
import '../pages/global_search/expand_chat_history/expand_chat_history_view.dart';
import '../pages/global_search/global_search_binding.dart';
import '../pages/global_search/global_search_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/chat_analytics/chat_analytics_binding.dart';
import '../pages/chat_analytics/chat_analytics_view.dart';
import '../pages/auth/auth_binding.dart';
import '../pages/auth/auth_view.dart';
import '../pages/mine/about_us/about_us_binding.dart';
import '../pages/mine/about_us/about_us_view.dart';
import '../pages/mine/account_setup/account_setup_binding.dart';
import '../pages/mine/account_setup/account_setup_view.dart';
import '../pages/mine/blacklist/blacklist_binding.dart';
import '../pages/mine/blacklist/blacklist_view.dart';
import '../pages/mine/change_pwd/change_pwd_binding.dart';
import '../pages/mine/change_pwd/change_pwd_view.dart';
import '../pages/contact_us/contact_us_view.dart';
import '../pages/mine/edit_my_info/edit_my_info_binding.dart';
import '../pages/mine/edit_my_info/edit_my_info_view.dart';
import '../pages/mine/language_setup/language_setup_binding.dart';
import '../pages/mine/language_setup/language_setup_view.dart';
import '../pages/mine/my_info/my_info_binding.dart';
import '../pages/mine/my_info/my_info_view.dart';
import '../pages/mine/my_qrcode/my_qrcode_binding.dart';
import '../pages/mine/my_qrcode/my_qrcode_view.dart';
import '../pages/mine/service_agreement/service_agreement_view.dart';
import '../pages/mine/unlock_setup/unlock_setup_binding.dart';
import '../pages/mine/unlock_setup/unlock_setup_view.dart';

import '../pages/report_reason_list/report_reason_list_binding.dart';
import '../pages/report_reason_list/report_reason_list_view.dart';
import '../pages/report_submit/report_submit_binding.dart';
import '../pages/report_submit/report_submit_view.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/splash/splash_view.dart';
import '../pages/contacts/group_profile_panel/group_profile_panel_binding.dart';
import '../pages/contacts/group_profile_panel/group_profile_panel_view.dart';

part 'app_routes.dart';

class AppPages {
  /// 左滑关闭页面用于android
  static _pageBuilder({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    bool preventDuplicates = true,
    bool popGesture = true,
    Map<String, String>? parameters,
    Transition transition = Transition.cupertino,
  }) =>
      GetPage(
        name: name,
        page: () {
          print('页面跳转到: $name');
          return page();
        },
        binding: binding,
        preventDuplicates: preventDuplicates,
        transition: transition,
        popGesture: popGesture,
        parameters: parameters,
      );

  static final routes = <GetPage>[
    _pageBuilder(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
      parameters: const {'uri': 'uri'},
    ),
    _pageBuilder(
      name: AppRoutes.inviteCode,
      page: () => InviteCodeView(),
      binding: InviteCodeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.auth,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordPage(),
      binding: ResetPasswordBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.gatewaySwitcher,
      page: () => GatewaySwitcherView(),
    ),
    _pageBuilder(
      name: AppRoutes.merchantList,
      page: () => MerchantListView(),
      binding: MerchantListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.merchantSearch,
      page: () => MerchantSearchPage(),
      binding: MerchantSearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
      preventDuplicates: false,
    ),
    _pageBuilder(
      name: AppRoutes.myQrcode,
      page: () => MyQrcodePage(),
      binding: MyQrcodeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chatSetup,
      page: () => ChatSetupPage(),
      binding: ChatSetupBinding(),
      popGesture: false,
    ),
    // _pageBuilder(
    //   name: AppRoutes.favoriteManage,
    //   page: () => FavoriteManagePage(),
    //   binding: FavoriteManageBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.addContactsMethod,
      page: () => AddContactsMethodPage(),
      binding: AddContactsMethodBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.addContactsBySearch,
      page: () => AddContactsBySearchPage(),
      binding: AddContactsBySearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.userProfilePanel,
      page: () => UserProfilePanelPage(),
      binding: UserProfilePanelBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.personalInfo,
      page: () => PersonalInfoPage(),
      binding: PersonalInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.friendSetup,
      page: () => FriendSetupPage(),
      binding: FriendSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setFriendRemark,
      page: () => const SetFriendRemarkPage(),
      binding: SetFriendRemarkBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.sendVerificationApplication,
      page: () => SendVerificationApplicationPage(),
      binding: SendVerificationApplicationBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupProfilePanel,
      page: () => GroupProfilePanelPage(),
      binding: GroupProfilePanelBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setMuteForGroupMember,
      page: () => SetMuteForGroupMemberPage(),
      binding: SetMuteForGroupMemberBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.myInfo,
      page: () => MyInfoPage(),
      binding: MyInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.editMyInfo,
      page: () => EditMyInfoPage(),
      binding: EditMyInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.accountSetup,
      page: () => AccountSetupPage(),
      binding: AccountSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.blacklist,
      page: () => BlacklistPage(),
      binding: BlacklistBinding(),
    ),
    // Language, Unlock, and Change Password are now bottom sheets in account_setup_logic
    // _pageBuilder(
    //   name: AppRoutes.languageSetup,
    //   page: () => LanguageSetupPage(),
    //   binding: LanguageSetupBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.unlockSetup,
    //   page: () => UnlockSetupPage(),
    //   binding: UnlockSetupBinding(),
    // ),
    // _pageBuilder(
    //   name: AppRoutes.changePassword,
    //   page: () => ChangePwdPage(),
    //   binding: ChangePwdBinding(),
    // ),
    _pageBuilder(
      name: AppRoutes.aboutUs,
      page: () => AboutUsPage(),
      binding: AboutUsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
      binding: AboutUsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.serviceAgreement,
      page: () => const ServiceAgreementPage(),
    ),
    _pageBuilder(
      name: AppRoutes.contactUs,
      page: () => const ContactUsView(),
    ),
    _pageBuilder(
      name: AppRoutes.searchChatHistory,
      page: () => SearchChatHistoryPage(),
      binding: SearchChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchChatHistoryMultimedia,
      page: () => ChatHistoryMultimediaPage(),
      binding: ChatHistoryMultimediaBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchChatHistoryFile,
      page: () => ChatHistoryFilePage(),
      binding: ChatHistoryFileBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.previewChatHistory,
      page: () => PreviewChatHistoryPage(),
      binding: PreviewChatHistoryBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupChatSetup,
      page: () => GroupSetupPage(),
      binding: GroupSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupManage,
      page: () => GroupManagePage(),
      binding: GroupManageBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.editGroupAnnouncement,
      page: () => EditGroupAnnouncementPage(),
      binding: EditGroupAnnouncementBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupMemberList,
      page: () => GroupMemberListPage(),
      binding: GroupMemberListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchGroupMember,
      page: () => SearchGroupMemberPage(),
      binding: SearchGroupMemberBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupOnlineInfo,
      page: () => GroupOnlineInfoPage(),
      binding: GroupOnlineInfoBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.reportReasonList,
      page: () => ReportReasonListPage(),
      binding: ReportReasonListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.reportSubmit,
      page: () => ReportDetailPage(),
      binding: ReportSubmitBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.appeal,
      page: () => AppealPage(),
      binding: AppealBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.friendRequests,
      page: () => FriendRequestsPage(),
      binding: FriendRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.processFriendRequests,
      page: () => ProcessFriendRequestsPage(),
      binding: ProcessFriendRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.groupRequests,
      page: () => GroupRequestsPage(),
      binding: GroupRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.processGroupRequests,
      page: () => ProcessGroupRequestsPage(),
      binding: ProcessGroupRequestsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.searchGroup,
      page: () => SearchGroupPage(),
      binding: SearchGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContacts,
      page: () => SelectContactsPage(),
      binding: SelectContactsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromFriends,
      page: () => SelectContactsFromFriendsPage(),
      binding: SelectContactsFromFriendsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromGroup,
      page: () => SelectContactsFromGroupPage(),
      binding: SelectContactsFromGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromSearchFriends,
      page: () => SelectContactsFromSearchFriendsPage(),
      binding: SelectContactsFromSearchFriendsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromSearchGroup,
      page: () => SelectContactsFromSearchGroupPage(),
      binding: SelectContactsFromSearchGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromSearch,
      page: () => SelectContactsFromSearchPage(),
      binding: SelectContactsFromSearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.createGroup,
      page: () => CreateGroupPage(),
      binding: CreateGroupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.globalSearch,
      page: () => GlobalSearchPage(),
      binding: GlobalSearchBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.expandChatHistory,
      page: () => ExpandChatHistoryPage(),
      binding: ExpandChatHistoryBinding(),
    ),
    _pageBuilder(
        name: AppRoutes.chatAnalytics,
        page: () => ChatAnalyticsView(),
        binding: ChatAnalyticsBinding()),
    _pageBuilder(
        name: AppRoutes.contacts,
        page: () => ContactsPage(),
        binding: ContactsBinding()),
    _pageBuilder(
      name: AppRoutes.realNameAuth,
      page: () => RealNameAuthView(),
      binding: RealNameAuthBinding(),
    ),

    // ...WPages.pages, // 工作圈
    // ...MPages.pages, //
  ];
}
