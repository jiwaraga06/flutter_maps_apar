import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:meta/meta.dart';

part 'scanqr_state.dart';

class ScanqrCubit extends Cubit<ScanqrState> {
  final MyRepository? myRepository;
  ScanqrCubit({required this.myRepository}) : super(ScanqrInitial());

  Future<void> scanqr() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#332FD0', 'Cancel', true, ScanMode.QR);
      print("Result: $barcodeScanRes");
      if (barcodeScanRes == '-1') {
        EasyLoading.showInfo('Di batalkan', duration: const Duration(seconds: 2));
      } else if (barcodeScanRes != '-1') {
        var ref = barcodeScanRes.split('/')[barcodeScanRes.split('/').length - 2];
        var inisial = barcodeScanRes.split('/')[barcodeScanRes.split('/').length - 1];
        emit(ScanqrLoading());
        myRepository!.scanqr(ref, inisial).then((value) {
          var json = jsonDecode(value.body);
          var statusCode = value.statusCode;
          print('Scan QR: $json');
          var task = [];
          if (statusCode == 200) {
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
