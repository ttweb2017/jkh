import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halkbank_app/screens/payment/index.dart';
import 'package:halkbank_app/screens/profile/index.dart';
import 'package:halkbank_app/util/user.dart';

class HomeScreen extends StatefulWidget {
  final String returnUrl;
  HomeScreen({Key key, this.returnUrl}):super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(this.returnUrl);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final String _returnUrl;
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;

  _HomeScreenState(this._returnUrl);

  _getUserName() async {
    final Map<String, String> userData = await UserUtil.getUserData();
  }

  @override
  void initState() {
    _screenController = AnimationController(
        duration: Duration(milliseconds: 2000),
        vsync: this
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

    _getUserName();
    super.initState();
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: Color(0xFF356736),
        brightness: Brightness.dark,
        barBackgroundColor: Color(0xFF356736)
      ),
      home: CupertinoTabScaffold(
          backgroundColor: Color(0xFF356736),
          tabBar: CupertinoTabBar(
            backgroundColor: Color(0xFF356736),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.payment, size: 52.0, color: Colors.white),
                  activeIcon: Icon(Icons.payment, size: 52.0, color: Colors.orange[800])
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box, size: 52.0, color: Colors.white),
                  activeIcon: Icon(Icons.account_box, size: 52.0, color: Colors.orange[800])
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            assert(index >= 0 && index <= 1);

            switch (index) {
              case 0:
                return PaymentScreen(returnUrl: _returnUrl);
                break;
              case 1:
                return ProfileScreen();
                break;
            }

            return null;
          }
      )
    );
  }
}