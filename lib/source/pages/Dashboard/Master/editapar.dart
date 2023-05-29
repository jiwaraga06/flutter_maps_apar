import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/services/Master/Apar/cubit/apar_cubit.dart';
import 'package:flutter_maps_apar/source/services/Master/Apar/cubit/editapar_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class EditApar extends StatefulWidget {
  final int? id, isService;
  const EditApar({super.key, this.id, this.isService});

  @override
  State<EditApar> createState() => _EditAparState();
}

class _EditAparState extends State<EditApar> {
  bool isService = false;

  void save() {
    BlocProvider.of<EditaparCubit>(context).putmasterapar(widget.id, isService == true ? 1 : 0);
  }

  @override
  void initState() {
    super.initState();
    print(widget.id.toString());
    print(widget.isService.toString());
    if (widget.isService == null) {
      setState(() {
        isService = false;
      });
    } else if (widget.isService == 0) {
      setState(() {
        isService = false;
      });
    } else {
      setState(() {
        isService = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<AparCubit>(context).getmasterapar();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Apar'),
        ),
        body: BlocListener<EditaparCubit, EditaparState>(
          listener: (context, state) async {
            if (state is EditaparLoading) {
              EasyLoading.show();
            }
            if (state is EditaparLoaded) {
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
