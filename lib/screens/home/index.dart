import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/screens/login/index.dart';
import 'package:halkbank_app/screens/payment/index.dart';
import 'package:halkbank_app/screens/profile/index.dart';
import 'package:halkbank_app/util/user.dart';
import '../../components/topLogoView.dart';
import '../../components/dashboardCard.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  String _name = "Halk Hyzmatlary";

  _getUserName() async {
    final Map<String, String> userData = await UserUtil.getUserData();

    // get value from saved file and change title
    setState(() {
      build(context);
      _name = userData[UserUtil.FULL_NAME];
    });
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

  /*Future<bool> _onWillPop(){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Çykmak isleýäňizmi?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Ýok'),
              ),
              FlatButton(
                onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                child: Text('Hawa'),
              ),
            ],
          );
        }
    ) ?? false;
  }*/

  Future<bool> _onWillPop(){
    return showDialog(
        context: context,
        builder: (context) => LoginScreen()
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box, size: 52.0, color: Colors.white)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment, size: 52.0, color: Colors.white)
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        assert(index >= 0 && index <= 1);

        switch (index) {
          case 0:
            return ProfileScreen();
            break;
          case 1:
            return PaymentScreen(returnUrl: "");
            break;
        }

        return null;
      },
      /*child: Scaffold(
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TopImage(
                  title: _name,
                  backgroundImage: Constants.LOGO_PATH,
                  containerGrowAnimation: containerGrowAnimation,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DashboardCard(
                          icon: Icon(Icons.payment, size: 52.0, color: Colors.white),
                          title: "Tölemek",
                          description: "Tölegleri bu ýerden töläp bilersiňiz",
                          marginRight: 8.0,
                          offset: Offset(-2.0, 2.0),
                          route: "/payment"
                      ),
                      DashboardCard(
                          icon: Icon(Icons.account_box, size: 52.0, color: Colors.white),
                          title: "Profilim",
                          description: "Öz profiliňizi bärden görüp bilersiňiz",
                          marginRight: 0.0,
                          offset: Offset(2.0, 2.0),
                          route: "/profile"
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),*/
    );
  }
  /*@override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    return WillPopScope(
      onWillPop: _onWillPop,
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
                  backgroundImage: Constants.LOGO_PATH,
                  containerGrowAnimation: containerGrowAnimation,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DashboardCard(
                        icon: Icon(Icons.payment, size: 52.0, color: Colors.white),
                        title: "Tölemek",
                        description: "Tölegleri bu ýerden töläp bilersiňiz",
                        marginRight: 8.0,
                        offset: Offset(-2.0, 2.0),
                        route: "/payment"
                      ),
                      DashboardCard(
                        icon: Icon(Icons.account_box, size: 52.0, color: Colors.white),
                        title: "Profilim",
                        description: "Öz profiliňizi bärden görüp bilersiňiz",
                        marginRight: 0.0,
                        offset: Offset(2.0, 2.0),
                        route: "/profile"
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }*/
}