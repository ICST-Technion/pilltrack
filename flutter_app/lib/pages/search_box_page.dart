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

class SearchBoxPage extends StatefulWidget {
  @override
  _SearchBoxPage createState() => _SearchBoxPage();
}

class _SearchBoxPage extends State<SearchBoxPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Your pill box will notify you for another 5min ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Color.fromARGB(255, 195, 247, 132),
        textColor: Color.fromARGB(255, 7, 6, 6));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      'Box is Lost!',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            27,
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
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Your box will be like this within 5 minutes: \n',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Text(
                            'flashing lights & buzzer sound',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.volume_up_sharp)
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset("assets/images/seach.png"),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            database
                                .child('$currUserID/')
                                .update({'search box': false});
                            Navigator.pushReplacementNamed(
                                context, '/pages/tab_screen');
                          },
                          height: 40,
                          minWidth: 130,
                          child: const Text(
                            'I found the box',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                          color: Colors.lightGreen,
                          shape: const StadiumBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            showToast();
                            database
                                .child('$currUserID/')
                                .update({'search box': true});

                            //Navigator.pushReplacementNamed(
                            //context, '/pages/tab_screen');
                          },
                          height: 40,
                          minWidth: 130,
                          child: Container(
                            width: 135,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.search),
                                Text(
                                  'Search Again',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          textColor: Colors.white,
                          color: Colors.deepOrange,
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ));
  }

/*
  @override
  void deactivate(){
    _stream.cancel();
    super.deactivate();
  }


 */

}
