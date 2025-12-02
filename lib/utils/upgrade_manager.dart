import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: '更新提示',
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
            IMViews.showToast('开始下载更新，请留意通知栏');
            await Future.delayed(const Duration(seconds: 3));
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
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: !isForce,
    enableDrag: !isForce,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.system_update_alt_rounded,
                            color: theme.colorScheme.primary, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "发现新版本 v$version",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "更新内容",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    releaseNotes,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color:
                          theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      if (!isForce)
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(
                                color:
                                    theme.colorScheme.outline.withValues(alpha: 0.5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onLater?.call();
                            },
                            child: const Text("稍后再说"),
                          ),
                        ),
                      if (!isForce) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            onUpdate?.call();
                          },
                          child: const Text(
                            "立即更新",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> handleDownload(String apkDownloadUrl) async {
  const platform = MethodChannel('app.channel.download');
  try {
    await platform.invokeMethod('startDownload', {'url': apkDownloadUrl});
  } catch (_) {}
}
