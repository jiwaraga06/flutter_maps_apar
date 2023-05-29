import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'hydran_state.dart';

class HydranCubit extends Cubit<HydranState> {
  final MyRepository? myRepository;
  HydranCubit({required this.myRepository}) : super(HydranInitial());

  void getmasterhydran() async {
    emit(HydranLoading());
    myRepository!.getmasterhydran().then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Hydran: $json');
      emit(HydranLoaded(statusCode: statusCode, json: json));
    });
  }

  void putmasterhydran(id, isService) async {
    var body = {"isService": "$isService"};
    print("Body: $body");
    emit(HydranLoading());
    myRepository!.putmasterhydran(id, jsonEncode(body)).then((value) {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('Put Hydran: $json');
      emit(HydranLoaded(statusCode: statusCode, json: json));
    });
  }
}
