import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String _name = "";

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
    final response = await http.get(
        Constants.PAYMENT_URL,
        headers: {"Cookie": cookie});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print("Payment List Response: " + response.body.toString());
      payment = Payment.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load users payment list');
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

    final response = await http.get(
        url,
        headers: {"Cookie" : header[UserUtil.COOKIE]});

    if(response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);

      if (data['PAYED']) {
        print(data.toString());
        print("Tölegiňiz üstünlikli alyndy. Sag boluň!");

        msg = "Tölegiňiz üstünlikli alyndy. Sag boluň!'";

      }else{
        print("Tölegiňiz geçmedi, täzeden barlaň!");
        print("MSG: " + data['ERROR_MSG']);

        msg = "Tölegiňiz geçmedi, täzeden barlaň!'";

      }
    }else{
      print("payment Status Response Code: " + response.statusCode.toString());

      msg = "Serwerde ýalňyşlyk: Tölegňizi barlap bolmady!'";

    }

    _displaySnakBar(context, msg);

    return response;
  }

  _displaySnakBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
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

  Future<bool> _onWillPop(){
    return showDialog(
        context: context,
        builder: (context) => HomeScreen(returnUrl: "")
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TopImage(
                  title: Constants.APP_TITLE,
                  tag: "payment",
                  backgroundImage: Constants.LOGO_PATH,
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
                            print(snapshot.error);
                            return Center(
                              child: Text(
                                  "Häzirlikçe tökeg ýok!",
                                  style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 15.0)
                              ),
                            );
                          }
                          // By default, show a loading spinner.
                          return const CupertinoActivityIndicator(radius: 20.0);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  /*@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.green[800],
              floating: true,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_name, style: TextStyle(fontSize: 15.0)),
                background: Image.asset(Constants.LOGO_PATH)
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    FutureBuilder<Payment>(
                      future: _payments,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PaymentList(payments: snapshot.data);
                          //return Text(snapshot.data);
                        } else if (snapshot.hasError) {
                          //return Text("${snapshot.error}");
                          print(snapshot.error);
                          return Center(
                            child: Text(
                              "Häzirlikçe tökeg ýok!",
                              style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 15.0)
                            ),
                          );
                        }
                        // By default, show a loading spinner.
                        return CircularProgressIndicator(
                          backgroundColor: Colors.green[800]
                        );
                      },
                    ),
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }*/
}