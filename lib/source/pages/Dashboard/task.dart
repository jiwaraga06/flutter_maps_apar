import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/pages/insertTask.dart/insert.dart';
import 'package:flutter_maps_apar/source/services/users/cubit/insertask_cubit.dart';
import 'package:flutter_maps_apar/source/services/users/cubit/scanqr_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class IsiTask {
  int? id_task;
  String? photo, status, note, timestamp;

  IsiTask(this.id_task, this.photo, this.status, this.note, this.timestamp);
  Map toJson() => {
        'id_task': id_task,
        'photo': photo,
        'status': status,
        'keterangan': note,
        'timestamp': timestamp,
      };
  @override
  String toString() => '{id_task: $id_task,  checklist: $status, keterangan: $note, time: $timestamp}';
}

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  List<IsiTask> isiTask = [];
  List<int> groupValue = [];
  List<List<int>> value = [];
  var date;
  String url = "https://satu.sipatex.co.id:2087/api/v2/apar/scan-qrcode-history-task/2ed6d27f-3ae0-4855-96d5-8035f631b9ba/A";
//     print(url.split('/'));
  //     print(url.split('/')[url.split('/').length - 2]);
  //     print(url.split('/')[url.split('/').length - 1]);

  void baik(id_task) async {
    var a = isiTask.indexWhere((element) => element.id_task == id_task);
    print(a);
    if (a != -1) {
      setState(() {
        isiTask[a].photo = null;
        isiTask[a].status = 'V';
        isiTask[a].note = null;
        isiTask[a].timestamp = date.toString();
      });
    } else if (a == -1) {
      setState(
        () {
          IsiTask task = IsiTask(id_task, '', '', '', date);
          task.id_task = id_task;
          task.photo = null;
          task.status = 'V';
          task.note = null;
          isiTask.add(task);
        },
      );
    }
  }

  void save(ref, inisial, datatask) {
    BlocProvider.of<InsertaskCubit>(context).saveTask(ref, inisial, isiTask, datatask);
  }

  @override
  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    BlocProvider.of<ScanqrCubit>(context).inisialisasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
        actions: [
          BlocBuilder<ScanqrCubit, ScanqrState>(
            builder: (context, state) {
              if (state is ScanqrLoading) {
                return Container();
              }
              if (state is ScanqrLoaded == false) {
                return Container();
              }
              var task = (state as ScanqrLoaded).task;
              var json = (state as ScanqrLoaded).json;
              if (task.isNotEmpty) {
                return IconButton(
                    onPressed: () {
                      setState(() {
                        isiTask;
                        const snackdemo = SnackBar(
                          content: Text('Di Refresh'),
                          elevation: 10,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.startToEnd,
                          margin: EdgeInsets.all(5),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                      });
                    },
                    icon: Icon(Icons.refresh));
              }
              return Container();
            },
          )
        ],
      ),
      floatingActionButton: BlocListener<InsertaskCubit, InsertaskState>(
        listener: (context, state) async {
          if (state is InsertaskLoading) {
            EasyLoading.show();
          }
          if (state is InsertaskLoaded) {
            EasyLoading.dismiss();
            var statusCode = state.statusCode;
            var json = state.json;
            if (statusCode == 200) {
              if (json['errors'] != null) {
                MyDialog.dialogAlert(context, json['errors'].toString());
              } else {
                MyDialog.dialogSuccess(context, json['message']);
                await Future.delayed(const Duration(seconds: 1));
                BlocProvider.of<ScanqrCubit>(context).inisialisasi();
              }
            } else {
              MyDialog.dialogAlert(context, json['message']);
            }
          }
        },
        child: BlocBuilder<ScanqrCubit, ScanqrState>(builder: (context, state) {
          if (state is ScanqrLoading) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<ScanqrCubit>(context).scanqr();
              },
              backgroundColor: color2,
              child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
            );
          }
          if (state is ScanqrLoaded == false) {
            return FloatingActionButton(
              onPressed: () {
                BlocProvider.of<ScanqrCubit>(context).scanqr();
              },
              backgroundColor: color2,
              child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
            );
          }
          var task = (state as ScanqrLoaded).task;
          var json = (state as ScanqrLoaded).json;
          if (task.isNotEmpty) {
            return SpeedDial(
              icon: Icons.menu,
              activeIcon: Icons.close,
              backgroundColor: color2,
              foregroundColor: Colors.white,
              activeBackgroundColor: color1,
              activeForegroundColor: Colors.white,
              visible: true,
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.0,
              shape: const CircleBorder(),
              children: [
                SpeedDialChild(
                    child: const Icon(FontAwesomeIcons.check),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    label: 'Simpan Pemeriksaan',
                    labelStyle: const TextStyle(fontSize: 18.0),
                    onTap: () {
                      print(isiTask);
                      save(json['reference'], json['initial'], task);
                    }),
                SpeedDialChild(
                  child: const Icon(Icons.qr_code_2_sharp),
                  backgroundColor: basic,
                  foregroundColor: Colors.white,
                  label: 'Pindai Kode QR',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    BlocProvider.of<ScanqrCubit>(context).scanqr();
                  },
                ),
              ],
            );
          }
          return FloatingActionButton(
            onPressed: () {
              BlocProvider.of<ScanqrCubit>(context).scanqr();
            },
            backgroundColor: color2,
            child: const Icon(Icons.qr_code_2_sharp, color: Colors.white),
          );
        }),
      ),
      body: BlocBuilder<ScanqrCubit, ScanqrState>(
        builder: (context, state) {
          if (state is ScanqrLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (state is ScanqrLoaded == false) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Silahkan Pindai Kode QR pada Apar'),
                  Text('Untuk Melakukan Pemeriksaan'),
                ],
              ),
            );
          }
          var json = (state as ScanqrLoaded).json;
          var task = (state as ScanqrLoaded).task;
          var statusCode = (state as ScanqrLoaded).statusCode;
          if (json.isEmpty && task.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Silahkan Pindai Kode QR pada Apar'),
                  Text('Untuk Melakukan Pemeriksaan'),
                ],
              ),
            );
          } else if (json.isNotEmpty && task.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Tidak Ada Task Pada Apar Ini'),
                  Text('Tidak Ada Untuk Melakukan Pemeriksaan'),
                ],
              ),
            );
          }
          for (var i = 0; i <= task.length; i++) {
            groupValue.add(-1);
          }
          print(task);
          if (statusCode != 200) {
            return Container();
          }

          return ListView(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: task.length,
                itemBuilder: (BuildContext context, int index) {
                  var a = task[index];
                  print(isiTask.indexWhere((element) => element.id_task == a['id_task']));
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 2.3,
                        spreadRadius: 2.3,
                        offset: Offset(1, 3),
                      ),
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Badge(
                          backgroundColor: const Color(0xFF482121),
                          label: const Text('Nomer Task', style: TextStyle(fontSize: 11.5)),
                          // backgroundColor: Colors.white,
                          child: Container(
                              margin: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: Colors.blue,
                                color: isiTask.indexWhere((element) => element.id_task == a['id_task']) != -1 ? Colors.green[600] : Color(0XFFA13333),
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              child: Text(
                                a['id_task'].toString(),
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              )),
                        ),
                        Text(a['task'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8.0),
                        LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          if (constraints.maxWidth <= 400) {
                            return Center(
                              child: ToggleSwitch(
                                customWidths: const [150, 150],
                                initialLabelIndex: groupValue[index],
                                cornerRadius: 20.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                customTextStyles: const [
                                  TextStyle(fontSize: 17),
                                  TextStyle(fontSize: 17),
                                ],
                                labels: const ['Tidak Baik', 'Baik'],
                                icons: const [FontAwesomeIcons.thumbsDown, FontAwesomeIcons.thumbsUp],
                                activeBgColors: const [
                                  [colorBtnCancel],
                                  [Colors.blue],
                                ],
                                onToggle: (id) {
                                  print(a['task']);
                                  print('switched to: $id');
                                  setState(() {
                                    groupValue[index] = id!;
                                  });
                                  if (groupValue[index] == 1) {
                                    baik(a['id_task']);
                                  } else if (groupValue[index] == 0) {
                                    var res = isiTask.indexWhere((element) => element.id_task == a['id_task'] && element.status == "V");
                                    if (res != -1) {
                                      isiTask.removeWhere((element) => element.id_task == a['id_task']);
                                    }
                                  }
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: ToggleSwitch(
                                customWidths: const [250, 250],
                                initialLabelIndex: groupValue[index],
                                cornerRadius: 20.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                customTextStyles: const [
                                  TextStyle(fontSize: 17),
                                  TextStyle(fontSize: 17),
                                ],
                                labels: const ['Tidak Baik', 'Baik'],
                                icons: const [FontAwesomeIcons.thumbsDown, FontAwesomeIcons.thumbsUp],
                                activeBgColors: const [
                                  [colorBtnCancel],
                                  [Colors.blue],
                                ],
                                onToggle: (id) {
                                  print(a['task']);
                                  print('switched to: $id');
                                  setState(() {
                                    groupValue[index] = id!;
                                  });
                                  if (groupValue[index] == 1) {
                                    baik(a['id_task']);
                                  } else if (groupValue[index] == 0) {
                                    var res = isiTask.indexWhere((element) => element.id_task == a['id_task'] && element.status == "V");
                                    if (res != -1) {
                                      isiTask.removeWhere((element) => element.id_task == a['id_task']);
                                    }
                                  }
                                },
                              ),
                            );
                          }
                        }),
                        if (groupValue[index] == 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              color: basic2,
                              splashColor: color2,
                              text: 'Tambahkan Keterangan',
                              textStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                              onTap: () {
                                // fillask(a['id_task']);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Insert(
                                      isitask: isiTask,
                                      id_task: a['id_task'],
                                      voidCallback: () => setState(() {
                                        isiTask;
                                      }),
                                    );
                                  },
                                ));
                              },
                            ),
                          ),
                        const SizedBox(height: 8),
                        const Divider(color: basic, thickness: 2),
                        const SizedBox(height: 8)
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
