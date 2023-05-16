import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/change_pass_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/profile_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/tabbar_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:flutter_maps_apar/source/widget/customForm.dart';

import '../../services/Auth/cubit/auth_cubit.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerOldPass = TextEditingController();
  TextEditingController controllerNewPass = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isShowPassOld = true;
  bool isShowPassNew = true;

  void save() {
    if (formkey.currentState!.validate()) {
      BlocProvider.of<ChangePassCubit>(context).changePass(controllerUsername.text, controllerOldPass.text, controllerNewPass.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Sandi'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Container();
          }
          if (state is ProfileLoaded == false) {
            return Container();
          }
          var username = (state as ProfileLoaded).json;
          controllerUsername = TextEditingController(text: username['username']);
          return BlocListener<ChangePassCubit, ChangePassState>(
            listener: (context, state) async {
              if (state is ChangePassLoading) {
                EasyLoading.show();
              }
              if (state is ChangePassLoaded) {
                EasyLoading.dismiss();
                var json = state.json;
                var statusCode = state.statusCode;
                if (statusCode == 200) {
                  MyDialog.dialogSuccess(context, '${json['message']} \n Silahkan Login Kembali');
                  await Future.delayed(const Duration(seconds: 1));
                  BlocProvider.of<AuthCubit>(context).logout(context, username['username']);
                } else {
                  MyDialog.dialogAlert(context, json['message'].toString());
                }
              }
            },
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly: true,
                            controller: controllerUsername,
                            obscureText: false,
                            decoration: const InputDecoration(
                              hintText: "Username Anda",
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              prefixIcon: Icon(Icons.account_circle),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: color1, width: 2),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: controllerOldPass,
                            hint: 'Masukan Kata Sandi Lama',
                            messageError: 'Kolon tidak boleh kosong',
                            obscureText: isShowPassOld,
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isShowPassOld = !isShowPassOld;
                                  });
                                },
                                child: isShowPassOld ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: controllerNewPass,
                            hint: 'Masukan Kata Sandi Baru',
                            messageError: 'Kolon tidak boleh kosong',
                            obscureText: isShowPassNew,
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isShowPassNew = !isShowPassNew;
                                  });
                                },
                                child: isShowPassNew ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButon(
                    text: 'SAVE',
                    textStyle: TextStyle(fontSize: 17, color: Colors.white),
                    onTap: save,
                    color: colorBtnOk,
                    splashColor: Colors.teal,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
