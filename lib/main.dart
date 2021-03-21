import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/di/locator.dart' as di;
import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(Konnect());
}

class Konnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Konnect',
      debugShowCheckedModeBanner: false,
      theme: KonnectTheme.konnectThemeData,
      navigatorKey: di.locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
