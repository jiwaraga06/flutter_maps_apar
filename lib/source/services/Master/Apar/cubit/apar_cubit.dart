import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:geolocator/geolocator.dart';
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

  void initial() {
    emit(AparLoaded(statusCode: 0, json: {}));
  }

  void scanapar(context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#332FD0', 'Cancel', true, ScanMode.QR);
      print('Result: $barcodeScanRes');

      // if (barcodeScanRes == '-1') {
      //   EasyLoading.showInfo('Di Batalkan');
      // } else {
      // emit(AparId(idApar: barcodeScanRes));
      EasyLoading.show();
      await Geolocator.getCurrentPosition().then((position) async {
        var latitude = position.latitude;
        var longitude = position.longitude;
        var akurasi = position.accuracy;
        EasyLoading.dismiss();
        print('Latitude: $latitude, Longitude: $longitude, accuracy: $akurasi');
        var distance = Geolocator.distanceBetween(-7.0492847, 107.7465008, position.latitude, position.longitude);
        print('Distance: $distance');

        if (akurasi > 20) {
          if (distance >= 50) {
            MyDialog.dialogAlert(context, 'Akurasi dan Jarak Anda terlalu jauh\nAkurasi : $akurasi\nJarak : $distance');
          } else {
            MyDialog.dialogAlert(context, 'Akurasi anda : $akurasi\nAkurasi tidak boleh lebih dari 20 m');
          }
        } else {
          if (distance >= 50) {
            MyDialog.dialogAlert(context, 'Jarak Anda : $distance\nJarak tidak boleh lebih dari 50 m');
          } else {
            emit(AparLoading());
            myRepository!.getmasteraparedit(14).then((value) {
              var json = jsonDecode(value.body);
              var statusCode = value.statusCode;
              print('JSON: $json');
              emit(AparLoaded(statusCode: statusCode, json: json));
            });
          }
        }
      });
      // }
    } on PlatformException {
      EasyLoading.showError('Failed to get Platform version .');
    }
  }
}
