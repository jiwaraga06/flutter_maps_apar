part of 'apar_cubit.dart';

@immutable
abstract class AparState {}

class AparInitial extends AparState {}

class AparLoading extends AparState {}

class AparId extends AparState {
  final String? idApar;

  AparId({this.idApar});
}

class AparLoaded extends AparState {
  final int? statusCode;
  dynamic json;

  AparLoaded({this.statusCode, this.json});
}
