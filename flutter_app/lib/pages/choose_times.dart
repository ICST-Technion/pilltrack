import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iot/theme/colors/light_colors.dart';
import 'package:iot/widgets/top_container.dart';
import 'package:iot/widgets/my_text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iot/shared.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChoosePillTimePage extends StatefulWidget {
  @override
  _ChoosePillTimeState createState() => _ChoosePillTimeState();
}

class _ChoosePillTimeState extends State<ChoosePillTimePage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  late StreamSubscription _stream;
  //late TimeOfDay first_dose_time;
  TimeOfDay first_dose_time = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay second_dose_time = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hour = first_dose_time.hour.toString().padLeft(2, '0');
    final minute = first_dose_time.minute.toString().padLeft(2, '0');
    final hour2 = second_dose_time.hour.toString().padLeft(2, '0');
    final minute2 = second_dose_time.minute.toString().padLeft(2, '0');

    final firstdose_ref = database.child('/$currUserID/pill times');
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      body: Column(
        children: <Widget>[
          TopContainer(
            height: 200,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Text(
                                'Choose your Pill Times',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ),
          SizedBox(height: 70),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.wb_sunny_outlined),
                    Text(
                      '  First Time:        ',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: first_dose_time);
                        if (newTime == null) return;
                        setState(() => first_dose_time = newTime);
                      },
                      height: 40,
                      minWidth: 150,
                      child: Text(
                        '$hour:$minute ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Colors.black38,
                      shape: const StadiumBorder(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(Icons.nightlight_outlined),
                    Text(
                      '  Second Time:   ',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: second_dose_time);
                        if (newTime == null) return;
                        setState(() => second_dose_time = newTime);
                      },
                      height: 40,
                      minWidth: 150,
                      child: Text(
                        '$hour2:$minute2 ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      textColor: Colors.white,
                      color: Colors.black38,
                      shape: const StadiumBorder(),
                    ),
                  ],
                ),
                SizedBox(height: 90),
                Container(
                  height: 80,
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          try {
                            await firstdose_ref.update({
                              'first dose': '$hour:$minute',
                              'second dose': '$hour2:$minute2'
                            });
                            print("doses time updated");
                            Navigator.pushNamed(context, '/pages/tab_screen');
                          } catch (e) {
                            print('error in update doses: $e');
                          }
                        },
                        height: 40,
                        minWidth: 130,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        color: Colors.black,
                        shape: const StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _stream.cancel();
    super.deactivate();
  }
}
