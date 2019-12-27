import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halkbank_app/components/inputFields.dart';
import 'package:halkbank_app/components/topLogoView.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/models/payment.dart';
import 'package:halkbank_app/screens/home/index.dart';
import 'package:halkbank_app/util/payment.dart';
import 'package:halkbank_app/util/user.dart';
import 'dart:async';
import 'paymentList.dart';
import 'package:http/http.dart' as http;


class PaymentScreen extends StatefulWidget {
  final String returnUrl;
  PaymentScreen({Key key, this.returnUrl}):super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState(this.returnUrl);
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _returnUrl;
  Future<Payment> _payments;
  String _name = Constants.APP_TITLE;

  _PaymentScreenState(this._returnUrl);

  _getData() async{
    Map<String, String> data = await UserUtil.getUserData();

    setState(() {
      _name = data[UserUtil.FULL_NAME];
      _payments = _fetchPayment(data[UserUtil.COOKIE]);
    });
  }

  //Method to get payments list that user has to pay
  Future<Payment> _fetchPayment(String cookie) async {
    Payment payment;

    try {
      final response = await http.get(
          Constants.PAYMENT_URL,
          headers: {"Cookie": cookie});

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        payment = Payment.fromJson(json.decode(response.body));
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load users payment list');
      }
    }catch(e){
      print("Payment List Connection error: " + e.toString());

      _displaySnakBar(context, "Internet baglantyňyzy barlaň!");
    }

    return payment;
  }

  Future<http.Response> _fetchPaymentStatus() async {
    String msg;
    String url = Constants.PAYMENT_RESULT_URL;
    Map<String, String> paymentData = await PaymentUtil.getPaymentData();

    Map<String, String> header = await UserUtil.getUserData();

    url += "?ORDER_ID=" + paymentData[PaymentUtil.ORIG_ORDER];
    url += "&sign=" + paymentData[PaymentUtil.SIGN];
    url += "&origOrderId=" + paymentData[PaymentUtil.ORIG_ORDER];
    url += "&type=mobile";
    url += "&orderId=" + paymentData[PaymentUtil.ORDER_ID];
print("github cykmaly");
    try{
      final response = await http.get(
          url,
          headers: {"Cookie" : header[UserUtil.COOKIE]});

      if(response.statusCode == 200){
        Map<String, dynamic> data = json.decode(response.body);

        if (data['PAYED']) {
          msg = "Tölegiňiz üstünlikli alyndy. Sag boluň!'";
        }else{
          msg = "Tölegiňiz geçmedi, täzeden barlaň!'";
        }
      }else{
        msg = "Serwerde ýalňyşlyk: Tölegňizi barlap bolmady!'";
      }

      //_displaySnakBar(context, msg);
      _showAlertDialog(context,msg);

      return response;

    }catch(e){
      print("Connection error: " + e.toString());
      msg = "Internet baglantyňyzy barlaň!";

      //_displaySnakBar(context, msg);
      _showAlertDialog(context, msg);
    }

    return null;
  }

  _displaySnakBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showDialog(BuildContext context, Widget child){
    showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => child,
    );
  }

  void _showAlertDialog(BuildContext context, String msg){
    showDialog(
      context,
      CupertinoAlertDialog(
        title: Text("Tölegiň ýagdaýy"),
        content: Text(msg),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("OK"),
            //onPressed: ()=> print("OK Pressed"),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _getData();

    //checks if user has payed and will show proper SnackBar
    if(_returnUrl.isNotEmpty){
      _fetchPaymentStatus();
    }

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF356736),
        border: null,
      ),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TopImage(
                  title: _name,
                  tag: "payment",
                  backgroundImage: Constants.LOGO_PATH,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0)
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<Payment>(
                        future: _payments,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PaymentList(payments: snapshot.data);
                            //return Text(snapshot.data);
                          } else if (snapshot.hasError) {
                            //return Text("${snapshot.error}");
                            print("Snapshot of Payment List:::" + snapshot.error.toString());
                            return Center(
                              child: Text(
                                  "Häzirlikçe tökeg ýok!",
                                  style: TextStyle(color: Color(0xFF356736), fontWeight: FontWeight.bold, fontSize: 15.0)
                              ),
                            );
                          }
                          // By default, show a loading spinner.
                          return const CupertinoActivityIndicator(radius: 15.0);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
