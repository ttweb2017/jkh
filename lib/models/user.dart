class User {
  final String login;
  final String userId;
  final String hashedUserId;
  final String bitrixUidh;
  final String sessionId;
  final String bitrixSessid;
  final String fullName;
  final bool status;
  final String xmlId;
  final String fullAddress;
  final String region;
  final String city;
  final String settlement;
  final String district;
  final String street;
  final String house;
  final String flat;

  User({
    this.login,
    this.userId,
    this.hashedUserId,
    this.bitrixUidh,
    this.sessionId,
    this.bitrixSessid,
    this.fullName,
    this.status,
    this.xmlId,
    this.fullAddress,
    this.region,
    this.city,
    this.settlement,
    this.district,
    this.street,
    this.house,
    this.flat
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['LOGIN'],
      userId: json['USER_ID'],
      hashedUserId: json['BX_USER_ID'],
      bitrixUidh: json['BX_UIDH'],
      sessionId: json['SESSION_ID'],
      bitrixSessid: json['SESSID'],
      fullName: json['USER_NAME'],
      status: json['STATUS'],
      xmlId: json['XML_ID'],
      fullAddress: json['ADDRESS_FULL'],
      region: json['REGION'],
      city: json['CITY'],
      settlement: json['SETTLEMENT'],
      district: json['DISTRICT'],
      street: json['STREET'],
      house: json['HOUSE'],
      flat: json['FLAT'],
    );
  }
}