import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/services/Master/Hydran/cubit/hydran_cubit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'edithydran_state.dart';

class EdithydranCubit extends Cubit<EdithydranState> {
  final MyRepository? myRepository;
  EdithydranCubit({required this.myRepository}) : super(EdithydranInitial());

  void putmasterhydran(uuid, isService, changePosition, oldLatiHydran, oldLongiHydran) async {
    emit(EdithydranLoading());
    if (changePosition == false) {
      var body = {
        "isService": "$isService",
        "latitude": "$oldLatiHydran",
        "longitude": "$oldLongiHydran",
        // "latitude": "-7.049509",
        // "longitude": "107.746819",
      };
      print("Body Koordinat false: $body");
      myRepository!.putmasterhydran(uuid, jsonEncode(body)).then((value) {
        var json = jsonDecode(value.body);
        var statusCode = value.statusCode;
        print('Put Hydran: $json');
        emit(EdithydranLoaded(statusCode: statusCode, json: json));
      });
    } else {
      await Geolocator.getCurrentPosition().then((position) {
        var latitude = position.latitude;
        var longitude = position.longitude;
        var akurasi = position.accuracy;
        print("Latitude: $latitude, Longitude: $longitude, Akurasi: $akurasi");
        var body = {
          "isService": "$isService",
          "latitude": "$latitude",
          "longitude": "$longitude",
          // "latitude": "-7.049509",
          // "longitude": "107.746819",
        };
        print("Body Koordinat true: $body");
        emit(EdithydranAkurasi(accuracy: akurasi));
        if (akurasi <= 20.0) {
          myRepository!.putmasterhydran(uuid, jsonEncode(body)).then((value) {
            var json = jsonDecode(value.body);
            var statusCode = value.statusCode;
            print('Put Hydran: $json');
            emit(EdithydranLoaded(statusCode: statusCode, json: json));
          });
        }
      });
    }
  }
}
