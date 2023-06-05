part of 'hydran_cubit.dart';

@immutable
abstract class HydranState {}

class HydranInitial extends HydranState {}

class HydranLoading extends HydranState {}

class HydranId extends HydranState {
  final String? idHydran;

  HydranId({this.idHydran});
}

class HydranLoaded extends HydranState {
  final int? statusCode;
  dynamic json;

  HydranLoaded({this.statusCode, this.json});
}
