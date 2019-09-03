import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:halkbank_app/models/order.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class WebViewScreen {
  final Future<Order> futureOrder;
  final Order order;

  WebViewScreen({this.order, this.futureOrder});

  void makePayment(BuildContext context) async {

    final String url = _formGetUrl(order);

    final response = await http.get(url);

    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);

      if (data['errorCode'] == 0) {
        //_launchURL(context, data['formUrl']);
      }else{
        print("Bank Response Error Message: " + data['errorMessage']);

        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: ' + data['errorMessage'])));
        //_launchURL(context, "https://toleg.halkbank.gov.tm");

      }
    }else{
      throw Exception("Fail to connect banks payment API");
    }
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: false,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  String _formGetUrl(Order order){
    print(order.paymentId);
    //int amount = (order.paymentAmount * 100).toInt();
    int amount = 100;

    var bytes = utf8.encode(
        order.paymentId.toString() + ":"
            + amount.toString() + ":"
            + order.description + ":"
            + order.description + ":"
            + order.paymentId.toString() + ":"
            + amount.toString()
    );

    var sign = sha1.convert(bytes);//sha1("$orderId:$amount:$description:$description:$orderId:$amount");

    String failUrl = order.merchantFailUrl + "?ORDER_ID=" + order.paymentId.toString();

    var failEncoded = Uri.encodeFull(failUrl);

    String returnUrl = order.merchantSuccessUrl + "?ORDER_ID=" + order.paymentId.toString()
        + "&sign=" + sign.toString() + "&origOrderId=" + order.paymentId.toString() + "&type=mobile";

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

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*return Scaffold(
      body: Center(
        child: FutureBuilder<Order>(
          future: futureOrder,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              _makePayment(context, snapshot.data);
              return Container();
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[800]),
            );
          }
        )
      ),
    );*/
  }*/
}