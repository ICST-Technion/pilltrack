import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot/theme/colors/light_colors.dart';
import 'package:iot/widgets/top_container.dart';
import 'package:iot/models/box_cell_model.dart';
import 'package:iot/shared.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:iot/models/myDateTime.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:iot/models/myDateTime.dart';
import 'package:iot/login2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot/providers/firebase_auth.dart';

class GDPData {
  GDPData(this.status, this.percent);
  final String status;
  final double percent;
}

class LOGPage extends StatelessWidget {
  late Map<String, double> dataMap;
  late TooltipBehavior _tooltipBehavior;
  final _database = FirebaseDatabase.instance.ref();
  String formattedDate = '';
  String patient_name = '';
  List<String> selected_dates = [];
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
    final colorList = <Color>[
      Color.fromARGB(255, 62, 199, 20),
      Color.fromARGB(255, 207, 51, 4),
    ];
    return new WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Scaffold(
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

                    int len = data['LOG INDEX'];

                    print(LOG[0]);
                    print(len);
                    _tooltipBehavior = TooltipBehavior(enable: true);

                    int count_taken = 0, count_late = 0;

                    for (int i = 0; i < data['LOG INDEX']; i++) {
                      if (data['LOG'][i]['status'] == 1) {
                        count_taken++;
                      } else
                        count_late++;
                    }
                    dataMap = {
                      'taken': count_taken / (count_taken + count_late),
                      'late': count_late / (count_taken + count_late)
                    };
                    patient_name = data['info']['name'];

                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TopContainer(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MaterialButton(
                                            onPressed: () async {
                                              final logout =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: new Text(
                                                        'Are you sure?'),
                                                    content: new Text(
                                                        'Keep in mind: if you logout you will NOT get notifications about your patient until you login again!'),
                                                    actionsAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseAuth
                                                              .instance
                                                              .signOut();

                                                          _database
                                                              .child(
                                                                  'monitor/fcm-token')
                                                              .remove();

                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  '/log_in2');
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                        child: const Text('No'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            height: 30,
                                            minWidth: 15,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.logout),
                                                Text(' logout',
                                                    style:
                                                        TextStyle(fontSize: 12))
                                              ],
                                            ),
                                            textColor: Colors.white,
                                            color:
                                                Color.fromARGB(255, 231, 98, 9),
                                            shape: const StadiumBorder(),
                                          ),
                                        ]),
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
                                                height: 15,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Medical Log of $patient_name',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(
                                                                context)
                                                            .textScaleFactor *
                                                        22,
                                                    color:
                                                        LightColors.kDarkBlue,
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
                            // TODO: REFILL DAY+ EMAIL+PASSWORD

                            PieChart(
                              chartRadius: 100,
                              dataMap: dataMap,
                              chartType: ChartType.ring,
                              baseChartColor: Colors.grey[300]!,
                              colorList: colorList,
                              chartValuesOptions: ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    selected_dates.clear();
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: getTimeNow(),
                                        firstDate: DateTime(2023),
                                        lastDate: getTimeNow());

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      formattedDate = DateFormat('dd/MM/yyyy')
                                          .format(pickedDate);
                                      print(formattedDate);
                                      int j = 0;
                                      for (int i = 0;
                                          i < data['LOG INDEX'];
                                          i++) {
                                        if (data['LOG'][i]['date'] ==
                                            formattedDate) {
                                          _database
                                              .child('$currUserID/LOG/$i/')
                                              .update({'selected': true});
                                          selected_dates.insert(
                                              j,
                                              '  ' +
                                                  LOG[i]['date'] +
                                                  '       ' +
                                                  LOG[i]['operation']);
                                          j++;
                                        } else {
                                          _database
                                              .child('$currUserID/LOG/$i/')
                                              .update({'selected': false});
                                        }
                                        //print('gg $selected_dates[0]');
                                        //print(data['LOG'][i]['date']);
                                      }

                                      //You can format date as per your need
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  height: 35,
                                  minWidth: 100,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.calendar_month),
                                      Text(
                                        '  Select Date  ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  textColor: Colors.white,
                                  color: Color(0xfff17f21),
                                  shape: const StadiumBorder(),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    int j = 0;
                                    for (int i = 0;
                                        i < data['LOG INDEX'];
                                        i++) {
                                      _database
                                          .child('$currUserID/LOG/$i/')
                                          .update({'selected': true});
                                    }

                                    //You can format date as per your need
                                  },
                                  height: 35,
                                  minWidth: 100,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.check_circle_outline),
                                      Text(
                                        ' See all history ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  textColor: Colors.white,
                                  color: Color(0xfff17f21),
                                  shape: const StadiumBorder(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Text(' Date          Time          Status',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 11, 0, 0))),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                                child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.075),
                                    itemCount: len,
                                    itemBuilder: (context, index) {
                                      Color c =
                                          Color.fromARGB(255, 205, 32, 38);
                                      if (LOG[index]['selected'] == true) {
                                        if (LOG[index]['operation']
                                                .toString()
                                                .substring(10, 14) ==
                                            'took') {
                                          c = Color.fromARGB(255, 46, 133, 64);
                                          print('im hereeeeeeeee');
                                        }
                                        return Card(
                                            elevation: 10,
                                            //color: Color.fromARGB(255, 12, 12, 10),
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      '  ' +
                                                          LOG[index]['date'] +
                                                          '      ' +
                                                          LOG[index]
                                                              ['operation'],
                                                      style: TextStyle(
                                                          fontSize: 16.5,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black)),
                                                  Icon(
                                                    c ==
                                                            Color.fromARGB(255,
                                                                46, 133, 64)
                                                        ? Icons.check_box
                                                        : Icons
                                                            .indeterminate_check_box,
                                                    color: c,
                                                  )
                                                ]));
                                      } else
                                        return SizedBox(
                                          width: 0,
                                          height: 0,
                                        );
                                    })),
                          ],
                        ),
                      ),
                    );
                  }
                })));
  }
}
