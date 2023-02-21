import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot/pages/refill_box_page.dart';
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
import 'package:iot/login2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot/providers/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PillBox extends StatelessWidget {
  final _database = FirebaseDatabase.instance.ref();

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
    String next_hour = '', next_minute = '', prev_hour, prev_min;
    String next_label = 'Today', prev_label = 'Today', user_name = '';
    tz.TZDateTime date = getTimeNow();

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
                  String current_day = DateFormat('EEEE').format(date);

                  if (snapshot.hasData) {
                    final data = jsonDecode(jsonEncode(
                            (snapshot.data as DatabaseEvent).snapshot.value))
                        as Map<String, dynamic>;
                    //Map<String,dynamic>.from((snapshot.data as DatabaseEvent).snapshot.value);
                    final first_time = data['pill times']['first dose'];
                    final second_time = data['pill times']['second dose'];

                    tz.TZDateTime n = getTimeNow();
                    print(n);
                    //int first_time_in_min = (h1 * 60 + m1);
                    //int second_time_in_min = (h2 * 60 + m2);
                    int first_time_in_min = convert_to_minutes(first_time);
                    int second_time_in_min = convert_to_minutes(second_time);
                    int now_in_min = (n.hour * 60 + n.minute);
                    int dif1 = first_time_in_min - now_in_min;
                    print(dif1);
                    int dif2 = second_time_in_min - now_in_min;
                    if (dif1 >= 0) {
                      next_hour =
                          getHour(first_time).toString().padLeft(2, '0');
                      next_minute =
                          getMinutes(first_time).toString().padLeft(2, '0');
                      prev_hour =
                          getHour(second_time).toString().padLeft(2, '0');
                      prev_min =
                          getMinutes(second_time).toString().padLeft(2, '0');
                      next_label = 'Today';
                      prev_label = 'Yesterday';
                    } else if (dif2 >= 0) {
                      next_hour =
                          getHour(second_time).toString().padLeft(2, '0');
                      next_minute =
                          getMinutes(second_time).toString().padLeft(2, '0');
                      prev_hour =
                          getHour(first_time).toString().padLeft(2, '0');
                      prev_min =
                          getMinutes(first_time).toString().padLeft(2, '0');
                      next_label = 'Today';
                      prev_label = 'Today';
                    } else {
                      next_hour =
                          getHour(first_time).toString().padLeft(2, '0');
                      next_minute =
                          getMinutes(first_time).toString().padLeft(2, '0');
                      prev_hour =
                          getHour(second_time).toString().padLeft(2, '0');
                      prev_min =
                          getMinutes(second_time).toString().padLeft(2, '0');
                      String d = DateFormat('EEEE').format(getTimeNow());
                      if (days[d] == days[current_day]) {
                        next_label = 'Tomorrow';
                        prev_label = 'Today';
                      } else {
                        next_label = 'Today';
                        prev_label = 'Yesterday';
                      }
                    }

                    int next_in_min =
                        (int.parse(next_hour) * 60 + int.parse(next_minute));
                    int prev_in_minutes = 0;

                    /******* reminder 5 min before time ************/
                    //if(next_in_min-now_in_min<=reminder_before&& next_in_min-now_in_min>reminder_before-1){
                    try {
                      if (data['notification']['reminder'] == true)
                        _database
                            .child('$currUserID/notification/')
                            .update({'reminder': false});
                      print("reminder sent and returned to false state");
                    } catch (e) {
                      print('error in send reminder: $e');
                    }

                    /****************send late message after 15 min + to monitor *********************/

                    try {
                      print('inside late1');
                      final curr_status = data['notification']['taken_pill'];
                      final late1 = data['notification']['late1'];
                      if (curr_status == false && late1 == true) {
                        _database
                            .child('$currUserID/notification/')
                            .update({'late1': false});
                        print("first late message sent");
                      }
                    } catch (e) {
                      print('error in send late1: $e');
                    }

                    /***************** LATE / NOT TAKEN in 30min*********************/

                    try {
                      print('inside late2');
                      final curr_status = data['notification']['taken_pill'];
                      final late1 = data['notification']['late2'];
                      if (curr_status == false && late1 == true) {
                        //sendMail();
                        _database
                            .child('$currUserID/notification/')
                            .update({'late2': false});
                        print("second late message sent");
                      } else if (data['notification']['taken_pill'] == true) {
                        _database
                            .child('$currUserID/notification/')
                            .update({'taken_pill': false});
                      }
                    } catch (e) {
                      print('error in send late2: $e');
                    }

                    user_name = data['info']['name'];

                    /******************* CHANGE BOX STATES - ALL DAYS ***********/

                    String curr_day = 'Sunday';
                    for (int i = 0; i < 7; i++) {
                      curr_day = int_to_days[(i + 1) % 7]!;
                      final curr_day_status = data['taking pills'][curr_day];
                      //print(current_day);
                      String first = curr_day_status['first cell'];
                      String second = curr_day_status['second cell'];
                      Cell_info morning_cell = morning_cells[days[curr_day]!];
                      Cell_info evening_cell = evening_cells[days[curr_day]!];
                      if (first == 'taken') {
                        morning_cell.imageURL = 'assets/images/v.jpg';
                      } else if (first == 'late') {
                        morning_cell.imageURL = 'assets/images/late.png';
                      } else {
                        morning_cell.imageURL = 'assets/images/pill.jpg';
                      }

                      if (second == 'taken') {
                        evening_cell.imageURL = 'assets/images/v.jpg';
                      } else if (second == 'late') {
                        evening_cell.imageURL = 'assets/images/late.png';
                      } else {
                        evening_cell.imageURL = 'assets/images/pill.jpg';
                      }
                    }

                    if (data['systemOk'] == false) {
                      return RefillBoxPage();
                    }

                    return HomeBody(
                      h1: next_hour,
                      m1: next_minute,
                      h2: prev_hour,
                      m2: prev_min,
                      prev_label: prev_label,
                      next_label: next_label,
                      user_name: user_name,
                      refill_day: data['info']['refill day'].toString(),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }
}

class HomeBody extends StatelessWidget {
  final _database2 = FirebaseDatabase.instance.ref();
  String h1, m1, h2, m2, user_name;
  String next_label, prev_label;
  String refill_day;

  HomeBody(
      {required this.h1,
      required this.m1,
      required this.h2,
      required this.m2,
      required this.prev_label,
      required this.next_label,
      required this.user_name,
      required this.refill_day});

  void fireToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 204, 41, 29),
        textColor: Colors.white,
        fontSize: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return //SafeArea(
        //child:
        Column(
      children: <Widget>[
        TopContainer(
          height: 220,
          width: width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                'Welcome to your Pill Tracker\n Dear $user_name!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          20,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              'keep up with your pills easily',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0 *
                                    MediaQuery.of(context).textScaleFactor,
                                color: Colors.black45,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //subheading('Quick peak'),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            //margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            color: Color(0xfff3ceae),
                            elevation: 4,
                            child: MenuRow(
                                label: 'Prev Pill Time ',
                                time: '$prev_label $h2:$m2'),
                          ),
                          SizedBox(width: 7.0),
                          Card(
                            color: Color.fromARGB(255, 161, 237, 247),
                            elevation: 4,
                            child: MenuRow(
                                label: 'Next Pill Time ',
                                time: '$next_label $h1:$m1 '),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  child: Text(
                    'Your Lovely Pill Box',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: LightColors.kDarkBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  //color: Colors.blueAccent,
                  decoration: BoxDecoration(
                      //color: Color(0xff067280),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF205493),
                            Color(0xFF046B99),
                            //Color(0xFF2DAFD2),
                            Color(0xFF02BFE7),
                            Color(0xFF046B99),
                            Color(0xFF205493),
                          ])),
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(width: 17.0),
                          Text(
                            'Sun',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ), //maybe add things
                          SizedBox(width: 15.0),
                          Text(
                            'Mon',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Tues',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Wed',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Thur',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Fri',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            'Sat',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.sunny,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[0]),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[1]),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[2]),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[3]),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[4]),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[5]),
                          SizedBox(width: 10.0),
                          BoxCell(info: morning_cells[6]),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.nightlight_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[0]),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[1]),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[2]),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[3]),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[4]),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[5]),
                          SizedBox(width: 10.0),
                          BoxCell(info: evening_cells[6]),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  MaterialButton(
                    onPressed: () {
                      _database2
                          .child('$currUserID/')
                          .update({'search box': true});
                      Navigator.pushReplacementNamed(
                          context, '/pages/search_box_page');
                    },
                    height: 30,
                    minWidth: 100,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        Text(
                          'Search Box',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textColor: Colors.white,
                    color: Color(0xfff17f21),
                    shape: const StadiumBorder(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      String current_day =
                          DateFormat('EEEE').format(getTimeNow());
                      if (current_day == refill_day ||
                          days[current_day] == (days[refill_day]! + 1) % 7) {
                        _database2
                            .child('$currUserID/')
                            .update({'refill box': true});
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacementNamed(
                            context, '/pages/refill_box_page');
                      } else {
                        fireToast('Refill day is $refill_day! \n Not today!');
                      }
                    },
                    height: 30,
                    minWidth: 100,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        Text(
                          'Refill Box',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textColor: Colors.white,
                    color: Color(0xfff17f21),
                    shape: const StadiumBorder(),
                  ),
                ]),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ],
      //),
    );
  }
}
