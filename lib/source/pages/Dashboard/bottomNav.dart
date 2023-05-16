import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/home.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/profile.dart';
import 'package:flutter_maps_apar/source/pages/Dashboard/user.dart';
import 'package:flutter_maps_apar/source/services/Auth/cubit/tabbar_cubit.dart';
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
        return Scaffold(
          // body: _widgetOptions0.elementAt(index),
          body: [
            if (user_roles.where((e) => e == 'admin').toList().isNotEmpty) Home(),
            if (user_roles.where((e) => e == 'user').toList().isNotEmpty) User(),
            Profile(),
          ].elementAt(index),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: const Color(0XFF27496D),
            selectedLabelStyle: const TextStyle(fontSize: 15, color: Color(0XFF27496D)),
            unselectedLabelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            items: [
              if (user_roles.where((e) => e == 'admin').toList().isNotEmpty)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  activeIcon: Icon(
                    Icons.add,
                    color: Color(0XFF27496D),
                  ),
                  label: 'Admin',
                ),
              if (user_roles.where((e) => e == 'user').toList().isNotEmpty)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_scanner),
                  activeIcon: Icon(
                    Icons.qr_code_scanner,
                    color: Color(0XFF27496D),
                  ),
                  label: 'User',
                ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                activeIcon: Icon(
                  FontAwesomeIcons.user,
                  color: Color(0XFF27496D),
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
