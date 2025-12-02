import 'dart:async';
import 'package:dio/dio.dart';
import 'package:openim_common/src/api_helper.dart';
import 'package:openim_common/src/old_urls.dart';
import '../openim_common.dart';

///
///
///
///
///
/// ⚠ openIm官方实现，已未使用的接口 ⚠
///
///
///
///
///


class OldApis {
  static StreamController kickoffController = StreamController<int>.broadcast();

  static void kickoff(int? errCode) {
    if (errCode == 1501 ||
        errCode == 1503 ||
        errCode == 1504 ||
        errCode == 1505) {
      kickoffController.sink.add(errCode);
    }
  }

  /// login
  static Future<LoginCertificate> login({
    String? areaCode,
    String? phoneNumber,
    String? email,
    String? password,
    String? verificationCode,
    String? baseURL,
  }) async {
    try {
      var data = await HttpUtil.post(
          baseURL != null ? '$baseURL/${OldUrls.login}' : OldUrls.login,
          data: {
            "areaCode": areaCode,
            'phoneNumber': phoneNumber,
            'email': email,
            'password': null != password ? IMUtils.generateMD5(password) : null,
            'platform': IMUtils.getPlatform(),
            'verifyCode': verificationCode,
          });
      final cert = LoginCertificate.fromJson(data!);

      return cert;
    } catch (e, _) {
      final t = e as (int, String?);
      final errCode = t.$1;
      final errMsg = t.$2;
      kickoff(errCode);
      Logger.print('e:$errCode s:$errMsg');
      return Future.error(e);
    }
  }

  /// register
  static Future<LoginCertificate> register(
      {required String nickname,
      required String password,
      String? faceURL,
      String? areaCode,
      String? phoneNumber,
      String? email,
      int birth = 0,
      int gender = 1,
      required String verificationCode,
      String? invitationCode,
      bool autoLogin = true,
      String? baseURL}) async {
    try {
      var data = await HttpUtil.post(
        baseURL != null ? '$baseURL/${OldUrls.register}' : OldUrls.register,
        data: {
          'deviceID': DataSp.getDeviceID(),
          'verifyCode': verificationCode,
          'platform': IMUtils.getPlatform(),
          // 'operationID': operationID,
          'invitationCode': invitationCode,
          'autoLogin': autoLogin,
          'user': {
            "nickname": nickname,
            "faceURL": faceURL,
            'birth': birth,
            'gender': gender,
            'email': email,
            "areaCode": areaCode,
            'phoneNumber': phoneNumber,
            'password': IMUtils.generateMD5(password),
          },
        },
      ).catchApiErrorCode();
      final cert = LoginCertificate.fromJson(data!);
      return cert;
    } catch (e) {
      if (e is int) {
        kickoff(e);
      }
      return Future.error(e);
    }
  }

  /// reset password
  static Future<dynamic> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
    required String verificationCode,
  }) async {
    try {
      return HttpUtil.post(
        OldUrls.resetPwd,
        data: {
          "areaCode": areaCode,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': IMUtils.generateMD5(password),
          'verifyCode': verificationCode,
          'platform': IMUtils.getPlatform(),
          // 'operationID': operationID,
        },
      ).catchApiErrorCode();
    } catch (e) {
      if (e is int) {
        kickoff(e);
      }
    }
  }

  /// change password
  static Future<bool> changePassword({
    required String userID,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await HttpUtil.post(
        OldUrls.changePwd,
        data: {
          "userID": userID,
          'currentPassword': IMUtils.generateMD5(currentPassword),
          'newPassword': IMUtils.generateMD5(newPassword),
          'platform': IMUtils.getPlatform(),
          // 'operationID': operationID,
        },
      ).catchApiErrorCode();
      return true;
    } catch (e) {
      if (e is int) {
        kickoff(e);
      }
      return false;
    }
  }

  /// change password to b
  static Future<bool> changePasswordOfB({
    required String newPassword,
  }) async {
    try {
      await HttpUtil.post(
        OldUrls.resetPwd,
        data: {
          'password': IMUtils.generateMD5(newPassword),
          'platform': IMUtils.getPlatform(),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取验证码
  /// [usedFor] 1：注册，2：重置密码 3：登录
  static Future<bool> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    return HttpUtil.post(
      OldUrls.getVerificationCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
        // 'operationID': operationID,
        'usedFor': usedFor,
        'invitationCode': invitationCode
      },
    ).then((value) {
      IMViews.showToast(StrRes.sentSuccessfully);
      return true;
    }).catchError((e, s) {
      Logger.print('e:$e s:$s');
      return false;
    });
  }

  /// 校验验证码
  static Future<dynamic> checkVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verificationCode,
    required int usedFor,
    String? invitationCode,
  }) {
    return HttpUtil.post(
      OldUrls.checkVerificationCode,
      data: {
        "phoneNumber": phoneNumber,
        "areaCode": areaCode,
        "email": email,
        "verifyCode": verificationCode,
        "usedFor": usedFor,
        // 'operationID': operationID,
        'invitationCode': invitationCode
      },
    );
  }

  /// 蒲公英更新检测
  static Future<UpgradeInfoV2> checkUpgradeV2() {
    return dio.post<Map<String, dynamic>>(
      'https://www.pgyer.com/apiv2/app/check',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
      data: {
        '_api_key': '6f43600074306e8bc506ed0cd3275e9e',
        'appKey': 'fd9c183a4b198a1679dac0d5f66def87',
      },
    ).then((resp) {
      Map<String, dynamic> map = resp.data!;
      if (map['code'] == 0) {
        return UpgradeInfoV2.fromJson(map['data']);
      }
      return Future.error(map);
    });
  }


}
