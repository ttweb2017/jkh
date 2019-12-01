import 'charge.dart';
class Payment {

  Map<String, dynamic> paymentSystem;
  int paymentSystemId;
  String meterId;
  double amount;
  String lastPeriod;
  String accountNo;
  List<Charge> chargeList;

  Payment({
    this.paymentSystem,
    this.paymentSystemId,
    this.meterId,
    this.amount,
    this.lastPeriod,
    this.accountNo,
    this.chargeList
  });


  factory Payment.fromJson(Map<String, dynamic> json) {
    var charges = json['TKM_PAYMENT_CHARGES'] as List;
    List<Charge> chargeList = new List<Charge>();

    if(charges != null){
      chargeList = charges.map((i) => Charge.fromJson(i)).toList();
    }

    chargeList.add(Charge(
      serviceName: "Jemi",
      serviceId: 0,
      debt: double.parse(json['AMOUNT_TO_SHOW']),
      currencyTitle: "TMT",
      periodId: 0,
      meterId: ""
    ));

    return Payment(
        paymentSystem: json['PAY_SYSTEM'],
        paymentSystemId: int.parse(json['PAY_SYSTEM']['ID']),
        meterId: json['METER_ID'],
        amount: double.parse(json['AMOUNT_TO_SHOW']),
        lastPeriod: json['LAST_PERIOD'],
        accountNo: json['XML_ID'],
        chargeList: chargeList
    );
  }
}