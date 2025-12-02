import 'dart:convert';

class VersionInfo {
  final int id;
  final String versionName;
  final String versionCode;
  final String releaseNotes;
  final String platform;
  final String buildType;
  final String releaseTime;
  final bool forceUpdate;
  final String downloadUrl;
  final int? size;
  final bool latest;
  final int status;
  final bool inReview;

  VersionInfo({
    required this.id,
    required this.versionName,
    required this.versionCode,
    required this.releaseNotes,
    required this.platform,
    required this.buildType,
    required this.releaseTime,
    required this.forceUpdate,
    required this.downloadUrl,
    this.size,
    required this.latest,
    required this.status,
    required this.inReview,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      id: json['id'],
      versionName: json['versionName'],
      versionCode: json['versionCode'],
      releaseNotes: json['releaseNotes'],
      platform: json['platform'],
      buildType: json['buildType'],
      releaseTime: json['releaseTime'],
      forceUpdate: json['forceUpdate'],
      downloadUrl: json['downloadUrl'],
      size: json['size'],
      latest: json['latest'],
      status: json['status'],
      inReview: json['inReview'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'versionName': versionName,
      'versionCode': versionCode,
      'releaseNotes': releaseNotes,
      'platform': platform,
      'buildType': buildType,
      'releaseTime': releaseTime,
      'forceUpdate': forceUpdate,
      'downloadUrl': downloadUrl,
      'size': size,
      'latest': latest,
      'status': status,
      'inReview': inReview,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
