import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/repository/repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'insertask_state.dart';

class InsertaskCubit extends Cubit<InsertaskState> {
  final MyRepository? myRepository;
  InsertaskCubit({required this.myRepository}) : super(InsertaskInitial());

  void saveTask(ref, inisial, datalist, datatask) async {
    emit(InsertaskLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username');
    DateTime date = DateTime.now();
    var tanggal = date.toString().split(' ')[0];

    if (datalist.isEmpty) {
      EasyLoading.showError("Belum ada yang diperiksa", duration: const Duration(seconds: 2));
    } else if (datalist.length != datatask.length) {
      EasyLoading.showError("Task Belum Terisi Semua", duration: const Duration(seconds: 2));
    } else {
    var body = {
      "tanggal": "$tanggal",
      "user": "$username",
      "references": "$ref",
      "initial": "$inisial",
      "data_list": datalist,
    };
    print("Body: $body");
      myRepository!.insertTask(jsonEncode(body)).then((value) {
        var json = jsonDecode(value.body);
        var statusCode = value.statusCode;
        print('Result statusCode: $statusCode');
        print('Result Insert: $json');
        emit(InsertaskLoaded(statusCode: statusCode, json: json));
      });
    }
  }
}
