class Charge {

  int periodId;
  int serviceId;
  String serviceName;
  String meterId;
  double debt;
  String currencyTitle;

  Charge({
    this.periodId,
    this.serviceId,
    this.serviceName,
    this.meterId,
    this.debt,
    this.currencyTitle
  });

  factory Charge.fromJson(Map<String, dynamic> json){
    return Charge(
      periodId: json['PERIOD_ID'],
      serviceId: json['SERVICE_ID'],
      serviceName: json['SERVICE_NAME'],
      meterId: json['METER_XML_ID'],
      debt: json['DEBT_END'],
      currencyTitle: json['CURRENCY_TITLE'],
    );
  }
}