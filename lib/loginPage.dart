import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/symptomList.dart';

class LogIn extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> _longIn(LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
    } catch (e) {
      return 'Invalid Credential';
    }
    return null;
  }

  Future<String> _recoverPassword(String data) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: data,
      );
    } catch (e) {
      return 'Invalid Email';
    }
    return null;
  }

  Future<String> _signUp(LoginData data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
    } catch (e) {
      return 'Username Already Present';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Hospital',
      onLogin: _longIn,
      onSignup: _signUp,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SymptomList(),
        ));
      },
    );
  }
}
