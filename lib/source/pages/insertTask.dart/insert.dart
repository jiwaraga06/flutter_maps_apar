import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/task.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Insert extends StatefulWidget {
  final List? isitask;
  final int? id_task;
  Insert({super.key, this.isitask, this.id_task});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  TextEditingController controllerNote = TextEditingController();
  String? base64String;
  CroppedFile? cropedGambar;
  File? image;
  XFile? gambar;
  Future pilihGambar() async {
    gambar = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 300,
      imageQuality: 100,
    );
    // print(cropedGambar!.path);
    // File imageResized = await FlutterNativeImage.compressImage(cropedGambar!.path, quality: 100, targetWidth: 120, targetHeight: 120);
    final imageResized = File(gambar!.path).readAsBytesSync();
    // final imgByte = imageResized.readAsBytesSync();
    base64String = 'data:image/png;base64,${Base64Encoder().convert(imageResized)}';
    // base64String = 'data:image/png;base64';
    setState(() {});
  }

  var date;
  @override
  void initState() {
    super.initState();
    date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Pemeriksaan'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    await pilihGambar();
                    setState(() {});
                  },
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: gambar == null
                        ? Icon(FontAwesomeIcons.images, size: 40)
                        : Image.file(
                            File(gambar!.path),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                width: 100,
                                height: 100,
                                child: const Center(
                                  child: const Text('Error load image', textAlign: TextAlign.center),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerNote,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Isi Keterangan Pemeriksaan Apar',
                      // border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: 'Simpan',
                    textStyle: TextStyle(fontSize: 17, color: Colors.white),
                    color: basic,
                    splashColor: color2,
                    onTap: () {
                      // Navigator.pop(context);
                      // print(input);
                      var a = widget.isitask!.indexWhere((element) => element.id_task == widget.id_task);
                      print(a);
                      if (a != -1) {
                        setState(() {
                          widget.isitask![a].photo = '${base64String}';
                          widget.isitask![a].status = 'X';
                          widget.isitask![a].note = controllerNote.text;
                          widget.isitask![a].timestamp = date.toString();
                        });
                      } else if (a == -1) {
                        setState(
                          () {
                            IsiTask task = IsiTask(widget.id_task, '', '', '', date.toString());
                            task.id_task = widget.id_task;
                            task.photo = '${base64String}';
                            task.status = 'X';
                            task.note = controllerNote.text;
                            widget.isitask!.add(task);
                          },
                        );
                      }
                      setState(() {
                        widget.isitask;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
