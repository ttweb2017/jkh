import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:halkbank_app/components/webViewComponent.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/models/charge.dart';
import 'package:halkbank_app/models/order.dart';
import 'package:halkbank_app/models/payment.dart';
import 'package:halkbank_app/util/payment.dart';
import 'package:halkbank_app/util/user.dart';
import 'package:http/http.dart' as http;

class PaymentList extends StatelessWidget {
  final Payment payments;

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  PaymentList({this.payments});

  //Method to register an order in the server and return its id
  Future<int> _fetchPaymentId(BuildContext context, Map<String, String> serverData, Charge charge) async {
    int paymentId = 0;
    final response = await http.post(
        Constants.PAYMENT_URL,
        headers: {"Cookie": serverData[UserUtil.COOKIE]},
        body: {
          "pay_system_id": payments.paymentSystemId.toString(),
          "meters_id": charge.meterId,
          "pay_amount": charge.debt.toString(),
          "sessid": serverData[UserUtil.SESSID]}
        );

      if(response.statusCode == 200){
        var payment = json.decode(response.body);
        paymentId = payment['PAYMENT_ID'];
      }else{
        print("Payment Response code: " + response.statusCode.toString());
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: Tölegi ýerleşdirip bolmady')));
      }

    return paymentId;
  }

  //Method to get orders data from the server
  Future<Order> _fetchOrder(BuildContext context, Map<String, String> header, int paymentId) async {
    Order order;

    print("paymentId: " + paymentId.toString());

    final response = await http.get(
        Constants.PAYMENT_URL + "?payment=" + paymentId.toString(),
        headers: {"Cookie": header[UserUtil.COOKIE]}
    );

    if(response.statusCode == 200){
      order = Order.fromJson(json.decode(response.body));
    }else{
      print("Order Response code: " + response.statusCode.toString());
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: Tölegiň nomerini alyp bolmady')));
    }

    return order;
  }

  //Method to get formUrl from bank api
  Future<String> _fetchPayment(BuildContext context, Order order) async {
    String formUrl = 'http://jkh.tmter.biz';//https://toleg.halkbank.gov.tm
    final String url = await _formGetUrl(order);

    final response = await http.get(url);

    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);

      if (data['errorCode'] == 0) {
        formUrl = data['formUrl'];

        String sign = _getSign(order);
        await PaymentUtil.setPaymentData({
          PaymentUtil.SIGN : sign,
          PaymentUtil.ORDER_ID : data['orderId'],
          PaymentUtil.ORIG_ORDER : order.paymentId.toString()
        });

      }else{
        print("Bank Response Error Message: " + data['errorMessage']);

        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: ' + data['errorMessage'])));
      }
    }else{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: Töleg serwerine baglanyp bolonok!')));
    }

    return formUrl;
  }

  //Method to get sign for security
  String _getSign(Order order){//sha1("$orderId:$amount:$description:$description:$orderId:$amount");
    int amount = (order.paymentAmount * 100).toInt();

    var bytes = utf8.encode(
        order.paymentId.toString() + ":"
            + amount.toString() + ":"
            + order.description + ":"
            + order.description + ":"
            + order.paymentId.toString() + ":"
            + amount.toString()
    );

    return sha1.convert(bytes).toString();
  }

  //Method to form url to make request to bank
  Future<String> _formGetUrl(Order order) async {
    print(order.paymentId);
    int amount = (order.paymentAmount * 100).toInt();

    String sign = _getSign(order);

    String failUrl = order.merchantFailUrl + "?ORDER_ID=" + order.paymentId.toString();

    var failEncoded = Uri.encodeFull(failUrl);

    String returnUrl = order.merchantSuccessUrl + "?ORDER_ID=" + order.paymentId.toString()
        + "&sign=" + sign + "&origOrderId=" + order.paymentId.toString() + "&type=mobile";

    var returnEncoded = Uri.encodeFull(returnUrl);

    String url = order.merchantBaseUrl;
    url += "/payment/rest/register.do";
    url += "?currency" + order.merchantCurrency;
    url += "&language" + order.merchantLanguage;
    url += "&pageView" + order.merchantPageView;
    url += "&description" + order.description;
    url += "&orderNumber" + order.paymentId.toString();
    url += "&failUrl" + failEncoded;
    url += "&userName" + order.merchantId;
    url += "&password" + order.merchantPassword;
    url += "&amount" + amount.toString();
    url += "&sessionTimeoutSecs" + order.sessionTimeoutSecs.toString();
    url += "&returnUrl" + returnEncoded;

    return url;
  }

  void _onTapItem(BuildContext context, Charge charge) async {

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Töleg ýerine ýetirilýär...')));

    final serverData = await UserUtil.getUserData();

    final paymentId = await _fetchPaymentId(context, serverData, charge);

    final order = await _fetchOrder(context, serverData, paymentId);

    final url = await _fetchPayment(context, order);

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Töleg sahypasyna iberilýär...')));

    if(url != ''){
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => WebViewComponent(url: url)
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: payments.chargeList.length,
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '${payments.chargeList[position].serviceName}',
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.green[800])
                  ),
                  //subtitle: Text('${payments.chargeList[position].debt}'),
                  trailing: Column(
                    children: <Widget>[
                      Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            child: Text(
                              "${payments.chargeList[position].debt}" + Constants.CURRENCY,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          padding: const EdgeInsets.all(1.0), // borde width
                          decoration: new BoxDecoration(
                            border: Border.all(color: Colors.green[800]),
                            shape: BoxShape.circle,
                          )
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, payments.chargeList[position]),
                ),
                Divider(height: 5.0)
              ],
            );
          }
      )
    );
  }
}