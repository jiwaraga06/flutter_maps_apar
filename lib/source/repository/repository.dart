import 'package:flutter_maps_apar/source/network/network.dart';

class MyRepository {
  final MyNetwork? myNetwork;

  MyRepository({required this.myNetwork});

  Future login(username, password, deviceid) async {
    var json = await myNetwork!.login(username, password, deviceid);
    return json;
  }

  Future logout(username) async {
    var json = await myNetwork!.logout(username);
    return json;
  }

  Future changePassword(username, password, newPassword) async {
    var json = await myNetwork!.changePassword(username, password, newPassword);
    return json;
  }
}
