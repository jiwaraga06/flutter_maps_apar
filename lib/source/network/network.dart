import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/network/api.dart';
import 'package:http/http.dart' as http;

class MyNetwork {
  Future getradius() async {
    try {
      var url = Uri.parse(MyApi.getradius());
      var response = await http.get(url, headers: {'Authorization': TOKEN});
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future login(username, password, deviceid) async {
    try {
      var url = Uri.parse(MyApi.login(username, password, deviceid));
      var response = await http.post(url, headers: {
        'Authorization': TOKEN,
        'Accept': 'application/json',
      });
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future logout(username) async {
    try {
      var url = Uri.parse(MyApi.logout(username));
      var response = await http.post(url, headers: {
        'Authorization': TOKEN,
        'Accept': 'application/json',
      });
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future changePassword(username, password, newPassword) async {
    try {
      var url = Uri.parse(MyApi.changePassword(username, password, newPassword));
      var response = await http.post(url, headers: {
        'Authorization': TOKEN,
        'Accept': 'application/json',
      });
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future scanqr(ref, inisial) async {
    try {
      var url = Uri.parse(MyApi.scanqr(ref, inisial));
      var response = await http.post(url, headers: {
        'Authorization': TOKEN,
        'Accept': 'application/json',
      });
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  // APAR

  Future getjenisapar() async {
    try {
      var url = Uri.parse(MyApi.getjenisapar());
      var response = await http.get(url, headers: {'Authorization': TOKEN});
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future insertTask(body) async {
    try {
      var url = Uri.parse(MyApi.insertTask());
      var response = await http.post(url,
          headers: {
            'Authorization': TOKEN,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future getmasterapar() async {
    try {
      var url = Uri.parse(MyApi.getmasterapar());
      var response = await http.get(url, headers: {'Authorization': TOKEN});
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future getmasteraparedit(ref) async {
    try {
      var url = Uri.parse(MyApi.getmasteraparedit(ref));
      var response = await http.get(url, headers: {'Authorization': TOKEN});
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future getmasterhydran() async {
    try {
      var url = Uri.parse(MyApi.getmasterhydran());
      var response = await http.get(url, headers: {'Authorization': TOKEN});
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future getmasterhydranedit(ref) async {
    try {
      var url = Uri.parse(MyApi.getmasterhydranedit(ref));
      var response = await http.get(url, headers: {'Authorization': TOKEN});
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future putmasterapar(id, body) async {
    try {
      var url = Uri.parse(MyApi.putmasterapar(id));
      var response = await http.put(url,
          headers: {
            'Authorization': TOKEN,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }

  Future putmasterhydran(id, body) async {
    try {
      var url = Uri.parse(MyApi.putmasterhydran(id));
      var response = await http.put(url,
          headers: {
            'Authorization': TOKEN,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n Jaringan lemah', duration: const Duration(seconds: 2));
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('Masalah Koneksi \n data mati', duration: const Duration(seconds: 2));
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message, duration: const Duration(seconds: 2));
    } on Error catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 2));
    }
  }
}
