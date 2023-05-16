import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'change_pass_state.dart';

class ChangePassCubit extends Cubit<ChangePassState> {
  final MyRepository? myRepository;
  ChangePassCubit({required this.myRepository}) : super(ChangePassInitial());

  void changePass(username, passwordold, passwordnew) async {
    emit(ChangePassLoading());
    myRepository!.changePassword(username, passwordold, passwordnew).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Change Pass: $json');
      emit(ChangePassLoaded(statusCode: statusCode, json: json));
    });
  }
}
