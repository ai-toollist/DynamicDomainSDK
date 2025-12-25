import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_upgrader/flutter_upgrader_channel.dart';
import 'package:flutter_upgrader/flutter_upgrader_manager.dart';
import 'package:flutter_upgrader/flutter_upgrader_market.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';

mixin UpgradeManger {
  var hasShownUpgradeDialog = false;
  var hasIgnoredUpdate = false;
  var hasCheckedUpdate = false;

  void checkUpdate() async {
    if (hasShownUpgradeDialog || hasIgnoredUpdate || hasCheckedUpdate) return;
    hasCheckedUpdate = true;

    final versionInfo = await GatewayApi.getLatestVersion();
    if (versionInfo == null) {
      return;
    }

    final packageInfo = await PackageInfo.fromPlatform();

    final canUpdate = packageInfo.version != versionInfo.versionName;

    if (!canUpdate || versionInfo.inReview) {
      return;
    }

    hasShownUpgradeDialog = true;

    final Future<AppUpgradeInfo> appUpgradeInfo = Future.value(
      AppUpgradeInfo(
        title: StrRes.upgradeFind,
        version: versionInfo.versionName,
        contents: versionInfo.releaseNotes.split('\n'),
        force: versionInfo.forceUpdate,
      ),
    );

    if (Platform.isIOS) {
      AppUpgradeManager.upgrade(
        Get.context!,
        appUpgradeInfo,
        iosAppId: Config.iosAppId,
      );
      return;
    }

    if (Platform.isAndroid) {
      if (versionInfo.downloadUrl.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 2));
        showUpdateBottomSheet(
          Get.context!,
          version: versionInfo.versionName,
          releaseNotes: versionInfo.releaseNotes,
          isForce: versionInfo.forceUpdate,
          onLater: () {
            hasIgnoredUpdate = true;
          },
          onUpdate: () async {
            IMViews.showToast(StrRes.startDownloadNotice, type: 1);
            await Future.delayed(const Duration(seconds: 2));
            handleDownload(versionInfo.downloadUrl);
          },
        );
      } else {
        final appMarketInfos = AppMarketManager.getAppMarketList(
          await FlutterUpgradeChanneler.getInstallMarket(
            [packageInfo.packageName],
          ),
        );
        AppUpgradeManager.upgrade(
          Get.context!,
          appUpgradeInfo,
          appMarketInfo: appMarketInfos.firstOrNull,
          onCancel: () {
            hasIgnoredUpdate = true;
          },
        );
      }
    }
  }
}

Future<void> showUpdateBottomSheet(
  BuildContext context, {
  required String version,
  required String releaseNotes,
  bool isForce = false,
  VoidCallback? onLater,
  VoidCallback? onUpdate,
}) async {
  final primaryColor = Theme.of(context).primaryColor;

  return showModalBottomSheet<void>(
    context: context,
    isDismissible: !isForce,
    enableDrag: !isForce,
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return PopScope(
        canPop: !isForce,
        child: Stack(
          children: [
            // Backdrop blur - also block taps when force update
            Positioned.fill(
              child: GestureDetector(
                onTap: isForce ? null : () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Bottom sheet content
            DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: isForce ? 0.85 : 0.35,
              maxChildSize: 0.85,
              expand: false,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.r),
                      topRight: Radius.circular(32.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9CA3AF).withOpacity(0.08),
                        offset: const Offset(0, -3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),

                      // Title Section
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 16.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor.withOpacity(0.15),
                                    primaryColor.withOpacity(0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                CupertinoIcons.arrow_down_doc,
                                size: 26.w,
                                color: primaryColor,
                              ),
                            ),
                            14.horizontalSpace,
                            Expanded(
                              child: Text(
                                "${StrRes.upgradeFind} v$version",
                                style: TextStyle(
                                  fontFamily: 'FilsonPro',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Divider(
                        height: 1,
                        color: const Color(0xFFF3F4F6),
                        indent: 20.w,
                        endIndent: 20.w,
                      ),

                      // Content Section
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StrRes.updateContent,
                                style: TextStyle(
                                  fontFamily: 'FilsonPro',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              12.verticalSpace,
                              Text(
                                releaseNotes,
                                style: TextStyle(
                                  fontFamily: 'FilsonPro',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.6,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Buttons Section
                      Container(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xFFF3F4F6),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (!isForce)
                              Expanded(
                                child: _buildCustomButton(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    onLater?.call();
                                  },
                                  title: StrRes.upgradeLater,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            if (!isForce) 12.horizontalSpace,
                            Expanded(
                              child: _buildCustomButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  onUpdate?.call();
                                },
                                title: StrRes.upgradeNow,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

/// Build a button matching CustomButton style
Widget _buildCustomButton({
  required VoidCallback onTap,
  required String title,
  required Color color,
}) {
  final borderRadius = BorderRadius.circular(16.r);

  return Container(
    decoration: BoxDecoration(
      borderRadius: borderRadius,
      color: color.withOpacity(0.15),
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.08),
              color.withOpacity(0.15),
            ],
          ),
          borderRadius: borderRadius,
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  color: color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> handleDownload(String apkDownloadUrl) async {
  const platform = MethodChannel('app.channel.download');
  try {
    await platform.invokeMethod('startDownload', {'url': apkDownloadUrl});
  } catch (_) {}
}
