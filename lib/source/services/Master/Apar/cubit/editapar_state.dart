part of 'editapar_cubit.dart';

@immutable
abstract class EditaparState {}

class EditaparInitial extends EditaparState {}

class EditaparLoading extends EditaparState {}

class EditaparLoaded extends EditaparState {
  final int? statusCode;
  dynamic json;

  EditaparLoaded({required this.statusCode, this.json});
}
