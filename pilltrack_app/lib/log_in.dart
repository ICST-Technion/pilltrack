import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iot/pages/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:ui';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
  }

  void fireToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void fireToast2(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade900,
              Colors.green,
              Colors.green.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            /// Login & Welcome back
            Container(
              height: 210,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// LOGIN TEXT
                  Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.5,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 7.5),

                  /// WELCOME
                  Text('Welcome Back',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(height: 50),
                    //Image.asset('assets/images/doc_pill.png',
                    //height: 70, width: 70),

                    /// Text Fields
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 10,
                                offset: const Offset(0, 10)),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          /// EMAIL
                          TextField(
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: 'Email',
                                //icon: Icon(Icons.email_outlined,),
                                isCollapsed: false,
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ),
                          Divider(
                            color: Colors.black54,
                            height: 1,
                            thickness: 1,
                          ),

                          /// PASSWORD
                          TextField(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                hintText: 'Password',
                                //icon: Icon(Icons.password),
                                isCollapsed: false,
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),

                    /// LOGIN BUTTON
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/pages/tab_screen');
                        //final url=Uri.parse('https://test-244b7-default-rtdb.firebaseio.com/test.json');
                        //http.post(url, body:json.encode({'please':'yes'}));
                      },
                      height: 45,
                      minWidth: 240,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      textColor: Colors.white,
                      color: Colors.green.shade700,
                      shape: const StadiumBorder(),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 25),

                    /// TEXT
                    const Text(
                      'Not registered yet?',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/pages/signup');
                          },
                          height: 45,
                          minWidth: 140,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white,
                          color: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    /// Rich Text & Toast
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
