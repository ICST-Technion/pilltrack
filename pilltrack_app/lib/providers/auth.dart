import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:iot/models/currUser.dart';
//import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database= FirebaseDatabase.instance.ref();

  // create user obj based on firebase user
  currUser _userFromFirebaseUser(User user) {
    return currUser(uid: user.uid);

  }

  // auth change user stream
  Stream<currUser> get user {
    return _auth.authStateChanges()
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {


    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future register(String userID, String password, String firstName,
      String secondName,Email emergency_mail) async {
    try {


    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      //return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}