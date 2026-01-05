// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/pages/auth/widget/app_text_button.dart';
import 'package:openim/pages/auth/widget/invite_code_field.dart';
import 'package:openim_common/openim_common.dart';

import 'invite_code_logic.dart';

class InviteCodeView extends StatelessWidget {
  InviteCodeView({super.key});

  final logic = Get.find<InviteCodeLogic>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PopScope(
      canPop: false,
      child: TouchCloseSoftKeyboard(
        child: Scaffold(
          body: Stack(
            children: [
              Obx(
                () => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: logic.gradientOpacity.value),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -1.0),
                          radius: 1.8,
                          colors: [
                            primaryColor.withOpacity(value * 0.9),
                            const Color(0xFFB3D4F5).withOpacity(value * 0.5),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LOGO
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Image.asset(
                            "assets/images/app-icon.png",
                            width: 74.w,
                          ),
                        ),
                      ),

                      30.verticalSpace,

                      // 标题
                      Text(
                        StrRes.welcome,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'FilsonPro',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // 副标题
                      Text(
                        StrRes.pleaseEnterEnterpriseCodeToContinue,
                        style: TextStyle(
                          fontFamily: 'FilsonPro',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),

                      // 输入框
                      Form(
                        key: logic.formKey,
                        child: InviteCodeField(
                          controller: logic.inviteCodeController,
                          focusNode: logic.inviteCodeFocusNode,
                          required: logic.enableInviteCodeRequired,
                          isRequired: true,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Obx(
                        () => Align(
                            alignment: Alignment.center,
                            child: AppTextButton(
                              buttonText: StrRes.enter,
                              buttonWidth: 100.w,
                              backgroundColor: logic.isButtonEnabled.value
                                  ? primaryColor
                                  : const Color(0xFF9CA3AF),
                              textStyle: TextStyle(
                                fontFamily: 'FilsonPro',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              onPressed: logic.onSubmit,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              // Language Switcher Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 16,
                child: OverlayPopupMenuButton(
                  child: Obx(() => Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9CA3AF).withOpacity(0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 12.r,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: logic.currentFlagImage,
                        ),
                      )),
                  builder: (controller) => Container(
                    width: 185.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLanguageItem(
                              Icon(Icons.public,
                                  size: 24.w, color: Colors.black87),
                              StrRes.followSystem,
                              logic.languageIndex.value == 0,
                              () {
                                logic.changeLanguage(0);
                                controller?.reverse();
                              },
                            ),
                            Divider(height: 1, color: Colors.grey.shade200),
                            _buildLanguageItem(
                              ImageRes.englandFlag.toImage,
                              StrRes.english,
                              logic.languageIndex.value == 2,
                              () {
                                logic.changeLanguage(2);
                                controller?.reverse();
                              },
                            ),
                            Divider(height: 1, color: Colors.grey.shade200),
                            _buildLanguageItem(
                              ImageRes.chinaFlag.toImage,
                              StrRes.chinese,
                              logic.languageIndex.value == 1,
                              () {
                                logic.changeLanguage(1);
                                controller?.reverse();
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    Widget flagImage,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: flagImage,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 18.w,
                color: Theme.of(Get.context!).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final Color backgroundColor;

  const AnimatedButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.backgroundColor,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (d) {
        _onTapUp(d);
        widget.onTap();
      },
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
