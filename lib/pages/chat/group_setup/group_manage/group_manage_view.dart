// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:openim/widgets/section_title.dart';
import 'package:openim/widgets/settings_menu.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim/widgets/gradient_scaffold.dart';

import 'group_manage_logic.dart';

class GroupManagePage extends StatelessWidget {
  final logic = Get.find<GroupManageLogic>();

  GroupManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: StrRes.groupManage,
      subtitle: StrRes.groupSettingsPrivacy,
      showBackButton: true,
      trailing: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.admin_panel_settings_outlined,
          color: Colors.white,
          size: 22.w,
        ),
      ),
      scrollable: true,
      body: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
        child: Container(
          color: const Color(0xFFF9FAFB),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 24.h),
            child: Obx(
              () => AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 30.0,
                      curve: Curves.easeOutCubic,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      20.verticalSpace,

                      // Group Control Section
                      SectionTitle(
                        title: StrRes.groupControl,
                        icon: Icons.volume_off_outlined,
                        color: const Color(0xFFEF4444),
                      ),
                      8.verticalSpace,
                      SettingsMenuSection(
                        items: [
                          SettingsMenuItem(
                            icon: CupertinoIcons.bell_slash,
                            label: StrRes.muteAllMember,
                            hasSwitch: true,
                            switchValue: logic.groupInfo.value.status == 3,
                            onSwitchChanged: (_) => logic.toggleGroupMute(),
                            showDivider: false,
                            isRow: true,
                          ),
                        ],
                      ),

                      20.verticalSpace,

                      // Member Settings Section
                      SectionTitle(
                        title: StrRes.memberSettings,
                        icon: Icons.people_outline_rounded,
                        color: const Color(0xFF3B82F6),
                      ),
                      8.verticalSpace,
                      SettingsMenuSection(
                        items: [
                          SettingsMenuItem(
                            icon: CupertinoIcons.nosign,
                            label: StrRes.notAllowSeeMemberProfile,
                            hasSwitch: true,
                            switchValue: logic.allowLookProfiles,
                            onSwitchChanged: (_) =>
                                logic.toggleMemberProfiles(),
                            showDivider: true,
                            isRow: true,
                          ),
                          SettingsMenuItem(
                            icon: CupertinoIcons.person_add,
                            label: StrRes.notAllAddMemberToBeFriend,
                            hasSwitch: true,
                            switchValue: logic.allowAddFriend,
                            onSwitchChanged: (_) =>
                                logic.toggleAddMemberToFriend(),
                            showDivider: true,
                            isRow: true,
                          ),
                          SettingsMenuItem(
                            icon: CupertinoIcons.gear,
                            label: StrRes.joinGroupSet,
                            value: logic.joinGroupOption,
                            onTap: logic.modifyJoinGroupSet,
                            showDivider: false,
                            isRow: true,
                          ),
                        ],
                      ),

                      if (logic.isOwner) ...[
                        20.verticalSpace,

                        // Owner Settings Section
                        SectionTitle(
                          title: StrRes.ownerSettings,
                          icon: Icons.swap_horiz_rounded,
                          color: const Color(0xFFF59E0B),
                        ),
                        8.verticalSpace,
                        SettingsMenuSection(
                          items: [
                            SettingsMenuItem(
                              icon: CupertinoIcons.arrow_right_arrow_left,
                              label: StrRes.transferGroupOwnerRight,
                              onTap: logic.transferGroupOwnerRight,
                              isWarning: true,
                              showDivider: false,
                              isRow: true,
                            ),
                          ],
                        ),
                      ],

                      24.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
