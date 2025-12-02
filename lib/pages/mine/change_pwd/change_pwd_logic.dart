import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/push_controller.dart';
import '../../../routes/app_navigator.dart';
import '../../../core/controller/trtc_controller.dart';

class ChangePwdLogic extends GetxController {
  final pushLogic = Get.find<PushController>();
  final trtcLogic = Get.find<TRTCController>();
  final oldPwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  final againPwdCtrl = TextEditingController();

  final oldPwdObscure = true.obs;
  final newPwdObscure = true.obs;
  final againPwdObscure = true.obs;

  void toggleOldPwdVisibility() => oldPwdObscure.value = !oldPwdObscure.value;
  void toggleNewPwdVisibility() => newPwdObscure.value = !newPwdObscure.value;
  void toggleAgainPwdVisibility() =>
      againPwdObscure.value = !againPwdObscure.value;

  @override
  void onClose() {
    oldPwdCtrl.dispose();
    newPwdCtrl.dispose();
    againPwdCtrl.dispose();
    super.onClose();
  }

  void confirm() async {
    if (oldPwdCtrl.text.isEmpty) {
      IMViews.showToast(StrRes.plsEnterOldPwd);
      return;
    }
    if (!IMUtils.isValidPassword(newPwdCtrl.text)) {
      IMViews.showToast(StrRes.wrongPasswordFormat);
      return;
    }
    if (newPwdCtrl.text.isEmpty) {
      IMViews.showToast(StrRes.plsEnterNewPwd);
      return;
    }
    if (againPwdCtrl.text.isEmpty) {
      IMViews.showToast(StrRes.plsEnterConfirmPwd);
      return;
    }
    if (newPwdCtrl.text != againPwdCtrl.text) {
      IMViews.showToast(StrRes.twicePwdNoSame);
      return;
    }

    final result = await LoadingView.singleton.wrap(
      asyncFunction: () => GatewayApi.changePassword(
        newPassword: newPwdCtrl.text,
        currentPassword: oldPwdCtrl.text,
      ),
    );
    if (result) {
      IMViews.showToast(StrRes.changedSuccessfully);
      await LoadingView.singleton.wrap(asyncFunction: () async {
        await OpenIM.iMManager.logout();
        await DataSp.removeLoginCertificate();
        pushLogic.logout();
        trtcLogic.logout();
      });
      AppNavigator.startInviteCode();
    }
  }
}
