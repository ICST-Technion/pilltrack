import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot/models/currUser.dart';
import 'package:iot/shared.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot/validator.dart';
import 'package:iot/providers/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "sign_up_page";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

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

  UserData user = UserData(uid: '', name: '', password: '', refill_day: '');
  String dropdownvalue = user_type[0];
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusName.unfocus();
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Color(0xFFE1B60B),
                    Color(0xFFE5CE22),
                    Color(0xFFEADE98),
                  ])),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            SizedBox(
                              height: 30,
                            ),
                            // #signup_text
                            Text(
                              "Sign Up",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            // #welcome
                            Text(
                              "Welcome",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.brown, fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),

                          // #text_field
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
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
                                Form(
                                  key: _registerFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10.0),
                                      TextFormField(
                                        controller: _nameTextController,
                                        focusNode: _focusName,
                                        validator: (value) =>
                                            Validator.validateName(
                                          name: value,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          hintText: "Name",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
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
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        focusNode: _focusPassword,
                                        obscureText: true,
                                        validator: (value) =>
                                            Validator.validatePassword(
                                          password: value,
                                        ),
                                        decoration: InputDecoration(
                                          //border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          hintText: "Password",
                                          errorBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        //mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Text('  I am:     ',
                                              style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 119, 118, 117),
                                                  fontSize: 18)),
                                          SizedBox(width: 30),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                DropdownButton(
                                                  // Initial Value
                                                  value: dropdownvalue,

                                                  // Down Arrow Icon
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),

                                                  // Array list of items
                                                  items: user_type
                                                      .map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                  // After selecting the desired option,it will
                                                  // change button value to selected value
                                                  onChanged:
                                                      (String? newValue) {
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),

                          // #signup_button

                          _isProcessing
                              ? CircularProgressIndicator()
                              : MaterialButton(
                                  onPressed: () async {
                                    bool is_error = false;
                                    bool is_patient =
                                        dropdownvalue == 'The box user';
                                    setState(() {
                                      _isProcessing = true;
                                    });

                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      try {
                                        User? user = await FirebaseAuthHelper
                                            .registerUsingEmailPassword(
                                          name: _nameTextController.text.trim(),
                                          email:
                                              _emailTextController.text.trim(),
                                          password: _passwordTextController.text
                                              .trim(),
                                        );
                                      } on FirebaseAuthException catch (signUpError) {
                                        if (signUpError.code ==
                                            'email-already-exists') {
                                          fireToast(
                                              'Email already used. Enter a different one.');
                                          is_error = true;
                                        }
                                      }

                                      setState(() {
                                        _isProcessing = false;
                                      });

                                      if (!is_error && user != null) {
                                        if (is_patient) {
                                          _database
                                              .child('userID/info/')
                                              .update({
                                            'name':
                                                _nameTextController.text.trim(),
                                            'password': _passwordTextController
                                                .text
                                                .trim(),
                                            'email': _emailTextController.text
                                                .trim(),
                                          });
                                          Navigator.pushReplacementNamed(
                                              context, '/choose_refillday');
                                        } else {
                                          _database
                                              .child('monitor/info/')
                                              .update({
                                            'name':
                                                _nameTextController.text.trim(),
                                            'password': _passwordTextController
                                                .text
                                                .trim(),
                                            'email': _emailTextController.text
                                                .trim(),
                                          });
                                          Navigator.pushReplacementNamed(
                                              context, '/pages/log_page');
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        _isProcessing = false;
                                      });
                                    }
                                  },
                                  height: 45,
                                  minWidth: 240,
                                  shape: const StadiumBorder(),
                                  color: const Color(0xFFE5B60E),
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
