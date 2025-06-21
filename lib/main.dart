import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'sreems/auth_screem.dart';

void main() {

  runApp(const MyApp());
}
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          // theme: CustomTheme.baseTheme,
          home: const AuthScreen(),
        );
      },
    );
   
  }
}
