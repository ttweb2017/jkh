import 'package:flutter/material.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/screens/payment/index.dart';
import 'screens/home/index.dart';
import 'screens/login/index.dart';
import 'screens/profile/index.dart';

class Routes {
  MyCustomRoute route;
  Routes() {
    runApp(MaterialApp(
      title: Constants.APP_TITLE,
      theme: ThemeData(
        primaryColor: Colors.green[800]
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            route = MyCustomRoute(
              builder: (_) => LoginScreen(),
              settings: settings,
            );
            break;
          case '/home':
            route = MyCustomRoute(
              builder: (_) => HomeScreen(),
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

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}