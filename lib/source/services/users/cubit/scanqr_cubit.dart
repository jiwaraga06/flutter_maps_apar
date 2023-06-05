import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'scanqr_state.dart';

class ScanqrCubit extends Cubit<ScanqrState> {
  final MyRepository? myRepository;
  ScanqrCubit({required this.myRepository}) : super(ScanqrInitial());

  Future<void> scanqr(context) async {
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
        // GET DATA TASK
        emit(ScanqrLoading());
        myRepository!.scanqr(ref, inisial).then((value) async {
          var json = jsonDecode(value.body);
          var statusCode = value.statusCode;
          print('JSON: $json');
          print('JSON: $statusCode');
          var task = [];
          if (statusCode == 200) {
            if (json['errors'] != null) {
              EasyLoading.showError('Unit Sedang di Service');
              emit(ScanqrLoaded(statusCode: statusCode, json: json, task: []));
            } else {
              // LOKASI< HITUNG JARAK
              await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((position) async {
                var akurasi = position.accuracy;
                var latitude = position.latitude;
                var longitude = position.longitude;
                print("Longitude: $longitude, Latitude: $latitude, Akurasi: $akurasi");
                var distance = Geolocator.distanceBetween(-7.047529, 107.745991, position.latitude, position.longitude);
                print('Distance: $distance');
                emit(ScanqrAkurasi(accuracy: akurasi));
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
    } on PlatformException {
      EasyLoading.showError('Failed to get Platform version .');
    }
  }

  void inisialisasi() {
    emit(ScanqrLoaded(json: {}, task: {}));
  }
}
