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

part 'scanqr_state.dart';

class ScanqrCubit extends Cubit<ScanqrState> {
  final MyRepository? myRepository;
  ScanqrCubit({required this.myRepository}) : super(ScanqrInitial());
  var latitude = null;
  var longitude = null;

  Future<void> scanqr(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var radius = int.parse(pref.getString('radius').toString());
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#332FD0', 'Cancel', true, ScanMode.QR);
      print("Result: $barcodeScanRes");
      if (barcodeScanRes == '-1') {
        EasyLoading.showInfo('Di batalkan', duration: const Duration(seconds: 2));
      } else {
        var ref = barcodeScanRes.split('/')[barcodeScanRes.split('/').length - 2];
        var inisial = barcodeScanRes.split('/')[barcodeScanRes.split('/').length - 1];
        print('REF: $ref');
        print('inisial: $inisial');
        EasyLoading.show();
        if (inisial == 'A') {
          myRepository!.getmasteraparedit(ref).then((jsonApar) {
            var json = jsonDecode(jsonApar.body);
            print('Apar\nlat: ${json['lati']}\nlongi: ${json['longi']}');
            if (json['lati'] == null && json['longi'] == null) {
              EasyLoading.dismiss();
              MyDialog.dialogAlert(context, 'Titik Koordinat Belum terpasang');
            } else {
              EasyLoading.dismiss();
              latitude = json['lati'];
              longitude = json['longi'];
              resultTask(radius, ref, inisial, latitude, longitude, context);
            }
          });
        } else if (inisial == 'H') {
          myRepository!.getmasterhydranedit(ref).then((jsonHydran) {
            var json = jsonDecode(jsonHydran.body);
            print('Hydran\nlat: ${json['lati']}\nlongi: ${json['longi']}');
            if (json['lati'] == null && json['longi'] == null) {
              EasyLoading.dismiss();
              MyDialog.dialogAlert(context, 'Titik Koordinat Belum terpasang');
            } else {
              EasyLoading.dismiss();
              latitude = json['lati'];
              longitude = json['longi'];
              resultTask(radius, ref, inisial, latitude, longitude, context);
            }
          });
        }
        // GET DATA TASK
      }
    } on PlatformException {
      EasyLoading.showError('Failed to get Platform version .');
    }
  }

  void inisialisasi() {
    emit(ScanqrLoaded(json: {}, task: {}));
  }

  void resultTask(radius, ref, inisial, lati, longi, context) async {
    myRepository!.scanqr(ref, inisial).then((value) async {
      var json = jsonDecode(value.body);
      var statusCode = value.statusCode;
      print('JSON: $json');
      print('JSON: $statusCode');
      var task = [];
      if (statusCode == 200) {
        EasyLoading.dismiss();
        if (json['errors'] != null) {
          emit(ScanqrLoading());
          EasyLoading.showError('Unit Sedang di Service');
          emit(ScanqrLoaded(statusCode: statusCode, json: json, task: []));
        } else {
          // LOKASI< HITUNG JARAK
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((position) async {
            var akurasi = position.accuracy;
            print("Longitude: $longitude, Latitude: $latitude, Akurasi: $akurasi");
            var distance = Geolocator.distanceBetween(latitude, longitude, position.latitude, position.longitude);
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
                emit(ScanqrLoading());
                json.forEach((key, b) {
                  if (b is Map) {
                    task.add(b);
                    print(task);
                    emit(ScanqrLoaded(statusCode: statusCode, json: json, task: task));
                  } else {
                    emit(ScanqrLoaded(statusCode: statusCode, json: json, task: []));
                  }
                });
              }
            }
          });
        }
      } else {
        EasyLoading.showError(json['message']);
        emit(ScanqrLoaded(statusCode: statusCode, json: json, task: []));
      }
    });
  }
}
