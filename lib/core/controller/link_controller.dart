import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class LinkController extends GetxController {
  final groupLink = ''.obs;
  final userLink = ''.obs;
  // 获取用户分享链接
  Future<String> getUserShareLink(String userID) async {
    userLink.value = await ChatApis.getUserLink(userID);
    return userLink.value;
  }

  // 获取群分享链接
  Future<String> getGroupShareLink(String groupID) async {
    groupLink.value = await ChatApis.getGroupLink(groupID);
    return groupLink.value;
  }

  // 更新链接有效期
  void updateLinkExpiry(int type, String id, int days) async {
    if (type == 0) {
      await LoadingView.singleton.wrap(
        asyncFunction: () => ChatApis.updateGroupLink(id, days),
      );
      groupLink.value = await getGroupShareLink(id);
    } else {
      await LoadingView.singleton.wrap(
        asyncFunction: () => ChatApis.updateUserLink(id, days),
      );
      userLink.value = await getUserShareLink(id);
    }
    Get.back();
  }

  showExpirySheet(int type, String id) {
    //type 0 群 1 用户
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(StrRes.neverExpires),
              onTap: () => updateLinkExpiry(type, id, 0),
            ),
            ListTile(
              title: Text(StrRes.oneDay),
              onTap: () => updateLinkExpiry(type, id, 1),
            ),
            ListTile(
              title: Text(StrRes.sevenDays),
              onTap: () => updateLinkExpiry(type, id, 7),
            ),
            ListTile(
              title: Text(StrRes.thirtyDays),
              onTap: () => updateLinkExpiry(type, id, 30),
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    );
  }
}
