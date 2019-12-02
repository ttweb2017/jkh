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
  final _loginController = TextEditingController(text: "");
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

    try{
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

    }catch(e){
      print("Connection error: " + e.toString());
      msg = "Internet baglantyňyzy barlaň!";

      _displaySnakBar(context, msg);
    }

    return null;
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

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      child: Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
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
                  Container(
                    margin: EdgeInsets.only(top: 50.0, right: 30.0, bottom: 5.0, left: 30.0),
                    child: Center(
                      child: InputFieldArea(
                        maxLen: 6,
                        hint: "Avans",
                        obscure: false,
                        icon: Icons.payment,
                        inputActionType: TextInputAction.done,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textController: _loginController,
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("tolemek"),
                    onPressed: _prePay,
                    textColor: Colors.green[800],
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.green[800],
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
        )
      ),
    );
  }

  _prePay(){
    print("pay avans clicked: " + _loginController.text.trim());
  }
}