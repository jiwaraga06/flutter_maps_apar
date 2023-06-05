import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/edithydran.dart';
import 'package:flutter_maps_apar/source/services/Master/Hydran/cubit/edithydran_cubit.dart';
import 'package:flutter_maps_apar/source/services/Master/Hydran/cubit/hydran_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Hydran extends StatefulWidget {
  const Hydran({super.key});

  @override
  State<Hydran> createState() => _HydranState();
}

class _HydranState extends State<Hydran> {
  bool isService = false;

  void save(id) {
    BlocProvider.of<EdithydranCubit>(context).putmasterhydran(id, isService == true ? 1 : 0);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HydranCubit>(context).initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<HydranCubit, HydranState>(
        builder: (context, state) {
          if (state is HydranLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HydranLoaded == false) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<HydranCubit>(context).scanhydran();
              },
              backgroundColor: color2,
              child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
            );
          }
          var idHydran = (state as HydranId).idHydran;
          if (idHydran == null) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<HydranCubit>(context).scanhydran();
              },
              backgroundColor: color2,
              child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
            );
          }
          return Container();
        },
      ),
      body: BlocBuilder<HydranCubit, HydranState>(
        builder: (context, state) {
          if (state is HydranLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HydranId == false) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Silahkan Pindai QR Hydran', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          var idHydran = (state as HydranId).idHydran;
          if (idHydran == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                   Text('Silahkan Pindai QR Hydran', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isService == true) const Text('Sudah Service', style: TextStyle(fontSize: 17)),
                    if (isService == false) const Text('Belum Service', style: TextStyle(fontSize: 17)),
                    FlutterSwitch(
                      activeColor: color2,
                      inactiveColor: colorBtnCancel,
                      width: 125.0,
                      height: 35.0,
                      valueFontSize: 16.0,
                      toggleSize: 25.0,
                      value: isService,
                      borderRadius: 30.0,
                      onToggle: (val) {
                        setState(() {
                          isService = val;
                          print(val);
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 2),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  color: basic,
                  text: 'SAVE',
                  textStyle: const TextStyle(color: Colors.white),
                  onTap: () {
                    save(1);
                  },
                ),
              )
            ],
          );
        },
      ),
      // body: BlocBuilder<HydranCubit, HydranState>(
      //   builder: (context, state) {
      //     if (state is HydranLoading) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     if (state is HydranLoaded == false) {
      //       return Container();
      //     }
      //     var json = (state as HydranLoaded).json;
      //     var statusCode = (state as HydranLoaded).statusCode;
      //     if (json.isEmpty) {
      //       return InkWell(
      //         onTap: () {
      //           BlocProvider.of<HydranCubit>(context).getmasterhydran();
      //         },
      //         child: Container(
      //           alignment: Alignment.center,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Text("Data Kosong"),
      //               Text("Ketuk Layar untuk Refresh"),
      //             ],
      //           ),
      //         ),
      //       );
      //     }
      //     if (statusCode != 200) {
      //       return Container();
      //     }
      //     return RefreshIndicator(
      //       onRefresh: () async {
      //         BlocProvider.of<HydranCubit>(context).getmasterhydran();
      //       },
      //       child: ListView.builder(
      //         physics: const AlwaysScrollableScrollPhysics(),
      //         itemCount: json.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           var data = json[index];
      //           return Container(
      //             margin: const EdgeInsets.all(8.0),
      //             child: ExpansionTileCard(
      //               baseColor: Colors.white,
      //               expandedColor: Colors.white,
      //               title: Text(data['nama'], style: const TextStyle(fontSize: 16)),
      //               subtitle: data['isService'] == null
      //                   ? const Text("Tersedia")
      //                   : data['isService'] == 0
      //                       ? const Text("Tersedia")
      //                       : const Text("Sedang di Service"),
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Table(
      //                     columnWidths: const {
      //                       0: FixedColumnWidth(90),
      //                       1: FixedColumnWidth(15),
      //                     },
      //                     children: [
      //                       TableRow(
      //                         children: [
      //                           const Text('Status', style: TextStyle(fontSize: 16)),
      //                           const Text(':', style: TextStyle(fontSize: 16)),
      //                           if (data['aktif'] == 1) Text("Aktif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[600])),
      //                           if (data['aktif'] == 0)
      //                             Text("Tidak Aktif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[600])),
      //                           if (data['aktif'] == null)
      //                             Text("Tidak Aktif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[600])),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 CustomButton(
      //                   color: basic,
      //                   text: 'EDIT',
      //                   textStyle: TextStyle(color: Colors.white, fontSize: 16),
      //                   onTap: () {
      //                     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //                       return EditHydran(id: data['id'], isService: data['isService']);
      //                     }));
      //                   },
      //                 )
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
