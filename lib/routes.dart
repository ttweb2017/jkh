import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halkbank_app/screens/payment/index.dart';
import 'screens/home/index.dart';
import 'screens/login/index.dart';
import 'screens/profile/index.dart';

class Routes {
  MyCustomRoute route;
  Routes(){
    runApp(CupertinoApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        primaryColor: Colors.green[800],
        barBackgroundColor: Colors.green[800],
        textTheme: CupertinoTextThemeData(
          primaryColor: Colors.green[800],
          textStyle: TextStyle(color: Colors.black),
          navLargeTitleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: CupertinoColors.activeGreen,
          ),
        ),
      ),
      home: LoginScreen(),
      onGenerateRoute: (RouteSettings settings){
        switch (settings.name) {
          case '/login':
            route = MyCustomRoute(
              builder: (_) => LoginScreen(),
              settings: settings,
            );
            break;
          case '/home':
            route = MyCustomRoute(
              builder: (_) => HomeScreen(returnUrl: ""),
              settings: settings,
            );
            break;
          case '/profile':
            route = MyCustomRoute(
              builder: (_) => ProfileScreen(),
              settings: settings,
            );
            break;
          case '/payment':
            route = MyCustomRoute(
              builder: (_) => PaymentScreen(returnUrl: ""),
              settings: settings,
            );
            break;
          default :
            route = MyCustomRoute(
              builder: (_) => LoginScreen(),
              settings: settings,
            );
            break;
        }

        return route;
      },
    ));
  }
}

class MyCustomRoute<T> extends CupertinoPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}