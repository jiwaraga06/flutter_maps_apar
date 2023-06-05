part of 'insertask_cubit.dart';

@immutable
abstract class InsertaskState {}

class InsertaskInitial extends InsertaskState {}

class InsertaskLoading extends InsertaskState {}

class InsertaskAkurasi extends InsertaskState {
  final double? accuracy;

  InsertaskAkurasi({this.accuracy});
}

class InsertaskLoaded extends InsertaskState {
  final int? statusCode;
  dynamic json;

  InsertaskLoaded({this.statusCode, this.json});
}
