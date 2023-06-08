part of 'hydran_cubit.dart';

@immutable
abstract class HydranState {}

class HydranInitial extends HydranState {}

class HydranLoading extends HydranState {}

class HydranAccuracy extends HydranState {
  final double? accuracy;

  HydranAccuracy({this.accuracy});
}

class HydranLoaded extends HydranState {
  final int? statusCode;
  dynamic json;

  HydranLoaded({this.statusCode, this.json});
}
