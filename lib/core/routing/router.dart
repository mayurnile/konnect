import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'route_names.dart';
import '../../presentation/screens/screens.dart';
import '../../providers/providers.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      AuthProvider _authProvider = Get.find();
      User user = _authProvider.firebaseAuth.currentUser;

      if (user != null) {
        _authProvider.fetchUserDetails(user.phoneNumber);
        return _getPageRoute(HomeScreen(), settings);
      }
      return _getPageRoute(AuthScreen(), settings);
    case AUTH_ROUTE:
      return _getPageRoute(AuthScreen(), settings);
    case HOME_ROUTE:
      return _getPageRoute(HomeScreen(), settings);
    case VERIFY_PHONE_ROUTE:
      return _getPageRoute(VerifyPhoneScreen(), settings);
    case CHAT_ROUTE:
      final Map<String, dynamic> args = settings.arguments;
      return _getPageRoute(
        ChatScreen(
          roomId: args['roomId'],
          receiverContact: args['receiverContact'],
        ),
        settings,
      );

    default:
      return _getPageRoute(AuthScreen(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              child,
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              FadeTransition(opacity: animation, child: child),
        );
}
