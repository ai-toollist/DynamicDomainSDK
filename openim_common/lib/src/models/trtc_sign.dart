class TRTCSign {
  final String userSig;
  final int? appId;

  final int expireTime;

  const TRTCSign({
    required this.userSig,
    this.appId,
    required this.expireTime,
  });

  factory TRTCSign.fromJson(Map<String, dynamic> json) {
    return TRTCSign(
      userSig: json["userSig"],
      appId: json["appId"],
      expireTime: json["expireTime"],
    );
  }

  Map<String, dynamic> toJson() =>
      {"userSig": userSig, "appId": appId, "expireTime": expireTime};
}
