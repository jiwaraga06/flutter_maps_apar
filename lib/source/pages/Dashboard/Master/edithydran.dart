import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/services/Master/Hydran/cubit/edithydran_cubit.dart';
import 'package:flutter_maps_apar/source/services/Master/Hydran/cubit/hydran_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:flutter_switch/flutter_switch.dart';

class EditHydran extends StatefulWidget {
  final int? id, isService;
  const EditHydran({super.key, this.id, this.isService});

  @override
  State<EditHydran> createState() => _EditHydranState();
}

class _EditHydranState extends State<EditHydran> {
  bool isService = false;

  void save() {
    BlocProvider.of<EdithydranCubit>(context).putmasterhydran(widget.id, isService == true ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<HydranCubit>(context).getmasterhydran();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Hydran'),
        ),
        body: BlocListener<EdithydranCubit, EdithydranState>(
          listener: (context, state) async {
            if (state is EdithydranLoading) {
              EasyLoading.show();
            }
            if (state is EdithydranLoaded) {
              EasyLoading.dismiss();
              var json = state.json;
              var statusCode = state.statusCode;
              if (statusCode == 200) {
                MyDialog.dialogSuccess(context, json['message']);
              } else {
                MyDialog.dialogAlert(context, json['message']);
              }
            }
          },
          child: ListView(
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
                  onTap: save,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
