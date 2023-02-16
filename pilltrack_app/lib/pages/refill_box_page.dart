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

class RefillBoxPage extends StatefulWidget {
  @override
  _RefillBoxPage createState() => _RefillBoxPage();
}

class _RefillBoxPage extends State<RefillBoxPage> {
  final _database = FirebaseDatabase.instance.ref();

  /*
  final DatabaseReference database=FirebaseDatabase.instance.ref();

  late StreamSubscription _stream;
  //late TimeOfDay first_dose_time;
  TimeOfDay first_dose_time = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay second_dose_time = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    super.initState();
    //database = FirebaseDatabase.instance.ref();
    _activateListeners();
    //_performSingleFetch();


  }

  void _activateListeners(){
    int h1=0,h2=0,m1=0,m2=0;
    _stream = database.child('userID/pill times').onValue.listen((event) {
      //final extractedTimes =new Map<String, dynamic>.from(event.snapshot.value as Map<String, dynamic>);
      //print(event.snapshot.value.toString());
      final extractedTimes = jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      final  first_time= extractedTimes['first dose'];
      final  second_time= extractedTimes['second dose'];
      h1 = int.parse(first_time.substring(0,2));
      m1 = int.parse(first_time.substring(3,5));
      h2 = int.parse(second_time.substring(0,2));
      m2 = int.parse(second_time.substring(3,5));
      setState(() {
        first_dose_time = TimeOfDay(hour: h1, minute: m1);
        second_dose_time = TimeOfDay(hour: h2, minute: m2);
      });
    });
  }

*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  'Refilling the Box ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'please fill every cell with pills',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 45, 91)),
                      ),
                      Image.asset("assets/images/full_box2.jpg"),
                      //Image.asset("assets/images/refilled.png",width: 200, height: 200,),
                      SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                        onPressed: () {
                          _database
                              .child('userID/')
                              .update({'refill box': false});
                          _database.child('userID/').update({'systemOk': true});
                          sysOK = 1;
                          String curr_day = 'Sunday';
                          for (int i = 0; i < 7; i++) {
                            curr_day = int_to_days[(i + 1) % 7]!;
                            _database
                                .child('$currUserID/taking pills/$curr_day/')
                                .update({'first cell': 'pill'});
                            _database
                                .child('$currUserID/taking pills/$curr_day/')
                                .update({'second cell': 'pill'});
                          }
                          Navigator.pushReplacementNamed(
                              context, '/pages/tab_screen');
                        },
                        height: 40,
                        minWidth: 130,
                        child: const Text(
                          'Confirm refilling the box',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        color: Color.fromARGB(255, 60, 116, 238),
                        //icon: Icon(Icons.confirmation_num),
                        shape: const StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

/*
  @override
  void deactivate(){
    _stream.cancel();
    super.deactivate();
  }


 */

}
