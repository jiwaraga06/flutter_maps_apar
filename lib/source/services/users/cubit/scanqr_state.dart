part of 'scanqr_cubit.dart';

@immutable
abstract class ScanqrState {}

class ScanqrInitial extends ScanqrState {}

class ScanqrLoading extends ScanqrState {}

class ScanqrAkurasi extends ScanqrState {
  final double? accuracy;

  ScanqrAkurasi({this.accuracy});
}

class ScanqrLoaded extends ScanqrState {
  final int? statusCode;
  final String? jenisQR;
  dynamic json;
  dynamic task;

  ScanqrLoaded({this.statusCode, this.json, this.task, this.jenisQR});
}
