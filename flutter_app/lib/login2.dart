import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot/pages/tabs_screen.dart';
import 'package:iot/shared.dart';
import 'package:firebase_database/firebase_database.dart';
import 'providers/firebase_auth.dart';
import '../validator.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  var token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    final _database = FirebaseDatabase.instance.ref();
  }

  void fireToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color.fromARGB(255, 204, 41, 29),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    final patient_email = _database.child('userID/info/email').get().toString();
    final monitor_email =
        _database.child('monitor/info/email').get().toString();

    if (user != null) {
      if (user.email == patient_email)
        Navigator.pushReplacementNamed(context, '/pages/tab_screen');
      else if (user.email == monitor_email) {
        Navigator.pushReplacementNamed(context, '/pages/log_page');
      }
    }

    return firebaseApp;
  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<DatabaseEvent> stream_patient =
        _database.child('userID/info/email').onValue;
    Stream<DatabaseEvent> stream_monitor =
        _database.child('monitor/info/email').onValue;

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 1, 60, 99),
                      Color.fromARGB(255, 33, 101, 143),
                      Color.fromARGB(255, 158, 224, 252),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(children: [
                  /// Login & Welcome back
                  Container(
                    height: 210,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 35),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
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
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              "assets/images/hi2.jpg",
                              height: 180,
                              width: 180,
                            ),
                            Column(children: [
                              /// Text Fields
                              Container(
                                padding: new EdgeInsets.all(10),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _emailTextController,
                                        focusNode: _focusEmail,
                                        validator: (value) =>
                                            Validator.validateEmail(
                                          email: value,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          hintText: "Email",
                                          icon: Icon(Icons.mail),
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 8.0),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        focusNode: _focusPassword,
                                        obscureText: true,
                                        validator: (value) =>
                                            Validator.validatePassword(
                                          password: value,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          hintText: "Password",
                                          icon: Icon(Icons.lock),
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //SizedBox(height: 24.0),
                                    ],
                                  ),
                                ),
                              ),
                            ]),

                            const SizedBox(height: 10),

                            _isProcessing
                                ? CircularProgressIndicator()
                                : MaterialButton(
                                    onPressed: () async {
                                      _focusEmail.unfocus();
                                      _focusPassword.unfocus();

                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        User? user = await FirebaseAuthHelper
                                            .signInUsingEmailPassword(
                                          email:
                                              _emailTextController.text.trim(),
                                          password: _passwordTextController.text
                                              .trim(),
                                        );

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user != null) {
                                          stream_patient
                                              .listen((DatabaseEvent event) {
                                            print(
                                                'Snapshot: ${event.snapshot}'); // DataSnapshot
                                            final patient_email = jsonDecode(
                                                jsonEncode(
                                                    event.snapshot.value));

                                            print(
                                                "patient email: $patient_email");

                                            if (user.email == patient_email) {
                                              print(
                                                  "i'm inside login as patient");
                                              //currUserType = 'patient';
                                              _database
                                                  .child(
                                                      'userID/fcm-token/${token}')
                                                  .update({"token": token});
                                              _database
                                                  .child('$currUserID/')
                                                  .update({'systemOk': true});
                                              Navigator.pushReplacementNamed(
                                                  context, '/pages/tab_screen');
                                            } else {
                                              print(token);
                                              _database
                                                  .child(
                                                      'monitor/fcm-token/${token}')
                                                  .update({"token": token});

                                              Navigator.pushReplacementNamed(
                                                  context, '/pages/log_page');
                                            }
                                          });
                                        } else {
                                          fireToast(
                                              'Wrong email or password. Try again!');
                                          _emailTextController.clear();
                                          _passwordTextController.clear();
                                        }
                                      }
                                    },
                                    height: 45,
                                    minWidth: 240,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    textColor: Colors.white,
                                    color: Color.fromARGB(255, 2, 107, 160),
                                    shape: const StadiumBorder(),
                                  ),

                            const SizedBox(height: 30),

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
                                    Navigator.pushNamed(
                                        context, '/pages/signup');
                                  },
                                  height: 45,
                                  minWidth: 140,
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textColor: Colors.white,
                                  color: Color.fromARGB(255, 25, 23, 23),
                                  shape: const StadiumBorder(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),

                            /// Rich Text & Toast
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
