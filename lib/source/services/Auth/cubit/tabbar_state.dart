part of 'tabbar_cubit.dart';

@immutable
abstract class TabbarState {}

class TabbarInitial extends TabbarState {}

class TabbarLoading extends TabbarState {}

class TabbarLoaded extends TabbarState {
  dynamic json;
  TabbarLoaded({this.json});
}
