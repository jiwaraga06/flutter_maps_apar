import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void getProfile() async {
    emit(ProfileLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var body = {
      'username': pref.getString('username'),
      'nama': pref.getString('nama'),
      'user_roles': pref.getString('user_roles'),
      'gender': pref.getString('gender'),
    };
    emit(ProfileLoaded(json: body));
  }
}
