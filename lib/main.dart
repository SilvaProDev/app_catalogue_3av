import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'services/api_services.dart';
import 'sreems/auth_screem.dart';
import 'widgets/navbar_roots.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
   checkToken();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');

    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Sizer(
        builder: (context, orientation, deviceType) {
          return token == null ? AuthScreen() : NavBarRoots();
        },
      ),
    );
  }
}
void checkToken() {
  final storage = GetStorage();
  final token = storage.read('token');

  if (token == null || ApiService().isTokenExpired(token)) {
    storage.remove('token');
    Get.offAllNamed('/login');
  }
}