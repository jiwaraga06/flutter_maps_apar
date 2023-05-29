import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/editapar.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:flutter_maps_apar/source/services/Master/Apar/cubit/apar_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:get/get.dart';

class Apar extends StatefulWidget {
  const Apar({super.key});

  @override
  State<Apar> createState() => _AparState();
}

class _AparState extends State<Apar> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AparCubit>(context).getmasterapar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AparCubit, AparState>(
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
          if (json.isEmpty) {
            return InkWell(
              onTap: () {
                BlocProvider.of<AparCubit>(context).getmasterapar();
              },
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Data kosong"),
                    Text("Ketuk Layar untuk Refresh"),
                  ],
                ),
              ),
            );
          }
          if (statusCode != 200) {
            return Container();
          }
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<AparCubit>(context).getmasterapar();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: json.length,
              itemBuilder: (BuildContext context, int index) {
                var data = json[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTileCard(
                    baseColor: Colors.white,
                    expandedColor: Colors.white,
                    title: Text(data['nama'], style: const TextStyle(fontSize: 16)),
                    subtitle: data['isService'] == null
                        ? Container()
                        : data['isService'] == 0
                            ? const Text("Belum di Service")
                            : const Text("Sudah di Service"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(90),
                            1: FixedColumnWidth(15),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Text('Expired', style: TextStyle(fontSize: 16)),
                                const Text(':', style: TextStyle(fontSize: 16)),
                                Text(data['expired_date'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text('Status', style: TextStyle(fontSize: 16)),
                                const Text(':', style: TextStyle(fontSize: 16)),
                                if (data['aktif'] == 1) const Text("Aktif", style: TextStyle(fontSize: 16)),
                                if (data['aktif'] == 0) const Text("Tidak Aktif", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text('Kapasitas', style: TextStyle(fontSize: 16)),
                                const Text(':', style: TextStyle(fontSize: 16)),
                                Text("${data['kapasitas'].toString()} Kg", style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text('Jenis', style: TextStyle(fontSize: 16)),
                                const Text(':', style: TextStyle(fontSize: 16)),
                                Text(data['jenis']['nama'].toString(), style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        color: basic,
                        text: 'EDIT',
                        textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return EditApar(id: data['id'], isService: data['isService']);
                          }));
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
