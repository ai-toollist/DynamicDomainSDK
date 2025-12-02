import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:openim/pages/auth/auth_logic.dart';
import 'package:openim/pages/auth/widget/forget_password_text_button.dart';
import 'package:openim/pages/auth/widget/app_text_button.dart';
import 'package:openim/pages/auth/widget/password_field.dart';
import 'package:openim/pages/auth/widget/phone_field.dart';
import 'package:openim/pages/auth/widget/phone_code_field.dart';
import 'package:openim/pages/auth/widget/nickname_field.dart';
import 'package:openim/pages/auth/widget/invite_code_field.dart';
import 'package:openim/pages/auth/widget/terms_and_conditions_text.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim/widgets/custom_buttom.dart';
import 'package:openim_common/openim_common.dart';

class AuthView extends StatelessWidget {
  AuthView({super.key});

  final logic = Get.find<AuthLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      isGradientBg: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAFAFA),
          leading: CustomButtom(
            margin: const EdgeInsets.all(5),
            onPressed: () => Get.back(),
            icon: Icons.arrow_back_ios_new,
            colorButton: Colors.white.withOpacity(0.3),
            colorIcon: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: AnimationLimiter(
            child: Column(
              children: [
                // Header với logo
                _buildHeader(),
                // Padding(
                //   padding: EdgeInsetsGeometry.symmetric(horizontal: 50.w),
                //   child: Divider(
                //     thickness: 0.1,
                //   ),
                // ),

                // Content với TabBar
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 30,
        child: FadeInAnimation(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: logic.toggleVersionInfoShow,
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/images/app-icon.png",
                        width: 50.w,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.h),
              GestureDetector(
                onTap: logic.requestDomainReveal,
                child: Text(
                  StrRes.loginTitle,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 40,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                // TabBar theo style ContactsPage
                TabBar(
                  controller: logic.tabController,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Color(0xFF9E9E9E),
                      width: 2.0,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  indicatorPadding: EdgeInsets.all(2.w),
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  labelColor: const Color(0xFF374151),
                  unselectedLabelColor: const Color(0xFF9CA3AF),
                  labelStyle: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: StrRes.login),
                    Tab(text: StrRes.register),
                  ],
                ),

                // TabBarView
                Expanded(
                  child: TabBarView(
                    controller: logic.tabController,
                    children: [
                      _buildLoginTab(),
                      _buildRegisterTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Login Form Container - MinePage style
          Form(
            key: logic.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel(StrRes.phoneNumber),
                Gap(8.h),
                PhoneField(
                  focusNode: logic.loginPhoneFocusNode,
                  controller: logic.loginPhoneController,
                ),
                Gap(20.h),
                _buildFieldLabel(StrRes.passwordLabel),
                Gap(8.h),
                PasswordField(
                  focusNode: logic.loginPasswordFocusNode,
                  controller: logic.loginPasswordController,
                ),
                Obx(
                  () => ForgetPasswordTextButton(
                    remember: logic.rememberPassword.value,
                    onRememberChanged: (bool value) {
                      logic.rememberPassword.value = value;
                    },
                  ),
                ), // Terms                 //Gap(18.h),
                // Terms Container - MinePage style
                TermsAndConditionsText(
                  content: Obx(
                    () => Checkbox(
                      value: logic.isLoginAgree.value,
                      onChanged: (bool? value) {
                        logic.isLoginAgree.value = !logic.isLoginAgree.value;
                      },
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Color(0xFF60A5FA);
                          }
                          return Colors.transparent;
                        },
                      ),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),

                Gap(18.h),
                Align(
                  alignment: Alignment.center,
                  child: Obx(() => AppTextButton(
                        buttonText: StrRes.login,
                        buttonWidth: 100.w,
                        backgroundColor: logic.isLoginFormValid.value
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFF9CA3AF),
                        textStyle: TextStyle(
                          fontFamily: 'FilsonPro',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          logic.loginPasswordFocusNode.unfocus();
                          if (logic.isLoginFormValid.value &&
                              logic.loginFormKey.currentState!.validate()) {
                            logic.onLoginSubmit();
                          }
                        },
                      )),
                )
              ],
            ),
          ),

          // Version info
          _buildVersionInfo(),
        ],
      ),
    );
  }

  Widget _buildRegisterTab() {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Register Form Container - MinePage style
          Form(
            key: logic.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel(StrRes.nickname),
                Gap(8.h),
                NicknameField(
                  controller: logic.registerNameController,
                  focusNode: logic.registerNameFocusNode,
                ),
                Gap(20.h),
                _buildFieldLabel(StrRes.phoneNumber),
                Gap(8.h),
                PhoneField(
                  focusNode: logic.registerPhoneFocusNode,
                  controller: logic.registerPhoneController,
                ),
                Gap(20.h),
                _buildFieldLabel(StrRes.password),
                Gap(8.h),
                PasswordField(
                  focusNode: logic.registerPasswordFocusNode,
                  controller: logic.registerPasswordController,
                  validateFormat: true,
                ),
                Gap(20.h),
                _buildFieldLabel(StrRes.confirmPassword),
                Gap(8.h),
                PasswordField(
                  focusNode: logic.registerPasswordConfirmationFocusNode,
                  controller: logic.registerPasswordConfirmationController,
                  compareController: logic.registerPasswordController,
                ),
                Gap(20.h),
                _buildFieldLabel(StrRes.verificationCode),
                Gap(8.h),
                PhoneCodeField(
                  controller: logic.registerVerificationCodeController,
                  onSendCode: logic.onSendVerificationCode,
                ),
                Gap(10.h),
                TermsAndConditionsText(
                  content: Obx(
                    () => Checkbox(
                      value: logic.isRegisterAgree.value,
                      onChanged: (bool? value) {
                        logic.isRegisterAgree.value =
                            !logic.isRegisterAgree.value;
                      },
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Color(0xFF60A5FA);
                          }
                          return Colors.transparent;
                        },
                      ),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Obx(() => AppTextButton(
                        buttonWidth: 200.w,
                        buttonText: StrRes.createAccount,
                        backgroundColor: logic.isRegisterFormValid.value
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF9CA3AF),
                        textStyle: TextStyle(
                          fontFamily: 'FilsonPro',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          logic.registerPasswordFocusNode.unfocus();
                          logic.registerPasswordConfirmationFocusNode.unfocus();
                          if (logic.isRegisterFormValid.value &&
                              logic.registerFormKey.currentState!.validate()) {
                            logic.onRegisterSubmit();
                          }
                        },
                      )),
                )
              ],
            ),
          ),

          Gap(18.h),
          // Domain info
          _buildDomainInfo(),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool required = true}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'FilsonPro',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        if (required)
          Text(
            ' *',
            style: TextStyle(
              fontFamily: 'FilsonPro',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFEF4444),
            ),
          ),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        Gap(24.h),
        Obx(
          () => Visibility(
            visible: logic.versionInfoShow.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9CA3AF).withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(
                    logic.versionInfo.value,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(8.h),
                  GestureDetector(
                    onTap: () {
                      AppNavigator.startGatewaySwitcher();
                    },
                    child: Text(
                      logic.currentDomainDisplayText,
                      style: TextStyle(
                        fontFamily: 'FilsonPro',
                        fontSize: 14.sp,
                        color: const Color(0xFF60A5FA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDomainInfo() {
    return Column(
      children: [
        Gap(24.h),
        Obx(
          () => Visibility(
            visible: logic.isShowGatewayDomain.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9CA3AF).withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: () {
                  AppNavigator.startGatewaySwitcher();
                },
                child: Text(
                  logic.currentDomainDisplayText,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 14.sp,
                    color: const Color(0xFF60A5FA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
