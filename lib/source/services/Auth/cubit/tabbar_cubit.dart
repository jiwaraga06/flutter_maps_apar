import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tabbar_state.dart';

class TabbarCubit extends Cubit<TabbarState> {
  TabbarCubit() : super(TabbarInitial());
  void getRole() async {
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    print('Role: ${pref.getString('user_roles')}');
    emit(TabbarLoaded(json: pref.getString('user_roles')));
  }
}
