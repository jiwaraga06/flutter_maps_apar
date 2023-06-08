import 'package:flutter_maps_apar/source/network/network.dart';

class MyRepository {
  final MyNetwork? myNetwork;

  MyRepository({required this.myNetwork});

  Future getradius() async {
    var json = await myNetwork!.getradius();
    return json;
  }
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

// APAR
  Future insertTask(body) async {
    var json = await myNetwork!.insertTask(body);
    return json;
  }

  Future getjenisapar() async {
    var json = await myNetwork!.getjenisapar();
    return json;
  }

  Future getmasterapar() async {
    var json = await myNetwork!.getmasterapar();
    return json;
  }

  Future getmasteraparedit(ref) async {
    var json = await myNetwork!.getmasteraparedit(ref);
    return json;
  }

  Future putmasterapar(id, body) async {
    var json = await myNetwork!.putmasterapar(id, body);
    return json;
  }

  // HYDRAN

  Future getmasterhydran() async {
    var json = await myNetwork!.getmasterhydran();
    return json;
  }
  Future getmasterhydranedit(ref) async {
    var json = await myNetwork!.getmasterhydranedit(ref);
    return json;
  }

  Future putmasterhydran(id, body) async {
    var json = await myNetwork!.putmasterhydran(id, body);
    return json;
  }
}
