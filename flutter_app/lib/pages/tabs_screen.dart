import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/pages/log_page.dart';
import 'package:iot/pages/patient_log.dart';
import 'package:iot/pages/refill_box_page.dart';

import 'package:iot/pages/set_pill_time_page.dart';
import 'package:iot/pages/pill_box_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

import 'package:iot/shared.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final _database = FirebaseDatabase.instance.ref();

  final List<Map<String, Object>> _pages = [
    {
      'page': SetPillTimePage(),
      'title': 'set pill time',
    },
    {
      'page': PillBox(),
      'title': 'pill box',
    },
    {
      'page': InfoPage(),
      'title': 'LOG',
    },
  ];
  int _selectedPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      if (sysOK == 0) {
        Navigator.pushReplacementNamed(context, '/pages/refill_box_page');
      }

      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Scaffold(
          body: _pages[_selectedPageIndex]['page'] as Widget,
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            backgroundColor: Color.fromARGB(255, 248, 155, 26),
            //backgroundColor: Color(0xff9a6583),
            //backgroundColor: Theme.of(context).hintColor,
            unselectedItemColor: Color(0xEC27272D),
            selectedItemColor: Colors.white,
            currentIndex: _selectedPageIndex,
            selectedFontSize: 16,
            elevation: 20,
            //selectedIconTheme: ,
            //selectedIconTheme: ,
            //type: BottomNavigationBarType.fixed,
            //showUnselectedLabels: false,

            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.orange[500],
                icon: Icon(Icons.more_time),
                label: 'Pill Times',
              ),
              BottomNavigationBarItem(
                  backgroundColor: Colors.orange[500],
                  icon: Icon(Icons.medical_services_rounded),
                  label: 'Pill Box'),
              BottomNavigationBarItem(
                backgroundColor: Colors.orange[500],
                icon: Icon(Icons.location_history_rounded),
                label: 'LOG',
              ),
            ],
          ),
        ));
  }
}
