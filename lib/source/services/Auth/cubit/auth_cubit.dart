import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final MyRepository? myRepository;
  AuthCubit({required this.myRepository}) : super(AuthInitial());

  void splashScreen(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username');
    await Future.delayed(Duration(seconds: 2));
    if (username == null) {
      Navigator.pushNamedAndRemoveUntil(context, LOGIN, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, BOTTOM_NAV, (route) => false);
    }
  }

  void login(context, username, password) async {
    emit(LoginLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var device_uuid;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      print("IOS: ${iosDeviceInfo.identifierForVendor}");
      device_uuid = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print("Android: ${androidDeviceInfo.id}");
      device_uuid = androidDeviceInfo.id;
    }
    myRepository!.login(username, password, device_uuid).then((value) async {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print(json);
      emit(LoginLoaded(statusCode: statusCode, json: json));
      if (statusCode == 200 && json['message'] == 'Berhasil login') {
        pref.setString('username', json['data']['username']);
        pref.setString('nama', json['data']['nama']);
        pref.setString('gender', json['data']['gender']);
        pref.setString('user_roles', jsonEncode(json['data']['user_roles']));
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(context, BOTTOM_NAV, (route) => false);
      }
    });
  }

  void logout(username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    emit(LogoutLoading());
    myRepository!.logout(username).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print(json);
      emit(LogoutLoaded(statusCode: statusCode, json: json));
      if (statusCode == 200) {
        pref.clear();
      }
    });
  }
}
