import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginPage.dart';

import 'navigate.dart';

bool stat = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user = _auth.currentUser;
  runApp(MaterialApp(home: user == null ? LogIn() : Navigate()));
}
