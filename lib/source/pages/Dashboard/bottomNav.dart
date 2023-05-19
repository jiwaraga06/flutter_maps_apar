import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/history.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/pemeriksaan.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/profile.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/task.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/tabbar_cubit.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  var index = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TabbarCubit>(context).getRole();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabbarCubit, TabbarState>(
      builder: (context, state) {
        if (state is TabbarLoaded == false) {
          return Container();
        }
        var user_roles = jsonDecode((state as TabbarLoaded).json);
        print(user_roles);
        return Scaffold(extendBody: true,
          // body: _widgetOptions0.elementAt(index),
          body: [
            if (user_roles.where((e) => e == 'admin').toList().isNotEmpty) Home(),
            if (user_roles.where((e) => e == 'user').toList().isNotEmpty) User(),
            History(),
            Profile(),
          ].elementAt(index),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BottomNavigationBar(
                backgroundColor: navbar,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Colors.grey[350],
                selectedItemColor: Colors.white,
                selectedLabelStyle: const TextStyle(fontSize: 15, color: Colors.white),
                unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.grey[100]),
                currentIndex: index,
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                items: [
                  if (user_roles.where((e) => e == 'admin').toList().isNotEmpty)
                    const BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.add),
                      activeIcon: Icon(
                        FontAwesomeIcons.add,
                        color: Colors.white,
                      ),
                      label: 'Pemeriksaan',
                    ),
                  if (user_roles.where((e) => e == 'user').toList().isNotEmpty)
                    const BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.clipboardList),
                      activeIcon: Icon(
                        FontAwesomeIcons.clipboardList,
                        color: Colors.white,
                      ),
                      label: 'Task',
                    ),
                  const BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.history),
                    activeIcon: Icon(
                      FontAwesomeIcons.history,
                      color: Colors.white,
                    ),
                    label: 'Riwayat',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.users),
                    activeIcon: Icon(
                      FontAwesomeIcons.users,
                      color: Colors.white,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
