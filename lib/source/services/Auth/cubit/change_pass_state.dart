part of 'change_pass_cubit.dart';

@immutable
abstract class ChangePassState {}

class ChangePassInitial extends ChangePassState {}

class ChangePassLoading extends ChangePassState {}

class ChangePassLoaded extends ChangePassState {
  final int? statusCode;
  dynamic json;

  ChangePassLoaded({this.statusCode, this.json});
}
