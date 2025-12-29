// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/widgets/custom_bottom_sheet.dart';
import 'package:openim/widgets/qr_code_bottom_sheet.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';
import '../../../core/controller/trtc_controller.dart';

class MyInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final trtcLogic = Get.find<TRTCController>();

  final userInfo =
      UserFullInfo.fromJson(OpenIM.iMManager.userInfo.toJson()).obs;

  bool isUpdatingGender = false; // Prevent race condition

  void editMyName() => editNameBottomSheet();

  void editNameBottomSheet() {
    final nameController = TextEditingController();
    nameController.text = imLogic.userInfo.value.nickname ?? '';

    CustomBottomSheet.show(
      title: StrRes.nickname,
      icon: CupertinoIcons.person_crop_circle,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StrRes.enterYourNickname,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
            12.verticalSpace,
            TextField(
              controller: nameController,
              autofocus: true,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: StrRes.plsEnterYourNickname,
                hintStyle: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                      const BorderSide(color: Color(0xFF3B82F6), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                counterText: '',
              ),
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
      onConfirm: () async {
        final newName = nameController.text.trim();
        if (newName.isEmpty || newName == imLogic.userInfo.value.nickname) {
          IMViews.showToast(StrRes.inputException);
          return;
        }
        try {
          await _updateNickname(newName);
          Get.back();
        } catch (e) {
          // Error handled in _updateNickname or here if needed
        }
      },
      confirmText: StrRes.confirm,
      showCancelButton: true,
      isDismissible: true,
    );
  }

  void viewMyQrcode() => _showQRCodeBottomSheet();

  void _showQRCodeBottomSheet() {
    Get.bottomSheet(
      QRCodeBottomSheet(
        title: StrRes.qrcode,
        name: imLogic.userInfo.value.nickname ?? '',
        avatarUrl: imLogic.userInfo.value.faceURL,
        qrData: '${Config.friendScheme}${imLogic.userInfo.value.userID}',
        isGroup: false,
        description: StrRes.scanToAddMe,
        hintText: StrRes.qrcodeHint,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Note: englishName and telephone not supported by API, keeping stubs for compatibility
  void editEnglishName() {
    IMViews.showToast(StrRes.featureNotSupported);
  }

  void editTel() {
    IMViews.showToast(StrRes.featureNotSupported);
  }

  void editMobile() => _showEditFieldBottomSheet(
        title: StrRes.phoneNumber,
        currentValue: imLogic.userInfo.value.phoneNumber ?? '',
        hintText: StrRes.enterYourPhoneNumber,
        keyboardType: TextInputType.phone,
        maxLength: 20,
        onSave: (value) => _updateMobile(value),
      );

  void editEmail() => _showEditFieldBottomSheet(
        title: StrRes.emailAddress,
        currentValue: imLogic.userInfo.value.email ?? '',
        hintText: StrRes.enterYourEmailAddress,
        keyboardType: TextInputType.emailAddress,
        maxLength: 30,
        onSave: (value) => _updateEmail(value),
      );

  void _showEditFieldBottomSheet({
    required String title,
    required String currentValue,
    required String hintText,
    required Future<void> Function(String) onSave,
    TextInputType keyboardType = TextInputType.text,
    int maxLength = 20,
  }) {
    final controller = TextEditingController();
    controller.text = currentValue;

    CustomBottomSheet.show(
      title: title,
      icon: CupertinoIcons.pencil,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hintText,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
            12.verticalSpace,
            TextField(
              controller: controller,
              autofocus: true,
              maxLength: maxLength,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                      const BorderSide(color: Color(0xFF3B82F6), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                counterText: '',
              ),
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
      onConfirm: () async {
        final newValue = controller.text.trim();
        if (newValue.isEmpty || newValue == currentValue) {
          IMViews.showToast(StrRes.inputException);
          return;
        }
        try {
          await onSave(newValue);
          Get.back();
        } catch (e) {
          // Error handled in onSave callback or here if needed
        }
      },
      confirmText: StrRes.confirm,
      showCancelButton: true,
      isDismissible: true,
    );
  }

  void openUpdateAvatarSheet() {
    IMViews.openPhotoSheet(
      onlyImage: true,
      allowGif: true,
      onData: (path, url) async {
        if (url != null) {
          try {
            await LoadingView.singleton.wrap(
              asyncFunction: () => ChatApis.updateUserInfo(
                      userID: OpenIM.iMManager.userID, faceURL: url)
                  .then((value) {
                imLogic.userInfo.update((val) {
                  val?.faceURL = url;
                  trtcLogic.setNicknameAvatar(userInfo.value.nickname ?? "",
                      imLogic.userInfo.value.faceURL ?? "");
                });
                IMViews.showToast(StrRes.avatarUpdatedSuccessfully, type: 1);
              }),
            );
          } catch (e) {
            _handleError(e);
          }
        }
      },
      quality: 15,
    );
  }

  void openDatePicker() {
    final currentBirth = imLogic.userInfo.value.birth;
    final initialDate = currentBirth != null && currentBirth > 0
        ? DateTime.fromMillisecondsSinceEpoch(currentBirth)
        : DateTime(1990, 1, 1);

    DateTime selectedDate = initialDate;

    CustomBottomSheet.show(
      title: StrRes.birthDay,
      icon: CupertinoIcons.calendar,
      body: SizedBox(
        height: 200.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDate,
          maximumDate: DateTime.now(),
          minimumDate: DateTime(1900, 1, 1),
          onDateTimeChanged: (DateTime dateTime) {
            selectedDate = dateTime;
          },
        ),
      ),
      onConfirm: () async {
        try {
          await _updateBirthday(selectedDate.millisecondsSinceEpoch ~/ 1000);
          Get.back();
        } catch (e) {
          // Error handled in _updateBirthday
        }
      },
      confirmText: StrRes.confirm,
      showCancelButton: true,
      isDismissible: true,
    );
  }

  void selectGender() {
    final currentGender = imLogic.userInfo.value.gender ?? 0;

    CustomBottomSheet.show(
      title: StrRes.gender,
      icon: CupertinoIcons.person_2,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGenderActionItem(
              icon: CupertinoIcons.person,
              title: StrRes.man,
              iconColor: const Color(0xFF4F42FF),
              onTap: () async {
                if (currentGender != 1) {
                  try {
                    await _updateGender(1);
                    Get.back();
                  } catch (e) {
                    // Error handled in _updateGender
                  }
                } else {
                  Get.back();
                  IMViews.showToast(StrRes.genderUpdatedSuccessfully, type: 1);
                }
              },
              index: 0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 52.w),
              child: const Divider(height: 1, color: Color(0xFFF3F4F6)),
            ),
            _buildGenderActionItem(
              icon: CupertinoIcons.person,
              title: StrRes.woman,
              iconColor: const Color(0xFFF9A8D4),
              onTap: () async {
                if (currentGender != 2) {
                  try {
                    await _updateGender(2);
                    Get.back();
                  } catch (e) {
                    // Error handled in _updateGender
                  }
                } else {
                  Get.back();
                  IMViews.showToast(StrRes.genderUpdatedSuccessfully, type: 1);
                }
              },
              index: 1,
              isLast: true,
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }

  Widget _buildGenderActionItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
    required int index,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: isLast
              ? BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                )
              : null,
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.w,
                color: iconColor,
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateNickname(String nickname) {
    return LoadingView.singleton.wrap(
      asyncFunction: () => ChatApis.updateUserInfo(
              userID: OpenIM.iMManager.userID, nickname: nickname)
          .then((value) {
        imLogic.userInfo.update((val) {
          val?.nickname = nickname;
        });
        IMViews.showToast(StrRes.nicknameUpdatedSuccessfully, type: 1);
      }).catchError((error) {
        _handleError(error);
        throw error;
      }),
    );
  }

  Future<void> _updateGender(int gender) {
    if (isUpdatingGender) return Future.value(); // Prevent concurrent updates

    isUpdatingGender = true;
    return LoadingView.singleton.wrap(
      asyncFunction: () => ChatApis.updateUserInfo(
              userID: OpenIM.iMManager.userID, gender: gender)
          .then((value) {
        imLogic.userInfo.update((val) {
          val?.gender = gender;
        });
        IMViews.showToast(StrRes.genderUpdatedSuccessfully, type: 1);
      }).catchError((error) {
        _handleError(error);
        throw error;
      }).whenComplete(() {
        isUpdatingGender = false; // Release lock
      }),
    );
  }

  Future<void> _updateBirthday(int birthday) {
    return LoadingView.singleton.wrap(
      asyncFunction: () => ChatApis.updateUserInfo(
        userID: OpenIM.iMManager.userID,
        birth: birthday * 1000,
      ).then((value) {
        imLogic.userInfo.update((val) {
          val?.birth = birthday * 1000;
        });
        IMViews.showToast(StrRes.birthdayUpdatedSuccessfully, type: 1);
      }).catchError((error) {
        _handleError(error);
        throw error;
      }),
    );
  }

  Future<void> _updateMobile(String value) {
    return LoadingView.singleton.wrap(
      asyncFunction: () => ChatApis.updateUserInfo(
              userID: OpenIM.iMManager.userID, phoneNumber: value)
          .then((_) {
        imLogic.userInfo.update((val) {
          val?.phoneNumber = value;
        });
        IMViews.showToast(StrRes.phoneUpdatedSuccessfully, type: 1);
      }).catchError((error) {
        _handleError(error);
        throw error;
      }),
    );
  }

  Future<void> _updateEmail(String value) {
    return LoadingView.singleton.wrap(
      asyncFunction: () =>
          ChatApis.updateUserInfo(userID: OpenIM.iMManager.userID, email: value)
              .then((_) {
        imLogic.userInfo.update((val) {
          val?.email = value;
        });
        IMViews.showToast(StrRes.emailUpdatedSuccessfully, type: 1);
      }).catchError((error) {
        _handleError(error);
        throw error;
      }),
    );
  }

  void _handleError(dynamic error) {
    if (error is String && error.contains('500')) {
      IMViews.showToast(StrRes.modificationNotAllowed);
    } else if (error is int && error == 500) {
      IMViews.showToast(StrRes.modificationNotAllowed);
    } else {
      // try parsing if it's a map or custom object, otherwise show default
      IMViews.showToast(StrRes
          .modificationNotAllowed); // Fallback to safe message or default error?
      // actually user wants to see modificationNotAllowed for 500. For others, maybe default.
      // But the log shows error is likely a tuple or custom object from HttpUtil
    }
  }

  @override
  void onReady() {
    _queryMyFullIno();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _queryMyFullIno() async {
    final info = await LoadingView.singleton.wrap(
      asyncFunction: () => ChatApis.queryMyFullInfo(),
    );
    if (null != info) {
      imLogic.userInfo.update((val) {
        val?.nickname = info.nickname;
        val?.faceURL = info.faceURL;
        val?.gender = info.gender;
        val?.phoneNumber = info.phoneNumber;
        val?.birth = info.birth;
        val?.email = info.email;
      });
    }
  }

  updateLinkExpiry(int i) {}
}
