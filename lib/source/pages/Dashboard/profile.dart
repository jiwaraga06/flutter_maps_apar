import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_maps_apar/source/router/string.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/auth_cubit.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/profile_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:flutter_maps_apar/source/widget/customButton.dart';
import 'package:flutter_maps_apar/source/widget/customDialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void logout(username) {
    BlocProvider.of<AuthCubit>(context).logout(username);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is LogoutLoading) {
            EasyLoading.show();
          }
          if (state is LogoutLoaded) {
            EasyLoading.dismiss();
            var json = state.json;
            var statusCode = state.statusCode;
            if (statusCode == 200) {
              EasyLoading.showSuccess(json['message'], duration: const Duration(seconds: 1));
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pushNamedAndRemoveUntil(context, LOGIN, (route) => false);
            } else {
              EasyLoading.showError(json['message'], duration: const Duration(seconds: 2));
            }
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileLoaded == false) {
              return Container();
            }
            var data = (state as ProfileLoaded).json;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(90),
                          1: FixedColumnWidth(10),
                        },
                        // border: TableBorder.all(width: ),
                        children: [
                          TableRow(children: [
                            const SizedBox(height: 35, child: Text('Nama', style: TextStyle(fontSize: 16))),
                            const Text(':', style: TextStyle(fontSize: 16)),
                            Text(data['nama'], style: const TextStyle(fontSize: 16)),
                          ]),
                          TableRow(children: [
                            const SizedBox(height: 35, child: Text('Username', style: TextStyle(fontSize: 16))),
                            const Text(':', style: TextStyle(fontSize: 16)),
                            Text(data['username'], style: const TextStyle(fontSize: 16)),
                          ]),
                          TableRow(children: [
                            const SizedBox(height: 35, child: Text('Gender', style: TextStyle(fontSize: 16))),
                            const Text(':', style: TextStyle(fontSize: 16)),
                            if (data['gender'] == 'l')
                              Row(
                                children: [
                                  Text('Laki - laki ', style: const TextStyle(fontSize: 16)),
                                  Text(' ', style: const TextStyle(fontSize: 16)),
                                  Icon(FontAwesomeIcons.mars, color: Colors.blue, size: 20),
                                ],
                              ),
                            if (data['gender'] == 'm')
                              Row(
                                children: [
                                  Text('Perempuan ', style: const TextStyle(fontSize: 16)),
                                  Text(' ', style: const TextStyle(fontSize: 16)),
                                  Icon(FontAwesomeIcons.venus, color: Colors.pink[600], size: 20),
                                ],
                              ),
                          ]),
                          TableRow(children: [
                            const SizedBox(height: 30, child: Text('Role', style: TextStyle(fontSize: 16))),
                            const Text(':', style: TextStyle(fontSize: 16)),
                            SizedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: jsonDecode(data['user_roles']).length,
                                    itemBuilder: (context, index) {
                                      var role = jsonDecode(data['user_roles'])[index];
                                      return Text('$role ,');
                                    },
                                  ),
                                ),
                              ),
                            )
                            // Text(jsonDecode(data['user_roles']).length. toString(), style: const TextStyle(fontSize: 16)),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButon(
                    color: colorBtnCancel,
                    splashColor: Colors.red[800],
                    text: 'Logout',
                    onTap: () {
                      logout(data['username']);
                    },
                    textStyle: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
