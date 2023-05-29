import 'package:flutter_maps_apar/source/pages/Auth/changePassword.dart';
import 'package:flutter_maps_apar/source/pages/Auth/login.dart';
import 'package:flutter_maps_apar/source/pages/Auth/splassh.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/editapar.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/bottomNav.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:get/get.dart';

class RouterNavigation {
  static final pages = [
    GetPage(
      name: SPLASH,
      page: () => SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: LOGIN,
      page: () => Login(),
      transition: Transition.size,
    ),
    GetPage(
      name: BOTTOM_NAV,
      page: () => CustomBottomNav(),
      transition: Transition.size,
    ),
    GetPage(
      name: CHANGE_PASSWORD,
      page: () => ChangePassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: EDIT_APAR,
      page: () => EditApar(),
      transition: Transition.rightToLeft,
    ),
  ];
}
