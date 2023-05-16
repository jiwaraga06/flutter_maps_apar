import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/network/network.dart';
import 'package:flutter_maps_apar/source/pages/Maps/maps.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/router/router.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/auth_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/profile_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/tabbar_cubit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      );
      return baseTheme.copyWith(
        // appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(myRepository: myRepository),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => TabbarCubit(),
        ),
      ],
      child: GetMaterialApp(
        theme: buildTheme(Brightness.light),
        debugShowCheckedModeBanner: false,
        initialRoute: SPLASH,
        getPages: RouterNavigation.pages,
        builder: EasyLoading.init(),
      ),
    );
  }
}
