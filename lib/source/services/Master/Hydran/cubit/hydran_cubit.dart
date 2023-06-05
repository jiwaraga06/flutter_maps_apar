import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  void initial() {
    emit(HydranId(idHydran: null));
  }

  void scanhydran() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#332FD0', 'Cancel', true, ScanMode.QR);
      print('Result: $barcodeScanRes');
      emit(HydranLoading());
      // if (barcodeScanRes == '-1') {
      //   EasyLoading.showInfo('Di Batalkan');
      // } else {
      emit(HydranId(idHydran: barcodeScanRes));
      // }
    } on PlatformException {
      EasyLoading.showError('Failed to get Platform version .');
    }
  }
}
