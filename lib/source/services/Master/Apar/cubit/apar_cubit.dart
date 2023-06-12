import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/services/env.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void initial() async {
    emit(AparLoaded(statusCode: 0, json: {}));
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10));
    // Position position = await Geolocator.get
  }

  var latiApar, longiApar;
  void scanapar(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var radius = double.parse(pref.getString('radius').toString());
    print('Radius API : $radius');
    String barcodeScanRes;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation, timeLimit: const Duration(seconds: 20)).then((position) async {
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#332FD0', 'Cancel', true, ScanMode.QR);
        print('Result: $barcodeScanRes');

        if (barcodeScanRes == '-1') {
          EasyLoading.showInfo('Di Batalkan');
        } else {
          // emit(AparId(idApar: barcodeScanRes));
          var ref = barcodeScanRes.split('/')[barcodeScanRes.split('/').length - 2];
          var inisial = barcodeScanRes.split('/')[barcodeScanRes.split('/').length - 1];
          if (inisial != 'A') {
            MyDialog.dialogAlert(context, 'QR Code Apar Tidak Sesuai');
          } else {
            myRepository!.getmasteraparedit(ref).then((value) async {
              var json = jsonDecode(value.body);
              var statusCode = value.statusCode;
              print('JSON apar: $json');
              if (json.isNotEmpty) {
                latiApar = json['lati'];
                longiApar = json['longi'];
              }

              EasyLoading.show();

              var latitude = position.latitude;
              var longitude = position.longitude;
              var akurasi = position.accuracy;
              EasyLoading.dismiss();
              print('Latitude: $latitude, Longitude: $longitude, accuracy: $akurasi');
              if (json['lati'] == null && json['longi'] == null) {
                if (akurasi > ACCURACY) {
                  MyDialog.dialogAlert(context, 'Akurasi anda : $akurasi\nAkurasi tidak boleh lebih dari $ACCURACY m');
                } else {
                  emit(AparLoading());
                  emit(AparLoaded(statusCode: statusCode, json: json));
                }
              } else {
                var distance = Geolocator.distanceBetween(latiApar, longiApar, latitude, longitude);
                print('Distance: $distance');

                if (akurasi > ACCURACY) {
                  if (distance >= radius) {
                    MyDialog.dialogAlert(context, 'Akurasi dan Jarak Anda terlalu jauh\nAkurasi : $akurasi\nJarak : $distance');
                  } else {
                    MyDialog.dialogAlert(context, 'Akurasi anda : $akurasi\nAkurasi tidak boleh lebih dari $ACCURACY m');
                    emit(AparLoaded(statusCode: 0, json: {}));
                  }
                } else {
                  if (distance >= radius) {
                    MyDialog.dialogAlert(context, 'Jarak Anda : $distance\nJarak tidak boleh lebih dari $radius m');
                  } else {
                    emit(AparLoading());
                    emit(AparLoaded(statusCode: statusCode, json: json));
                  }
                }
              }
            });
          }
        }
      } on PlatformException {
        EasyLoading.showError('Failed to get Platform version .');
      }
    });
  }
}
