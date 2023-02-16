import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot/theme/colors/light_colors.dart';
import 'package:iot/widgets/box_cell.dart';
import 'package:iot/widgets/menu_row.dart';
import 'package:iot/widgets/top_container.dart';
import 'package:iot/models/box_cell_model.dart';
import 'package:iot/shared.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:iot/models/myDateTime.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_email_sender/flutter_email_sender.dart';

class LOGPage extends StatelessWidget {
  final _database = FirebaseDatabase.instance.ref();
  //late StreamSubscription _boxStream;

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      //backgroundColor: LightColors.kGreen,
      backgroundColor: Color(0xff77205a),
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColors.kLightYellow,
        //backgroundColor: Color(0xEFC4F2F3),
        body: StreamBuilder(
            stream: _database.child('userID').onValue,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                final data = jsonDecode(jsonEncode(
                        (snapshot.data as DatabaseEvent).snapshot.value))
                    as Map<String, dynamic>;

                final LOG = data['LOG'];

                int len = LOG.length;

                print(LOG[0]);
                print(len);
                //print(data['0']['date'].toString());

                /*
                List<Map<String, String>> list = [];
                list.clear();
                //data.map((key, value) => list.add({'$key': '$value'}));
                for (int i = 0; i < data.length; i++) {
                  String idx = i.toString();
                  // String
                  list.add(data[idx]);
                }
                */
                /*

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data['0']['date'].toString()),
                        subtitle: Text(data['0']['operation'].toString()),
                      );
                    });
                    */
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Container(
                                            child: Text(
                                              'My Info & Operation history',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    22,
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

                        //Text(
                        //elevation: 10,
                        //color: Color.fromARGB(255, 12, 12, 10),
                        SizedBox(
                          height: 25,
                        ),

                        Text('    Date           Time          Status',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 11, 0, 0))),

                        Expanded(
                          child: ListView.builder(
                              itemCount: len,
                              itemBuilder: (context, index) {
                                Color c = Color.fromARGB(255, 205, 13, 13);
                                if (LOG[index]['operation']
                                        .toString()
                                        .substring(10, 14) ==
                                    'took') {
                                  c = Color.fromARGB(255, 85, 168, 18);
                                }
                                return Card(
                                  elevation: 10,
                                  //color: Color.fromARGB(255, 12, 12, 10),
                                  color: c,
                                  child: Text(
                                      '  ' +
                                          LOG[index]['date'] +
                                          '       ' +
                                          LOG[index]['operation'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
