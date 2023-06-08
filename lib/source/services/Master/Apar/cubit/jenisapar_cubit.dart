import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'jenisapar_state.dart';

class JenisaparCubit extends Cubit<JenisaparState> {
  final MyRepository? myRepository;
  JenisaparCubit({required this.myRepository}) : super(JenisaparInitial());

  void getjenisapar() async {
    emit(JenisaparLoading());
    myRepository!.getjenisapar().then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('JSON: $json');
      emit(JenisaparLoaded(statusCode: statusCode, json: json));
    });
  }
}
