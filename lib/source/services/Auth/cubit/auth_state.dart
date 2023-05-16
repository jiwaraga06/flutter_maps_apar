part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSplashLoading extends AuthState {}

class AuthSplashLoaded extends AuthState {}

class LoginLoading extends AuthState {}

class LoginLoaded extends AuthState {
  final int? statusCode;
  dynamic json;

  LoginLoaded({this.statusCode, this.json});
}

class LogoutLoading extends AuthState {}

class LogoutLoaded extends AuthState {
  final int? statusCode;
  dynamic json;

  LogoutLoaded({this.statusCode, this.json});
}
