import 'dart:convert';

import '../res/strings.dart';

class ApiResp {
  int errCode;
  String errMsg;
  String errDlt;
  dynamic data;

  ApiResp.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"] ?? -1,
        errMsg = map["errMsg"] ?? '',
        errDlt = map["errDlt"] ?? '',
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['errDlt'] = errDlt;
    data['data'] = data;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class ApiError {
  static String? getMsg(int errorCode) {
    switch (errorCode) {
      case 10001:
        return StrRes.paramError;
      case 10002:
        return StrRes.dbError;
      case 10003:
        return StrRes.serverResultError;
      case 10006:
        return StrRes.recordNotFoundError;
      case 20001:
        return StrRes.accountRegistered;
      case 20002:
        return StrRes.repeatSendCode;
      case 20003:
        return StrRes.invitationCodeError;
      case 20004:
        return StrRes.registerLimit;
      case 30001:
        return StrRes.verifyCodeError;
      case 30002:
        return StrRes.verifyCodeExpired;
      case 30003:
        return StrRes.invitationCodeUsed;
      case 30004:
        return StrRes.invitationCodeNotFound;
      case 40001:
        return StrRes.accountNotRegistered;
      case 40002:
        return StrRes.passwordError;
      case 40003:
        return StrRes.loginLimit;
      case 40004:
        return StrRes.ipForbidden;
      case 50001:
        return StrRes.expired;
      case 50002:
        return StrRes.formatError;
      case 50003:
        return StrRes.notEffective;
      case 50004:
        return StrRes.unknownError;
      case 50005:
        return StrRes.createError;
      default:
        return null;
    }
  }
}
