import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigate.dart';

var sp = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sp = prefs.getBool('isLoggedIn') ?? false;
  print(sp);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: sp == false ? LogIn() : Navigate(),
    );
  }
}
