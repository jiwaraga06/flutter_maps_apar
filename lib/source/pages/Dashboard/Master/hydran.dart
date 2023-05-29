import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/Master/edithydran.dart';
import 'package:flutter_maps_apar/source/services/Master/Hydran/cubit/hydran_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';

class Hydran extends StatefulWidget {
  const Hydran({super.key});

  @override
  State<Hydran> createState() => _HydranState();
}

class _HydranState extends State<Hydran> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HydranCubit>(context).getmasterhydran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HydranCubit, HydranState>(
        builder: (context, state) {
          if (state is HydranLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HydranLoaded == false) {
            return Container();
          }
          var json = (state as HydranLoaded).json;
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<HydranCubit>(context).getmasterhydran();
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
                        ? const Text("")
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
                                const Text('Status', style: TextStyle(fontSize: 16)),
                                const Text(':', style: TextStyle(fontSize: 16)),
                                if (data['aktif'] == 1) const Text("Aktif", style: TextStyle(fontSize: 16)),
                                if (data['aktif'] == 0) const Text("Tidak Aktif", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        color: basic,
                        text: 'EDIT',
                        textStyle: TextStyle(color: Colors.white, fontSize: 16),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return EditHydran(id: data['id'], isService: data['isService']);
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
