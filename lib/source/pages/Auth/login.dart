import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/auth_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/copyright.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:flutter_maps_apar/source/widget/customForm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  bool isshowPassword = true;
  bool isLokasi = false;
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  void save() async {
    if (formkey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).login(context, controllerUsername.text, controllerPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            EasyLoading.show();
          }
          if (state is LoginLoaded) {
            EasyLoading.dismiss();
            var json = state.json;
            var statusCode = state.statusCode;
            if (statusCode == 200) {
              if (json['status'] == 500) {
                MyDialog.dialogAlert(context, json['message']);
              } else {
                MyDialog.dialogSuccess(context, json['message']);
              }
            } else if (statusCode == 422) {
              MyDialog.dialogAlert(context, "${json['message']} \n ${json['errors']['barcode'][0]} \n ${json['errors']['password'][0]}");
            } else {
              MyDialog.dialogAlert(context, json['message']);
            }
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 120),
                    Image.asset('assets/apar.jpg', height: 150),
                    const SizedBox(height: 12),
                    const Text('Monitoring Apar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomFormField(
                            controller: controllerUsername,
                            messageError: 'Kolom tidak boleh kosong',
                            hint: 'Masukan Barcode',
                            obscureText: false,
                            prefixIcon: const Icon(Icons.account_circle),
                          ),
                          const SizedBox(height: 10),
                          CustomFormField(
                            controller: controllerPassword,
                            messageError: 'Kolom tidak boleh kosong',
                            hint: 'Masukan Password',
                            obscureText: isshowPassword,
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isshowPassword = !isshowPassword;
                                  });
                                },
                                child: isshowPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: 'LOGIN',
                      textStyle: const TextStyle(fontSize: 17, color: Colors.white),
                      color: colorBtnOk,
                      onTap: () {
                        save();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Copyright(),
                  const SizedBox(height: 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
