import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'edithydran_state.dart';

class EdithydranCubit extends Cubit<EdithydranState> {
  final MyRepository? myRepository;
  EdithydranCubit({required this.myRepository}) : super(EdithydranInitial());
  void putmasterhydran(id, isService) async {
    var body = {"isService": "$isService"};
    print("Body: $body");
    emit(EdithydranLoading());
    myRepository!.putmasterhydran(id, jsonEncode(body)).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Put Hydran: $json');
      emit(EdithydranLoaded(statusCode: statusCode, json: json));
    });
  }
}