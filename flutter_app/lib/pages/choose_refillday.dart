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

class ChooseRefillDay extends StatefulWidget {
  @override
  _ChooseRefillDay createState() => _ChooseRefillDay();
}

class _ChooseRefillDay extends State<ChooseRefillDay> {
  final _database = FirebaseDatabase.instance.ref();
  String dropdownvalue = items[0];

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Scaffold(
          body: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TopContainer(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
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
                                      'Refill Box Day ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            30,
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
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        const Text(
                          '- Only on this day you are allowed to refill the box with pills.\n\n- You will recieve a refilling reminder at the beginning of this day each week (Saturday recommeded).',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 1, 45, 91)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * 0.10,
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
                          child: Row(
                            children: [
                              Text('  Choose Refill Day:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 8, 87, 133))),
                              SizedBox(width: 30),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownButton(
                                      // Initial Value
                                      value: dropdownvalue,

                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),

                                      // Array list of items
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                          //user.refill_day = newValue;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        MaterialButton(
                          onPressed: () {
                            _database
                                .child('userID/info')
                                .update({'refill day': dropdownvalue});

                            Navigator.pushReplacementNamed(
                                context, '/pages/choose_times');
                          },
                          height: 40,
                          minWidth: 130,
                          child: const Text(
                            'submit',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                          color: Color.fromARGB(255, 16, 101, 128),
                          //icon: Icon(Icons.confirmation_num),
                          shape: const StadiumBorder(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }
}
