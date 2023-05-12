import 'package:bloc/bloc.dart';
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
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushNamedAndRemoveUntil(context, LOGIN, (route) => false);
  }
}
