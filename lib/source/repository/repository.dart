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

  Future scanqr(ref, inisial) async {
    var json = await myNetwork!.scanqr(ref, inisial);
    return json;
  }

  Future insertTask(body) async {
    var json = await myNetwork!.insertTask(body);
    return json;
  }

  Future getmasterapar() async {
    var json = await myNetwork!.getmasterapar();
    return json;
  }

  Future putmasterapar(id, body) async {
    var json = await myNetwork!.putmasterapar(id, body);
    return json;
  }

  Future getmasterhydran() async {
    var json = await myNetwork!.getmasterhydran();
    return json;
  }

  Future putmasterhydran(id, body) async {
    var json = await myNetwork!.putmasterhydran(id, body);
    return json;
  }
}
