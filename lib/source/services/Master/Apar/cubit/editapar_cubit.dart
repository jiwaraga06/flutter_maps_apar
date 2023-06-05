import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'editapar_state.dart';

class EditaparCubit extends Cubit<EditaparState> {
  final MyRepository? myRepository;
  EditaparCubit({required this.myRepository}) : super(EditaparInitial());

  void putmasterapar(id, isService) async {
    emit(EditaparLoading());
    await Geolocator.getCurrentPosition().then((position) {
      var latitude = position.latitude;
      var longitude = position.longitude;
      var akurasi = position.accuracy;
      print("Latitude: $latitude, Longitude: $longitude, Akurasi: $akurasi");
      // var body = {"isService": "$isService", "lati": position.latitude, "longi": position.longitude};
      var body = {"isService": "$isService"};
      print("Body: $body");
      emit(EditaparAkurasi(accuracy: akurasi));
      if (akurasi <= 20.0) {
        myRepository!.putmasterapar(id, jsonEncode(body)).then((value) {
          var json = jsonDecode(value.body);
          var statusCode = value.statusCode;
          print('Put Apar: $json');
          emit(EditaparLoaded(statusCode: statusCode, json: json));
        });
      }
    });
  }
}
