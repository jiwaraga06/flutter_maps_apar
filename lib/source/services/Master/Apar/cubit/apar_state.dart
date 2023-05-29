part of 'apar_cubit.dart';

@immutable
abstract class AparState {}

class AparInitial extends AparState {}

class AparLoading extends AparState {}

class AparLoaded extends AparState {
  final int? statusCode;
  dynamic json;

  AparLoaded({this.statusCode, this.json});
}
