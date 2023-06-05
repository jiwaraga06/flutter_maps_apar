part of 'edithydran_cubit.dart';

@immutable
abstract class EdithydranState {}

class EdithydranInitial extends EdithydranState {}

class EdithydranLoading extends EdithydranState {}

class EdithydranAkurasi extends EdithydranState {
  final double? accuracy;

  EdithydranAkurasi({this.accuracy});
}

class EdithydranLoaded extends EdithydranState {
  final int? statusCode;
  dynamic json;

  EdithydranLoaded({this.statusCode, this.json});
}
