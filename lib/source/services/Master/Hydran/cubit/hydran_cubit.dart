import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void initial() {
    emit(HydranLoaded(statusCode: 0, json: {}));
  }

  var latiHydran, longiHydran;
  void scanhydran(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var radius = int.parse(pref.getString('radius').toString());
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
          if (inisial != 'H') {
            MyDialog.dialogAlert(context, 'QR Code Hydran Tidak Sesuai');
          } else {
            myRepository!.getmasterhydranedit(ref).then((value) async {
              var json = jsonDecode(value.body);
              var statusCode = value.statusCode;
              print('JSON: $json');
              if (json.isNotEmpty) {
                latiHydran = json['lati'];
                longiHydran = json['longi'];
              }
              EasyLoading.show();

              var latitude = position.latitude;
              var longitude = position.longitude;
              var akurasi = position.accuracy;
              EasyLoading.dismiss();
              print('Latitude: $latitude, Longitude: $longitude, accuracy: $akurasi');
              if (json['lati'] == null && json['longi'] == null) {
                if (akurasi > 20) {
                  MyDialog.dialogAlert(context, 'Akurasi anda : $akurasi\nAkurasi tidak boleh lebih dari 20 m');
                } else {
                  emit(HydranLoading());
                  emit(HydranLoaded(statusCode: statusCode, json: json));
                }
              } else {
                var distance = Geolocator.distanceBetween(latiHydran, longiHydran, latitude, longitude);
                print('Distance: $distance');

                if (akurasi > 20) {
                  if (distance >= radius) {
                    MyDialog.dialogAlert(context, 'Akurasi dan Jarak Anda terlalu jauh\nAkurasi : $akurasi\nJarak : $distance');
                  } else {
                    MyDialog.dialogAlert(context, 'Akurasi anda : $akurasi\nAkurasi tidak boleh lebih dari 20 m');
                  }
                } else {
                  if (distance >= radius) {
                    MyDialog.dialogAlert(context, 'Jarak Anda : $distance\nJarak tidak boleh lebih dari $radius m');
                  } else {
                    emit(HydranLoading());
                    emit(HydranLoaded(statusCode: statusCode, json: json));
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
