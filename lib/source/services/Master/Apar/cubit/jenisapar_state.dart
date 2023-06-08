part of 'jenisapar_cubit.dart';

@immutable
abstract class JenisaparState {}

class JenisaparInitial extends JenisaparState {}

class JenisaparLoading extends JenisaparState {}

class JenisaparLoaded extends JenisaparState {
  final int? statusCode;
  dynamic json;

  JenisaparLoaded({this.statusCode, this.json});
}
