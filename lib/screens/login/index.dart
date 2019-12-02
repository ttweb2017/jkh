import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halkbank_app/constants.dart';
import '../../components/topLogoView.dart';
import '../../components/loginForm.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  Animation<double> containerGrowAnimation;
  Animation<Color> fadeScreenAnimation;
  AnimationController _screenController;
  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    super.initState();

    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );

    _screenController = AnimationController(
        duration: Duration(milliseconds: 2000),
        vsync: this
    );

    fadeScreenAnimation = ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),

    ).animate(
        CurvedAnimation(parent: _screenController, curve: Curves.ease)
    );

    containerGrowAnimation = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    containerGrowAnimation.addListener(
            () {
          this.setState(() {

          });
        }
    );

    containerGrowAnimation.addStatusListener((AnimationStatus status){});

    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    _loginButtonController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
                  title: Constants.APP_TITLE,
                  tag: "login",
                  backgroundImage: Constants.LOGO_PATH,
                  containerGrowAnimation: containerGrowAnimation,
                ),
                Container(
                  /*height: sSize.height - 300,
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),*/
                  child: FormContainer(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}