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

class SetPillTimePage extends StatefulWidget {
  @override
  _SetPillTimeState createState() => _SetPillTimeState();
}

class _SetPillTimeState extends State<SetPillTimePage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  late StreamSubscription _stream;
  //late TimeOfDay first_dose_time;
  TimeOfDay first_dose_time = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay second_dose_time = TimeOfDay(hour: 00, minute: 00);
  String refill_day = '';

  @override
  void initState() {
    //database = FirebaseDatabase.instance.ref();
    _activateListeners();
    //_performSingleFetch();
    super.initState();
  }

  void _performSingleFetch() async {
    await database.child('userID/info').get().then((event) {
      final extracted =
          jsonDecode(jsonEncode(event.value)) as Map<String, dynamic>;
      setState(() {
        refill_day = extracted['refill day'];
      });
    });
  }

  void _activateListeners() {
    int h1 = 0, h2 = 0, m1 = 0, m2 = 0;
    _stream = database.child('$currUserID/pill times').onValue.listen((event) {
      //final extractedTimes =new Map<String, dynamic>.from(event.snapshot.value as Map<String, dynamic>);
      //print(event.snapshot.value.toString());
      final extractedTimes =
          jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      final first_time = extractedTimes['first dose'];
      final second_time = extractedTimes['second dose'];
      h1 = int.parse(first_time.substring(0, 2));
      m1 = int.parse(first_time.substring(3, 5));
      h2 = int.parse(second_time.substring(0, 2));
      m2 = int.parse(second_time.substring(3, 5));
      setState(() {
        first_dose_time = TimeOfDay(hour: h1, minute: m1);
        second_dose_time = TimeOfDay(hour: h2, minute: m2);
      });
    });
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Times updated successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Color.fromARGB(255, 184, 246, 175),
        textColor: Color.fromARGB(255, 0, 0, 0));
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
                                'Set your Pill Times',
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
          SizedBox(height: 50),
          Expanded(
              child: SingleChildScrollView(
            //padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 20,
                              spreadRadius: 10,
                              offset: const Offset(0, 10))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.wb_sunny_outlined),
                            Text(
                              '  First Time:        ',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: first_dose_time);
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.nightlight_outlined),
                            Text(
                              '  Second Time:   ',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: second_dose_time);
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
                        SizedBox(height: 50),
                        Container(
                          height: 80,
                          width: width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () async {
                                  try {
                                    showToast();
                                    await firstdose_ref.update({
                                      'first dose': '$hour:$minute',
                                      'second dose': '$hour2:$minute2'
                                    });
                                    print("doses time updated");
                                  } catch (e) {
                                    print('error in update doses: $e');
                                  }
                                },
                                height: 40,
                                minWidth: 120,
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                textColor: Colors.white,
                                color: Colors.black,
                                shape: const StadiumBorder(),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/pages/tab_screen');
                                },
                                height: 40,
                                minWidth: 120,
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                textColor: Colors.white,
                                color: Colors.black,
                                shape: const StadiumBorder(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 70),
                Container(
                  height: 80,
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () async {
                          _performSingleFetch();
                        },
                        height: 40,
                        minWidth: 130,
                        child: Text(
                          'Refill Day?  $refill_day',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        color: Color.fromARGB(255, 124, 115, 115),
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
