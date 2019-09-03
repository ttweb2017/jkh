
class Order {
  String merchantId;
  String merchantPassword;
  String merchantCurrency;
  String merchantLanguage;
  String merchantPageView;
  String merchantBaseUrl;
  String merchantSuccessUrl;
  String merchantFailUrl;
  int paymentId;
  double paymentAmount;
  final String description = "Toleg";
  final int sessionTimeoutSecs = 300;

  Order({
    this.merchantId,
    this.merchantPassword,
    this.merchantCurrency,
    this.merchantLanguage,
    this.merchantPageView,
    this.merchantBaseUrl,
    this.merchantSuccessUrl,
    this.merchantFailUrl,
    this.paymentId,
    this.paymentAmount
  });

  factory Order.fromJson(Map<String, dynamic> json){

    return Order(
      merchantId: json['ALTYN_ASYR_MERCHANT_ID'],
      merchantPassword: json['ALTYN_ASYR_MERCHANT_PASSWORD'],
      merchantCurrency: json['ALTYN_ASYR_CURRENCY_ID'],
      merchantLanguage: json['ALTYN_ASYR_LANGUAGE'],
      merchantPageView: json['ALTYN_ASYR_PAGE_VIEW'],
      merchantBaseUrl: json['ALTYN_ASYR_BASE_URL'],
      merchantSuccessUrl: json['ALTYN_ASYR_SUCCESS_URL'],
      merchantFailUrl: json['ALTYN_ASYR_FAIL_URL'],
      paymentId: int.parse(json['PAYMENT_ID']),
      paymentAmount:  double.parse(json['PAYMENT_AMOUNT'])
    );
  }
}