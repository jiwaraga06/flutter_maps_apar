import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'editapar_state.dart';

class EditaparCubit extends Cubit<EditaparState> {
  final MyRepository? myRepository;
  EditaparCubit({required this.myRepository}) : super(EditaparInitial());

  void putmasterapar(id, isService) async {
    var body = {"isService": "$isService"};
    print("Body: $body");
    emit(EditaparLoading());
    myRepository!.putmasterapar(id, jsonEncode(body)).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Put Apar: $json');
      emit(EditaparLoaded(statusCode: statusCode, json: json));
    });
  }
}
