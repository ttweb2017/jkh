import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/util/user.dart';
import './inputFields.dart';
import '../models/user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormContainer extends StatefulWidget {
  @override
  _FormContainerState createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> with TickerProviderStateMixin {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  String _incorrectPasswordMessage;
  String _incorrectLoginMessage;
  bool _incorrectPassword;
  bool _incorrectLogin;
  bool _isLogged;

  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    super.initState();

    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );

    _incorrectLoginMessage = "";
    _incorrectLogin = false;
    _incorrectPasswordMessage = "";
    _incorrectPassword = false;

    _isLogged = false;
  }

  @override
  void dispose() {
    _loginButtonController.dispose();

    super.dispose();
  }

  //Method to get user data from server
  Future<User> _fetchUser(BuildContext context, String login, String password) async {
    User user;
    try{
      final response = await http.post(
          Constants.LOGIN_URL,
          body: {'LOGIN': login, 'PASSWORD': password}
      );

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        print("User response: " + response.body.toString());

        user = User.fromJson(json.decode(response.body));

      } else {
        // If that response was not OK, throw an error.
        print("User response code: " + response.statusCode.toString());
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Serwerde ýalňyşlyk: Serwere baglanyp bolmady!')));
      }
    }catch(e){
      print("Connection error: " + e.toString());
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Internet baglantyňyzy barlaň!')));
    }

    return user;
  }


  _login(String login, String password) async {
    User user = await _fetchUser(context, login, password);

    if(user.status){
      await UserUtil.saveUserData(user);
    }

    _isLogged = user.status;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 50.0, right: 30.0, bottom: 5.0, left: 30.0),
      child: Form(
        key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InputFieldArea(
                maxLen: 30,
                hint: "LOGIN",
                obscure: false,
                icon: Icons.person_outline,
                textController: _loginController,
                inputActionType: TextInputAction.next,
                keyboardType: TextInputType.number,
              ),
              _incorrectLogin ?
              Container(
                child: Text(_incorrectLoginMessage, style: TextStyle(color: CupertinoColors.destructiveRed))
              ) : Container(),
              InputFieldArea(
                maxLen: 30,
                hint: "AÇARSÖZ",
                obscure: true,
                icon: Icons.lock_outline,
                textController: _passwordController,
                inputActionType: TextInputAction.done,
                keyboardType: TextInputType.number,
              ),
              _incorrectPassword ?
              Container(
                child: Text(_incorrectPasswordMessage, style: TextStyle(color: CupertinoColors.destructiveRed)),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: RaisedButton(
                    padding: const EdgeInsets.only(top: 15.0, right: 30.0, bottom: 15.0, left: 30.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    onPressed: () async {
                      if(_loginController.text.trim().isEmpty){
                        setState(() {
                          _incorrectLoginMessage = "LOGIN'i dolduruň!";
                          _incorrectLogin = true;
                        });
                      }else{
                        setState(() {
                          _incorrectLoginMessage = "";
                          _incorrectLogin = false;
                        });
                      }

                      if(_passwordController.text.trim().isEmpty){
                        setState(() {
                          _incorrectPasswordMessage = "AÇARSÖZ'ü dolduruň!";
                          _incorrectPassword = true;
                        });
                      }else{
                        setState(() {
                          _incorrectPasswordMessage = "";
                          _incorrectPassword = false;
                        });
                      }

                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if(_formKey.currentState.validate() && !_incorrectPassword && !_incorrectLogin){

                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("Belgiňiz barlanýar...")));
                        await _login(_loginController.text.trim(), _passwordController.text.trim());

                        if(_isLogged){
                          Navigator.pushReplacementNamed(context, "/home");
                        }else{
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text("Login ýa-da açarsözuňiz ýalňyş!")));
                        }
                      }
                    },
                    color: Colors.orange[800],
                    textColor: Colors.white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("Giriň "),
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(Icons.send)
                            ),
                          ],
                        )
                      ],
                    )
                )
              )
            ],
          ),
        onChanged: (){
          _formKey.currentState.validate();
        },
      ),
    );
  }
}