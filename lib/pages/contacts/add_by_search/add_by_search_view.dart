// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:openim/constants/app_color.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim/widgets/gradient_header.dart';
import 'package:openim_common/openim_common.dart';
import '../../../widgets/custom_buttom.dart';
import 'add_by_search_logic.dart';

class AddContactsBySearchPage extends StatelessWidget {
  final logic = Get.find<AddContactsBySearchLogic>();

  AddContactsBySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: logic.isSearchUser ? StrRes.addFriend : StrRes.addGroup,
      subtitle: logic.isSearchUser
          ? StrRes.searchAddFriends
          : StrRes.searchJoinGroups,
      showBackButton: true,
      trailing: HeaderActionButton(
        icon: CupertinoIcons.qrcode_viewfinder,
        onTap: AppNavigator.startScan,
      ),
      searchBox: _buildSearchBox(),
      body: _buildContent(context),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          16.horizontalSpace,
          HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            size: 24.w,
            color: const Color(0xFF9CA3AF),
          ),
          12.horizontalSpace,
          Expanded(
            child: TextField(
              controller: logic.searchCtrl,
              focusNode: logic.focusNode,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
              ),
              decoration: InputDecoration(
                hintText: logic.isSearchUser
                    ? StrRes.searchByPhoneAndUid
                    : StrRes.searchIDAddGroup,
                hintStyle: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => logic.search(),
            ),
          ),
          Obx(() {
            // Access observable to trigger rebuild
            final _ = logic.userInfoList.length;
            final __ = logic.groupInfoList.length;
            return logic.searchKey.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      logic.searchCtrl.clear();
                      logic.focusNode.requestFocus();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 20.w,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  )
                : SizedBox(width: 16.w);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.7),
            theme.primaryColor.withOpacity(0.9),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  CustomButton(
                    onTap: () => Get.back(),
                    icon: Icons.arrow_back_ios_new_rounded,
                    colorIcon: Colors.white,
                    colorButton: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.all(10.w),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          logic.isSearchUser
                              ? StrRes.addFriend
                              : StrRes.addGroup,
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          logic.isSearchUser
                              ? StrRes.searchAddFriends
                              : StrRes.searchJoinGroups,
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (logic.isSearchUser)
                    CustomButton(
                      onTap: AppNavigator.startScan,
                      icon: CupertinoIcons.qrcode_viewfinder,
                      colorButton: Colors.white.withOpacity(0.2),
                      colorIcon: Colors.white,
                      padding: EdgeInsets.all(10.w),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() {
      // Access observable variables directly
      final userList = logic.userInfoList;
      final groupList = logic.groupInfoList;

      bool hasSearchResults =
          logic.isSearchUser ? userList.isNotEmpty : groupList.isNotEmpty;
      bool isSearching = logic.searchKey.isNotEmpty;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 20.h),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 450),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                curve: Curves.easeOutQuart,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                16.verticalSpace,
                if (isSearching && hasSearchResults) ...[
                  _buildResultsSection(),
                ],
                if (isSearching && !hasSearchResults) ...[
                  _buildNotFoundView(),
                ],
                if (!isSearching) ...[
                  _buildInitialView(),
                ],
                24.verticalSpace,
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInitialView() {
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.verticalSpace,
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9CA3AF).withOpacity(0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFF3F4F6),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  HugeIcon(
                    icon: logic.isSearchUser
                        ? HugeIcons.strokeRoundedUserAdd01
                        : HugeIcons.strokeRoundedUserGroup,
                    size: 64.w,
                    color: const Color(0xFF9CA3AF),
                  ),
                  24.verticalSpace,
                  Text(
                    logic.isSearchUser
                        ? StrRes.searchByPhoneAndUid
                        : StrRes.searchIDAddGroup,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9CA3AF).withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 6.r,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF3F4F6),
          width: 1,
        ),
      ),
      child: logic.isSearchUser ? _buildUserResults() : _buildGroupResults(),
    );
  }

  Widget _buildUserResults() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logic.userInfoList.length,
      itemBuilder: (_, index) {
        final userInfo = logic.userInfoList.elementAt(index);
        return _buildResultItem(userInfo, index, logic.userInfoList.length);
      },
    );
  }

  Widget _buildGroupResults() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logic.groupInfoList.length,
      itemBuilder: (_, index) {
        final groupInfo = logic.groupInfoList.elementAt(index);
        return _buildResultItem(groupInfo, index, logic.groupInfoList.length);
      },
    );
  }

  Widget _buildResultItem(dynamic info, int index, int totalItems) {
    final bool isLastItem = index == totalItems - 1;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => logic.viewInfo(info),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  AvatarView(
                    url: logic.isSearchUser ? info.faceURL : info.faceURL,
                    text: logic.isSearchUser ? info.nickname : info.groupName,
                    width: 40.w,
                    height: 40.h,
                    textStyle: TextStyle(
                      fontFamily: 'FilsonPro',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    isCircle: true,
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logic.getShowTitle(info),
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (logic.isSearchUser && info.userID != null) ...[
                          4.verticalSpace,
                          Text(
                            '${StrRes.idLabel} ${info.userID}',
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    size: 20.w,
                    color: AppColor.iconColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLastItem)
          Padding(
            padding: EdgeInsets.only(left: 72.w),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF3F4F6),
            ),
          ),
      ],
    );
  }

  Widget _buildNotFoundView() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68.w,
              height: 68.h,
              decoration: BoxDecoration(
                color: const Color(0xFF6B7280).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: HugeIcon(
                icon: logic.isSearchUser
                    ? HugeIcons.strokeRoundedUserRemove01
                    : HugeIcons.strokeRoundedUserGroup,
                color: AppColor.iconColor,
                size: 20.w,
              ),
            ),
            16.verticalSpace,
            Text(
              logic.isSearchUser ? StrRes.noFoundUser : StrRes.noFoundGroup,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
