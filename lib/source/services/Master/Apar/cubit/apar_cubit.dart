import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'apar_state.dart';

class AparCubit extends Cubit<AparState> {
  final MyRepository? myRepository;
  AparCubit({required this.myRepository}) : super(AparInitial());

  void getmasterapar() async {
    emit(AparLoading());
    myRepository!.getmasterapar().then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Apar: $json');
      emit(AparLoaded(statusCode: statusCode, json: json));
    });
  }

  void putmasterapar(id, isService) async {
    var body = {"isService": "$isService"};
    print("Body: $body");
    emit(AparLoading());
    myRepository!.putmasterapar(id, jsonEncode(body)).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Put Apar: $json');
      emit(AparLoaded(statusCode: statusCode, json: json));
    });
  }
}
