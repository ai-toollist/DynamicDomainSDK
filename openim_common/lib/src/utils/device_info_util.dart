import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoUtil {
  static Future<DeviceInfoSimple> getDeviceInfoSimple() async {
    if (Platform.isIOS) {
      return DeviceInfoSimple(brand: 'apple', manufacturer: 'apple');
    }
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final brand = androidInfo.brand.toLowerCase();
    final manufacturer = androidInfo.manufacturer.toLowerCase();
    return DeviceInfoSimple(brand: brand, manufacturer: manufacturer);
  }

  static Future<String> getDeviceInfoBrand() async {
    final deviceInfoSimple = await getDeviceInfoSimple();
    return deviceInfoSimple.brand;
  }

  static Future<void> printDeviceInfo() async {
    if (kDebugMode) {
      print('============打印设备信息 开始============');
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print(_readAndroidBuildData(androidInfo).toString());
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print(_readIosDeviceInfo(iosInfo).toString());
      }

      print('============打印设备信息 结束============');
    }
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}

class DeviceInfoSimple {
  final String brand;
  final String manufacturer;

  DeviceInfoSimple({
    required this.brand,
    required this.manufacturer,
  });

  bool get isHuawei =>
      brand.contains('huawei') || manufacturer.contains('huawei');

  bool get isHonor => brand.contains('honor') || manufacturer.contains('honor');

  bool get isOppo => brand.contains('oppo') || manufacturer.contains('oppo');

  bool get isVivo => brand.contains('vivo') || manufacturer.contains('vivo');

  bool get isXiaomi =>
      brand.contains('xiaomi') || manufacturer.contains('xiaomi');

  @override
  String toString() => 'Brand: $brand, Manufacturer: $manufacturer';
}
