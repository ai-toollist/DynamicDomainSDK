import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';
import '../../../core/controller/trtc_controller.dart';

enum EditAttr {
  nickname,
  englishName,
  telephone,
  mobile,
  email,
}

class EditMyInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  late TextEditingController inputCtrl;
  final trtcLogic = Get.find<TRTCController>();

  late EditAttr editAttr;
  late int maxLength;
  String? title;
  String? defaultValue;
  TextInputType? keyboardType;

  // Reactive character count
  final RxInt characterCount = 0.obs;

  @override
  void onInit() {
    editAttr = Get.arguments['editAttr'];
    maxLength = Get.arguments['maxLength'] ?? 16;
    _initAttr();
    inputCtrl = TextEditingController(text: defaultValue);
    characterCount.value = inputCtrl.text.length;

    // Listen to text changes for character count
    inputCtrl.addListener(() {
      characterCount.value = inputCtrl.text.length;
    });

    super.onInit();
  }

  _initAttr() {
    switch (editAttr) {
      case EditAttr.nickname:
        title = StrRes.nickname;
        defaultValue = imLogic.userInfo.value.nickname;
        keyboardType = TextInputType.text;
        break;
      case EditAttr.englishName:
        // title = StrRes.englishName;
        // defaultValue = imLogic.userInfo.value.englishName;
        // keyboardType = TextInputType.text;
        break;
      case EditAttr.telephone:
        // title = StrRes.tel;
        // defaultValue = imLogic.userInfo.value.telephone;
        // keyboardType = TextInputType.phone;
        break;
      case EditAttr.mobile:
        title = StrRes.mobile;
        defaultValue = imLogic.userInfo.value.phoneNumber;
        keyboardType = TextInputType.phone;
        break;
      case EditAttr.email:
        title = StrRes.email;
        defaultValue = imLogic.userInfo.value.email;
        keyboardType = TextInputType.emailAddress;
        break;
    }
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  void save() async {
    final value = inputCtrl.text.trim();
    try {
      if (editAttr == EditAttr.nickname) {
        await LoadingView.singleton.wrap(
          asyncFunction: () => ChatApis.updateUserInfo(
            userID: OpenIM.iMManager.userID,
            nickname: value,
          ),
        );
        imLogic.userInfo.update((val) {
          val?.nickname = value;
        });
        trtcLogic.setNicknameAvatar(
            value, imLogic.userInfo.value.faceURL ?? "");

        IMViews.showToast(StrRes.nicknameUpdatedSuccessfully,type:1);
      } else if (editAttr == EditAttr.mobile) {
        await LoadingView.singleton.wrap(
          asyncFunction: () => ChatApis.updateUserInfo(
            userID: OpenIM.iMManager.userID,
            phoneNumber: value,
          ),
        );
        imLogic.userInfo.update((val) {
          val?.phoneNumber = value;
        });
        IMViews.showToast(StrRes.phoneUpdatedSuccessfully,type:1);
      } else if (editAttr == EditAttr.email) {
        await LoadingView.singleton.wrap(
          asyncFunction: () => ChatApis.updateUserInfo(
            userID: OpenIM.iMManager.userID,
            email: value,
          ),
        );
        imLogic.userInfo.update((val) {
          val?.email = value;
        });
        IMViews.showToast(StrRes.emailUpdatedSuccessfully,type:1);
      }
      Get.back();
    } catch (e) {
      if (editAttr == EditAttr.nickname) {
        IMViews.showToast(StrRes.nicknameUpdateFailed);
      } else if (editAttr == EditAttr.mobile) {
        IMViews.showToast(StrRes.phoneUpdateFailed);
      } else if (editAttr == EditAttr.email) {
        IMViews.showToast(StrRes.emailUpdateFailed);
      }
    }
  }
}
