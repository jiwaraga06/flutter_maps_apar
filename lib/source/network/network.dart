import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/network/api.dart';
import 'package:http/http.dart' as http;

class MyNetwork {
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
}
