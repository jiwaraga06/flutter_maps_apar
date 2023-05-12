import 'package:flutter_maps_apar/source/pages/Auth/login.dart';
import 'package:flutter_maps_apar/source/pages/Auth/splassh.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:get/get.dart';

class RouterNavigation {
  static final pages = [
    GetPage(
      name: SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: LOGIN,
      page: () => Login(),
    ),
  ];
}
