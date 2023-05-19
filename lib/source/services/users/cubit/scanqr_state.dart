part of 'scanqr_cubit.dart';

@immutable
abstract class ScanqrState {}

class ScanqrInitial extends ScanqrState {}

class ScanqrLoading extends ScanqrState {}

class ScanqrLoaded extends ScanqrState {
  final int? statusCode;
  dynamic json;
  dynamic task;

  ScanqrLoaded({this.statusCode, this.json, this.task});
}
