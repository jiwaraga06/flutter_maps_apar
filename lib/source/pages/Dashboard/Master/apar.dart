import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/editapar.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:flutter_maps_apar/source/services/Master/Apar/cubit/apar_cubit.dart';
import 'package:flutter_maps_apar/source/services/Master/Apar/cubit/editapar_cubit.dart';
import 'package:flutter_maps_apar/source/services/Master/Apar/cubit/jenisapar_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class Apar extends StatefulWidget {
  const Apar({super.key});

  @override
  State<Apar> createState() => _AparState();
}

class _AparState extends State<Apar> {
  bool isService = false;
  bool changePosition = false;
  var valuejenis = "Powder";
  var valuejenisId = "3";

  void save(uuid, oldLatiApar, oldLongiApar) {
    BlocProvider.of<EditaparCubit>(context).putmasterapar(uuid, isService == true ? 1 : 0, valuejenisId, changePosition, oldLatiApar, oldLongiApar);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AparCubit>(context).initial();
    // BlocProvider.of<JenisaparCubit>(context).getjenisapar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<AparCubit, AparState>(
        builder: (context, state) {
          if (state is AparLoading) {
            return Container();
          }
          if (state is AparLoaded == false) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<AparCubit>(context).scanapar(context);
              },
              backgroundColor: color2,
              child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
            );
          }
          var json = (state as AparLoaded).json;
          if (json.isEmpty) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<AparCubit>(context).scanapar(context);
              },
              backgroundColor: color2,
              child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
            );
          }
          return Container();
        },
      ),
      body: BlocListener<EditaparCubit, EditaparState>(
        // SAVE EDIT APAR
        listener: (context, state) async {
          if (state is EditaparLoading) {
            EasyLoading.show();
          }
          if (state is EditaparAkurasi) {
            var akurasi = state.accuracy;
            if (akurasi! > 20) {
              EasyLoading.dismiss();
              MyDialog.dialogAlert(context, 'Akurasi anda : $akurasi\nAkurasi tidak boleh lebih dari 20m');
              BlocProvider.of<AparCubit>(context).initial();
            } else {
              // BlocProvider.of<AparCubit>(context).initial();
            }
          }
          if (state is EditaparLoaded) {
            EasyLoading.dismiss();
            var json = state.json;
            var statusCode = state.statusCode;
            if (statusCode == 200) {
              MyDialog.dialogSuccess(context, json['message']);
              BlocProvider.of<AparCubit>(context).initial();
            } else {
              MyDialog.dialogAlert(context, json['message']);
            }
          }
        },
        child: BlocConsumer<AparCubit, AparState>(
          listener: (context, state) {
            if (state is AparLoaded) {
              BlocProvider.of<JenisaparCubit>(context).getjenisapar();
              var json = state.json;
              if (json['isService'] == 1) {
                setState(() {
                  isService = !isService;
                });
              } else {
                setState(() {
                  isService = !isService;
                });
              }
            }
          },
          // GET RESULT SCAN APAR
          builder: (context, state) {
            if (state is AparLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AparLoaded == false) {
              return Container();
            }
            var json = (state as AparLoaded).json;
            var statusCode = (state as AparLoaded).statusCode;

            if (statusCode == 0 && json.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Silahkan Pindai QR Apar', style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            } else if (json.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Silahkan Pindai QR Apar', style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }
            // ACCURACY
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(90),
                      1: FixedColumnWidth(15),
                    },
                    children: [
                      TableRow(children: [
                        const Text('Nama Apar', style: TextStyle(fontSize: 16)),
                        const Text(':', style: TextStyle(fontSize: 16)),
                        Text(json['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      TableRow(children: [
                        const Text('Expired', style: TextStyle(fontSize: 16)),
                        const Text(':', style: TextStyle(fontSize: 16)),
                        Text(json['expired_date'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      TableRow(children: [
                        const Text('Ket. Status', style: TextStyle(fontSize: 16)),
                        const Text(':', style: TextStyle(fontSize: 16)),
                        if (json['aktif'] == 1) Text("Aktif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[600])),
                        if (json['aktif'] == 0) Text("Tidak Aktif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[600])),
                        if (json['aktif'] == null) Text("Tidak Aktif", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[600])),
                      ]),
                      TableRow(children: [
                        const Text('Ket. Service', style: TextStyle(fontSize: 16)),
                        const Text(':', style: TextStyle(fontSize: 16)),
                        if (json['isService'] == 1)
                          Text("Sudah Service", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[600])),
                        if (json['isService'] == 0) Text("Belum Service", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[600])),
                        if (json['isService'] == null)
                          Text("Belum Service", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[600])),
                      ]),
                      TableRow(children: [
                        const Text('Kapasitas', style: TextStyle(fontSize: 16)),
                        const Text(':', style: TextStyle(fontSize: 16)),
                        Text("${json['kapasitas'].toString()} Kg", style: const TextStyle(fontSize: 16)),
                      ]),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 12.0),
                  child: Text('Jenis', style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 12.0, right: 8.0),
                  child: BlocConsumer<JenisaparCubit, JenisaparState>(
                    listener: (context, state) {
                      if (state is JenisaparLoaded) {
                        var jenis = state.json;
                        print('JENIS');
                        print(jenis.where((element) => element['id'] == json['id_jenis']).toList());
                        var value = jenis.where((element) => element['id'] == json['id_jenis']).toList()[0]['nama'];
                        var valueid = jenis.where((element) => element['id'] == json['id_jenis']).toList()[0]['id'];
                        setState(() {
                          valuejenis = value;
                          valueid = valueid;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is JenisaparLoading) {
                        return Container();
                      }
                      if (state is JenisaparLoaded == false) {
                        return Container();
                      }
                      List list = (state as JenisaparLoaded).json;
                      // print('FIRST: ${list.first['nama']}');
                      return DropdownButton(
                        value: valuejenis,
                        isExpanded: true,
                        hint: Text('Pilih Jenis Apar'),
                        items: list.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['nama']),
                            value: e['nama'],
                            onTap: () {
                              print(e);
                              valuejenisId = e['id'].toString();
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            valuejenis = value.toString();
                          });
                        },
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 12.0),
                  child: Text('Status Service', style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
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
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 12.0),
                  child: Text('Status Koordinat', style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (changePosition == true) const Text('Ganti Koordinat', style: TextStyle(fontSize: 17)),
                      if (changePosition == false) const Text('Tetapkan Koordinat', style: TextStyle(fontSize: 17)),
                      FlutterSwitch(
                        activeColor: color2,
                        inactiveColor: colorBtnCancel,
                        width: 125.0,
                        height: 35.0,
                        valueFontSize: 16.0,
                        toggleSize: 25.0,
                        value: changePosition,
                        borderRadius: 30.0,
                        onToggle: (val) {
                          setState(() {
                            changePosition = val;
                            print("Koordinat: $val");
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
                    text: 'SUBMIT',
                    textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    onTap: json['aktif'] == 1
                        ? () {
                            save(json['uuid'], json['lati'], json['longi']);
                          }
                        : null,
                  ),
                )
              ],
            );
          },
        ),
      ),
      // body: BlocBuilder<AparCubit, AparState>(
      //   builder: (context, state) {
      //     if (state is AparLoading) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     if (state is AparLoaded == false) {
      //       return Container();
      //     }
      //     var json = (state as AparLoaded).json;
      //     var statusCode = (state as AparLoaded).statusCode;
      //     if (json.isEmpty) {
      //       return InkWell(
      //         onTap: () {
      //           BlocProvider.of<AparCubit>(context).getmasterapar();
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
      //         BlocProvider.of<AparCubit>(context).getmasterapar();
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
      //                           const Text('Expired', style: TextStyle(fontSize: 16)),
      //                           const Text(':', style: TextStyle(fontSize: 16)),
      //                           Text(data['expired_date'], style: const TextStyle(fontWeight: FontWeight.bold)),
      //                         ],
      //                       ),
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
      //                       TableRow(
      //                         children: [
      //                           const Text('Kapasitas', style: TextStyle(fontSize: 16)),
      //                           const Text(':', style: TextStyle(fontSize: 16)),
      //                           Text("${data['kapasitas'].toString()} Kg", style: const TextStyle(fontSize: 16)),
      //                         ],
      //                       ),
      //                       TableRow(
      //                         children: [
      //                           const Text('Jenis', style: TextStyle(fontSize: 16)),
      //                           const Text(':', style: TextStyle(fontSize: 16)),
      //                           Text(data['jenis']['nama'].toString(), style: const TextStyle(fontSize: 16)),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 CustomButton(
      //                   color: basic,
      //                   text: 'EDIT',
      //                   textStyle: const TextStyle(color: Colors.white, fontSize: 16),
      //                   onTap: () {
      //                     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //                       return EditApar(id: data['id'], isService: data['isService']);
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
