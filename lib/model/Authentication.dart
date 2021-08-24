import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  String fullname;
  String email;
  String uid;
  String password;

  UserData({this.fullname, this.email, this.uid, this.password});
}

class UserAuth {
  String statusMsg = "Account Created Successfully";

  //To create new User
  Future<String> createUser(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email, password: userData.password);
    return statusMsg;
  }

  //To verify new User
  Future<String> verifyUser(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInWithEmailAndPassword(
        email: userData.email, password: userData.password);
    return "User Successfully Logged in";
  }

  Future logOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut();
  }
}
