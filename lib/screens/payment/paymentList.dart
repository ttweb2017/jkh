import 'dart:convert';
import 'dart:ffi';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:halkbank_app/components/inputFields.dart';
import 'package:halkbank_app/components/webViewComponent.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/models/charge.dart';
import 'package:halkbank_app/models/order.dart';
import 'package:halkbank_app/models/payment.dart';
import 'package:halkbank_app/util/payment.dart';
import 'package:halkbank_app/util/user.dart';
import 'package:http/http.dart' as http;

class PaymentList extends StatefulWidget {
  final Payment payments;

  PaymentList({Key key, this.payments}):super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState(this.payments);
}

class _PaymentListState extends State<PaymentList> {
  final _loginController = TextEditingController(text: "");
  bool _isLoading;
  final Payment _payments;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  _PaymentListState(this._payments);

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: const EdgeInsets.only(top: 25.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0, right: 30.0, bottom: 5.0, left: 30.0),
              child: Center(
                child: InputFieldArea(
                  maxLen: 6,
                  hint: "Tölegiň jemi TMT",
                  obscure: false,
                  icon: Icons.payment,
                  inputActionType: TextInputAction.done,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textController: _loginController,
                ),
              ),
            ),
            RaisedButton(
              child: Text("Tölemek"),
              onPressed: _prePay,
              textColor: Color(0xFF356736),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Color(0xFF356736),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0)
            ),
            Divider(height: 10.0),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: _payments.chargeList.length,
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  '${_payments.chargeList[position].serviceName}',
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color(0xFF356736))
                              ),
                              //subtitle: Text('${payments.chargeList[position].debt}'),
                              trailing: Column(
                                children: <Widget>[
                                  Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25.0,
                                        child: Text(
                                          "${_payments.chargeList[position].debt}" + Constants.CURRENCY,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF356736),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(1.0), // border width
                                      decoration: new BoxDecoration(
                                        border: Border.all(color: Color(0xFF356736)),
                                        shape: BoxShape.circle,
                                      )
                                  )
                                ],
                              ),
                              onTap: () => _onTapItem(context, _payments.chargeList[position]),
                            ),
                            Divider(height: 10.0),
                          ],
                        );
                      }
                  ),
                  _isLoading ? const CupertinoActivityIndicator(radius: 15.0) : Container()
                ],
              ),
            )
          ],
        )
    );
  }

  _prePay(){
    FocusScope.of(context).requestFocus(new FocusNode());
    /*Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("pay avans clicked: " + _loginController.text.trim())));*/
    //FocusScope.of(context).requestFocus(new FocusNode());

    if(_loginController.text.trim().length != 0
        && double.parse(_loginController.text.trim()) != 0.0){
      Charge charge = Charge(
          currencyTitle: "TMT",
          debt: double.parse(_loginController.text.trim()),
          meterId: "",
          periodId: 0,
          serviceId: 0,
          serviceName: "Pre Payment"
      );

      _onTapItem(context, charge);
    }else{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Töleg jemi 0 TMT ýa da boş bolmaly däl!")));
    }

    _loginController.clear();
  }

  //Method to register an order in the server and return its id
  Future<int> _fetchPaymentId(BuildContext context, Map<String, String> serverData, Charge charge) async {
    int paymentId = 0;

    try{
      final response = await http.post(
          Constants.PAYMENT_URL,
          headers: {"Cookie": serverData[UserUtil.COOKIE]},
          body: {
            "pay_system_id": _payments.paymentSystemId.toString(),
            "meters_id": charge.meterId,
            "pay_amount": charge.debt.toString(),
            "sessid": serverData[UserUtil.SESSID]}
      );

      if(response.statusCode == 200){
        var payment = json.decode(response.body);
        paymentId = payment['PAYMENT_ID'] != null ? payment['PAYMENT_ID'] : 0;
      }else{
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: Tölegi ýerleşdirip bolmady')));
      }
    }catch(e){
      print("Connection exception on _fetchPaymentId(): " + e.toString());
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Internet baglatyňyz kesildi')));
      setState(() {
        _isLoading = false;
      });
    }

    return paymentId;
  }

  //Method to get orders data from the server
  Future<Order> _fetchOrder(BuildContext context, Map<String, String> header, int paymentId) async {
    Order order;

    if(paymentId == 0){
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Töleg jemi 0 TMT bolmaly däl!')));

      setState(() {
        _isLoading = false;
      });

      return order;
    }

    try{
      final response = await http.get(
          Constants.PAYMENT_URL + "?payment=" + paymentId.toString(),
          headers: {"Cookie": header[UserUtil.COOKIE]}
      );

      if(response.statusCode == 200){
        order = Order.fromJson(json.decode(response.body));
      }else{
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: Tölegiň nomerini alyp bolmady')));
      }
    }catch(e){
      print("Connection exception: " + e.toString());
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Internet baglatyňyz kesildi')));

      setState(() {
        _isLoading = false;
      });
    }

    return order;
  }

  //Method to get formUrl from bank api
  Future<String> _fetchPayment(BuildContext context, Order order) async {
    String formUrl = "";

    final String url = await _formGetUrl(order);

    if(url == ""){
      setState(() {
        _isLoading = false;
      });

      return formUrl;
    }

    try{
      final response = await http.get(url);

      if(response.statusCode == 200){
        Map<String, dynamic> data = json.decode(response.body);

        if (data['errorCode'] == "0") {
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
    }catch(e){
      print("Connection exception: " + e.toString());
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Internet baglatyňyz kesildi')));

      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });

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
    if(order == null){
      return "";
    }

    int amount = (order.paymentAmount * 100).toInt();

    String sign = _getSign(order);

    String failUrl = order.merchantFailUrl + "?ORDER_ID=" + order.paymentId.toString();

    var failEncoded = Uri.encodeFull(failUrl);

    String returnUrl = order.merchantSuccessUrl + "?ORDER_ID=" + order.paymentId.toString()
        + "&sign=" + sign + "&origOrderId=" + order.paymentId.toString() + "&type=mobile";

    var returnEncoded = Uri.encodeFull(returnUrl);

    String url = order.merchantBaseUrl;
    url += "/payment/rest/register.do";
    url += "?currency=" + order.merchantCurrency;
    url += "&language=" + order.merchantLanguage;
    url += "&pageView=" + order.merchantPageView;
    url += "&description=" + order.description;
    url += "&orderNumber=" + order.paymentId.toString();
    url += "&failUrl=" + failEncoded;
    url += "&userName=" + order.merchantId;
    url += "&password=" + order.merchantPassword;
    url += "&amount=" + amount.toString();
    url += "&sessionTimeoutSecs=" + order.sessionTimeoutSecs.toString();
    url += "&returnUrl=" + returnEncoded;

    return url;
  }

  void _onTapItem(BuildContext context, Charge charge) async {

    setState(() {
      _isLoading = true;
    });

    final serverData = await UserUtil.getUserData();

    final paymentId = await _fetchPaymentId(context, serverData, charge);

    final order = await _fetchOrder(context, serverData, paymentId);

    final url = await _fetchPayment(context, order);

    if(url != ""){
      if(url.isNotEmpty){
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => WebViewComponent(url: url)
            )
        );
      }
    }
  }

}