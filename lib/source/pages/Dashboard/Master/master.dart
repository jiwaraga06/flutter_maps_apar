import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/apar.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/hydran.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Master'),
            bottom: const TabBar(
              labelStyle: TextStyle(color: Colors.black, fontSize: 18),
              tabs: [
                Tab(text: 'Apar'),
                Tab(text: 'Hydran'),
              ],
            ),
          ),
          body: const TabBarView(children: [
            Apar(),
            Hydran(),
          ])),
    );
  }
}
