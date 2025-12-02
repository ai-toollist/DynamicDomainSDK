class Merchant {
  int id;
  String name;
  String fullName;
  String ico;
  String logo;
  String intro;
  String ip;
  String wsAddr;
  String apiAddr;
  String chatAddr;
  String adminAddr;
  String imUserId;
  String inviteCode;
  int level;
  int status;
  License? licenseInfo;

  final List<Map<String, dynamic>> imServerBackups;

  Merchant({
    required this.id,
    required this.name,
    required this.fullName,
    required this.ico,
    required this.logo,
    required this.intro,
    required this.ip,
    required this.wsAddr,
    required this.apiAddr,
    required this.chatAddr,
    required this.adminAddr,
    required this.imUserId,
    required this.inviteCode,
    required this.level,
    required this.status,
    this.licenseInfo,
    this.imServerBackups = const [],
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    final licenseList = (json['license'] as List<dynamic>?)
        ?.map((e) => License.fromJson(e))
        .toList() ??
        [];
    return Merchant(
      id: json['id'],
      name: json['name'],
      fullName: json['fullName'] ?? '',
      ico: json['ico'] ?? '',
      logo: json['logo'] ?? '',
      intro: json['intro'] ?? '',
      ip: json['ip'],
      wsAddr: json['wsAddr'],
      apiAddr: json['apiAddr'],
      chatAddr: json['chatAddr'],
      adminAddr: json['adminAddr'],
      imUserId: json['imUserId'] ?? '',
      inviteCode: json['inviteCode'] ?? '',
      level: json['level'] ?? 1,
      status: json['status'] ?? 1,
      licenseInfo: licenseList.firstOrNull,
      imServerBackups: (json['imServerBackups'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'ico': ico,
      'logo': logo,
      'intro': intro,
      'ip': ip,
      'wsAddr': wsAddr,
      'apiAddr': apiAddr,
      'chatAddr': chatAddr,
      'adminAddr': adminAddr,
      'imUserId': imUserId,
      'inviteCode': inviteCode,
      'level': level,
      'status': status,
      'licenseInfo': licenseInfo?.toJson(),
      'imServerBackups': imServerBackups,
    };
  }

}

class IMServerInfo {
  int merchantID;
  final String name;
  final String ip;
  final String wsAddr;
  final String apiAddr;
  final String chatAddr;

  IMServerInfo({
    required this.merchantID,
    required this.name,
    required this.ip,
    required this.wsAddr,
    required this.apiAddr,
    required this.chatAddr,
  });

  factory IMServerInfo.fromJson(Map<String, dynamic> merchantJson) {
    return IMServerInfo(
      merchantID: merchantJson['merchantID'] as int? ?? 0,
      name: merchantJson['name'] as String? ?? '',
      ip: merchantJson['ip'] as String? ?? '',
      wsAddr: merchantJson['wsAddr'] as String? ?? '',
      apiAddr: merchantJson['apiAddr'] as String? ?? '',
      chatAddr: merchantJson['chatAddr'] as String? ?? '',
    );
  }

  factory IMServerInfo.fromBackup(
      Map<String, dynamic> merchantJson,
      Map<String, dynamic> backup,
      ) {
    return IMServerInfo(
      merchantID: merchantJson['id'] as int? ?? 0,
      name: merchantJson['name'] as String? ?? '',
      ip: merchantJson['ip'] as String? ?? '',
      wsAddr: backup['wsAddr'] as String? ?? '',
      apiAddr: backup['apiAddr'] as String? ?? '',
      chatAddr: backup['chatAddr'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'merchantID': merchantID,
    'name': name,
    'ip': ip,
    'wsAddr': wsAddr,
    'apiAddr': apiAddr,
    'chatAddr': chatAddr,
  };

  @override
  String toString() =>
      'IMServerInfo(merchantID: $merchantID, ws: $wsAddr, api: $apiAddr, chat: $chatAddr)';
}

class MerchantServers {
  final IMServerInfo main;
  final List<IMServerInfo> fallback;

  MerchantServers({
    required this.main,
    this.fallback = const [],
  });

  factory MerchantServers.fromJson(Map<String, dynamic> json) {
    return MerchantServers(
      main: IMServerInfo.fromJson(Map<String, dynamic>.from(json['main'])),
      fallback: (json['fallback'] as List<dynamic>? ?? [])
          .map((b) => IMServerInfo.fromJson(Map<String, dynamic>.from(b)))
          .toList(),
    );
  }

  factory MerchantServers.fromApiJson(Map<String, dynamic> merchantJson) {
    final main = IMServerInfo(
      merchantID: merchantJson['id'] as int? ?? 0,
      name: merchantJson['name'] as String? ?? '',
      ip: merchantJson['ip'] as String? ?? '',
      wsAddr: merchantJson['wsAddr'] as String? ?? '',
      apiAddr: merchantJson['apiAddr'] as String? ?? '',
      chatAddr: merchantJson['chatAddr'] as String? ?? '',
    );

    final fallback = (merchantJson['imServerBackups'] as List<dynamic>? ?? [])
        .map((b) {
      final map = Map<String, dynamic>.from(b);
      return IMServerInfo(
        merchantID: merchantJson['id'] as int? ?? 0,
        name: merchantJson['name'] as String? ?? '',
        ip: merchantJson['ip'] as String? ?? '',
        wsAddr: map['wsAddr'] as String? ?? '',
        apiAddr: map['apiAddr'] as String? ?? '',
        chatAddr: map['chatAddr'] as String? ?? '',
      );
    })
        .toList();

    return MerchantServers(main: main, fallback: fallback);
  }

  List<IMServerInfo> get all => [main, ...fallback];

  Map<String, dynamic> toJson() => {
    'main': main.toJson(),
    'fallback': fallback.map((b) => b.toJson()).toList(),
  };

  @override
  String toString() => 'MerchantServers(main: $main, fallback: $fallback)';
}


class License {
  final int id;
  final String name;
  final String code;
  final String licenseNo;
  final int userLimit;
  final int entryTime;
  final int expiryTime;
  final int status;

  License({
    required this.id,
    required this.name,
    required this.code,
    required this.licenseNo,
    required this.userLimit,
    required this.entryTime,
    required this.expiryTime,
    required this.status,
  });

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      licenseNo: json['licenseNo'],
      userLimit: json['userLimit'],
      entryTime: json['entryTime'],
      expiryTime: json['expiryTime'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'licenseNo': licenseNo,
      'userLimit': userLimit,
      'entryTime': entryTime,
      'expiryTime': expiryTime,
      'status': status,
    };
  }

}

