import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/network/network.dart';
import 'package:flutter_maps_apar/source/pages/Maps/maps.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/router/router.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/auth_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/change_pass_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/profile_cubit.dart';
import 'package:flutter_maps_apar/source/services/users/cubit/insertask_cubit.dart';
import 'package:flutter_maps_apar/source/services/users/cubit/scanqr_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'source/services/Auth/cubit/tabbar_cubit.dart';

void main() {
  runApp(MyApp(
    router: RouterNavigation(),
    myRepository: MyRepository(myNetwork: MyNetwork()),
  ));
}

class MyApp extends StatelessWidget {
  final RouterNavigation? router;
  final MyRepository? myRepository;
  const MyApp({Key? key, this.myRepository, this.router}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData buildTheme(brightness) {
      var baseTheme = ThemeData(
        brightness: brightness,
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      );
      return baseTheme.copyWith(
        appBarTheme: AppBarTheme(
          elevation: 6.0,
          backgroundColor: scaffoldColor,
          surfaceTintColor: scaffoldColor,
        ),
        
        textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => TabbarCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(myRepository: myRepository),
        ),
        BlocProvider(
          create: (context) => ChangePassCubit(myRepository: myRepository),
        ),
        BlocProvider(
          create: (context) => InsertaskCubit(myRepository: myRepository),
        ),
        BlocProvider(
          create: (context) => ScanqrCubit(myRepository: myRepository),
        ),
      ],
      child: GetMaterialApp(
        theme: buildTheme(Brightness.light),
        debugShowCheckedModeBanner: false,
        initialRoute: SPLASH,
        getPages: RouterNavigation.pages,
        builder: EasyLoading.init(
          builder: (context, child) {
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            );
          },
        ),
      ),
    );
  }
}
