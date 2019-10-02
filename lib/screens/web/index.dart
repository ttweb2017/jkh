import 'dart:convert';

import 'package:flutter/material.dart';
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

      }
    }else{
      throw Exception("Fail to connect banks payment API");
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
}