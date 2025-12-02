import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/src/api_helper.dart';
import 'package:openim_common/src/chat_urls.dart';
import '../openim_common.dart';

///
///
/// 业务系统接口路径
/// 🏛️ 代表业务系统原有
///
///
class ChatApis {
  /// discoverPageURL
  /// ordinaryUserAddFriend,
  /// bossUserID,
  /// adminURL ,
  /// allowSendMsgNotFriend
  /// needInvitationCodeRegister
  /// robots
  static Future<Map<String, dynamic>> getClientConfig() async {
    // return {'discoverPageURL': Config.discoverPageURL, 'allowSendMsgNotFriend': Config.allowSendMsgNotFriend};
    try {
      var result = await HttpUtil.post(
        ChatURLs.getClientConfig,
        showErrorToast: false,
      ).catchApiErrorCode();
      return result['config'] ?? {};
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return {};
    }
  }

  /// update user info 🏛️
  static Future<dynamic> updateUserInfo({
    required String userID,
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? email,
    String? nickname,
    String? faceURL,
    int? gender,
    int? birth,
    int? level,
    int? allowAddFriend,
    int? allowBeep,
    int? allowVibration,
  }) async {
    try {
      Map<String, dynamic> param = {'userID': userID};
      void put(String key, dynamic value) {
        if (null != value) {
          param[key] = value;
        }
      }

      put('account', account);
      put('phoneNumber', phoneNumber);
      put('areaCode', areaCode);
      put('email', email);
      put('nickname', nickname);
      put('faceURL', faceURL);
      put('gender', gender);
      put('gender', gender);
      put('level', level);
      put('birth', birth);
      put('allowAddFriend', allowAddFriend);
      put('allowBeep', allowBeep);
      put('allowVibration', allowVibration);

      return HttpUtil.post(
        ChatURLs.updateUserInfo,
        data: {
          ...param,
          'platform': IMUtils.getPlatform(),
          // 'operationID': operationID,
        },
      ).catchApiErrorCode();
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
    }
  }

  /// 搜索好友信息 🏛️
  static Future<List<FriendInfo>> searchFriendInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    try {
      final data = await HttpUtil.post(
        ChatURLs.searchFriendInfo,
        data: {
          'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
          'keyword': keyword,
        },
      ).catchApiErrorCode();
      if (data['users'] is List) {
        return (data['users'] as List)
            .map((e) => FriendInfo.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return [];
    }
  }

  /// 获取用户信息 🏛️
  static Future<List<UserFullInfo>?> getUserFullInfo({
    int pageNumber = 0,
    int showNumber = 10,
    required List<String> userIDList,
  }) async {
    try {
      final data = await HttpUtil.post(
        ChatURLs.getUsersFullInfo,
        data: {
          'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
          'userIDs': userIDList,
          'platform': IMUtils.getPlatform(),
          // 'operationID': operationID,
        },
      ).catchApiErrorCode();
      if (data['users'] is List) {
        return (data['users'] as List)
            .map((e) => UserFullInfo.fromJson(e))
            .toList();
      }
      return null;
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return [];
    }
  }

  /// 获取个人信息 🏛️
  static Future<UserFullInfo?> queryMyFullInfo() async {
    final list = await ChatApis.getUserFullInfo(
      userIDList: [OpenIM.iMManager.userID],
    );
    return list?.firstOrNull;
  }

  /// 搜索用户信息 🏛️
  static Future<List<UserFullInfo>?> searchUserFullInfo({
    required String content,
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    try {
      final data = await HttpUtil.post(
        ChatURLs.searchUserFullInfo,
        data: {
          'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
          'keyword': content,
          // 'operationID': operationID,
        },
      ).catchApiErrorCode();
      if (data['users'] is List) {
        return (data['users'] as List)
            .map((e) => UserFullInfo.fromJson(e))
            .toList();
      }
      return null;
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return [];
    }
  }

  /// 获取群链接
  static Future<String> getGroupLink(String groupID) async {
    try {
      var data = await HttpUtil.post(
        ChatURLs.getGroupLink,
        data: {
          'groupId': groupID,
        },
      ).catchApiErrorCode();
      return data['link'] ?? '';
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return '';
    }
  }

  /// 修改群链接有效期
  static Future<bool> updateGroupLink(String groupID, int cycle) async {
    try {
      await HttpUtil.post(
        ChatURLs.updateGroupLink,
        data: {
          'groupId': groupID,
          'cycle': cycle,
        },
      ).catchApiErrorCode();
      return true;
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return false;
    }
  }

  /// 修改用户链接有效期
  static Future<bool> updateUserLink(String userID, int cycle) async {
    try {
      await HttpUtil.post(
        ChatURLs.updateUserLink,
        data: {
          'userId': userID,
          'cycle': cycle,
        },
      ).catchApiErrorCode();
      return true;
    } catch (e) {
      if (e is int) {
        Apis.kickoff(e);
      }
      return false;
    }
  }

  /// 获取用户链接
  static Future<String> getUserLink(String userID) async {
    try {
      final resp = await HttpUtil.post(
        ChatURLs.getUserLink,
      );
      return resp['link'] ?? '';
    } catch (e, s) {
      Logger.print('e:$e s:$s');
      return '';
    }
  }

  /// 获取公告
  static Future<Map<String, List<Announcement>>> getAnnouncement() async {
    try {
      final resp = await HttpUtil.post(ChatURLs.getAnnouncement);

      if (resp is Map<String, dynamic>) {
        final popupList = (resp['popup'] as List? ?? [])
            .map((e) => Announcement.fromJson(e))
            .take(2)
            .where((e) => e.isRead == false)
            .toList();

        final systemList = (resp['system'] as List? ?? [])
            .map((e) => Announcement.fromJson(e))
            .take(2)
            .where((e) => e.isRead == false)
            .toList();

        return {
          'popupAnnouncements': popupList,
          'systemAnnouncements': systemList,
        };
      } else {
        return {
          'popupAnnouncements': [],
          'systemAnnouncements': [],
        };
      }
    } catch (e, s) {
      Logger.print('e:$e s:$s');
      rethrow;
    }
  }

  /// 公告已读回执
  static Future<bool> readAnnouncement(int id) async {
    try {
      final resp =
          await HttpUtil.post(ChatURLs.readAnnouncement, data: {"id": id});
      return resp;
    } catch (e, s) {
      Logger.print('e:$e s:$s');
      rethrow;
    }
  }

  /// 举报
  static Future report(
      {required String type,
      required String contentType,
      required String content,
      List<String>? images,
      String? reportedGroupID,
      String? reportedUserID}) async {
    var result = await HttpUtil.post(
      ChatURLs.report,
      data: {
        'type': type,
        'contentType': contentType,
        'content': content,
        'images': images,
        'reportedGroupID': reportedGroupID,
        'reportedUserID': reportedUserID,
      },
    );
    return result;
  }

  /// 申诉
  static Future appeal({
    required String imUserId,
    required String reason,
    required String chatAddr,
    List<String>? evidence,
  }) async {
    var result = await HttpUtil.post(
      '$chatAddr/${ChatURLs.appeal}',
      data: {
        'imUserId': imUserId,
        'reason': reason,
        'evidence': evidence,
      },
    );
    return result;
  }

  /// 所有被封禁群ID
  static Future<List<String>> getBlockedGroupIDs() async {
    final result = await HttpUtil.post(
      ChatURLs.getBlockedGroupIDs,
      showErrorToast: false,
    ).catchApiError();
    return List<String>.from(result);
  }

  /// 所有被封禁群ID
  static Future getGroupBlockInfo(String groupID) async {
    try {
      final result = await HttpUtil.post(
        ChatURLs.getGroupBlockInfo,
        data: {
          'groupIds': [groupID],
        },
        showErrorToast: false,
      ).catchApiError();
      return result;
    } catch (e) {
      return [];
    }
  }

  /// trtc sign
  static Future<TRTCSign> getTRTCSign() async {
    try {
      final result = await HttpUtil.post(
        ChatURLs.getTRTCSign,
        data: {"platformId": 1},
        showErrorToast: false,
      ).catchApiError();
      return TRTCSign.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  static Future<GroupOnlineInfo> getGroupMemberOnlineInfo(
      {required List<String> groupIDS}) async {
    var result = await HttpUtil.post(
      ChatURLs.getGroupMemberOnlineInfo,
      data: {'groupIds': groupIDS},
      baseURLType: BaseURLType.chatAddr,
      showErrorToast: false,
    );
    GroupOnlineInfo groupOnlineInfo = GroupOnlineInfo.fromJson(result[0]);
    return groupOnlineInfo;
  }
}
