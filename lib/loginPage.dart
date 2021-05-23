import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'navigate.dart';

class LogIn extends StatefulWidget {
  LogIn({Key key}) : super(key: key);
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _fbLogin = new FacebookLogin();

  String email = "", name = "", gender = "", dob = "", path = "";

  Future<String> _longIn(LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      await getData();
      await getPath();
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
      await getData();
      await getPath();
    } catch (e) {
      return 'Username Already Present';
    }
    return null;
  }

  Future<void> getData() async {
    User user = _auth.currentUser;

    email = user.email;
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(user.uid)
        .get();
    Map<String, dynamic> decode = userData.data();
    if (decode != null) {
      for (var u_name in decode.keys) {
        if (u_name == 'gender') {
          setState(() {
            gender = decode[u_name];
          });
        } else if (u_name == 'dob') {
          setState(() {
            dob = decode[u_name];
          });
        } else {
          setState(() {
            name = decode[u_name];
          });
        }
      }
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({'name': "", 'dob': "", 'gender': ""});
    }
  }

  Future<void> getPath() async {
    User user = _auth.currentUser;
    try {
      await _firebaseStorage
          .ref(user.uid)
          .child(user.uid)
          .getDownloadURL()
          .then((value) {
        if (value.isNotEmpty) {
          setState(() {
            path = value;
          });
        }
      });
    } catch (e) {
      path = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: 'Hospital',
        onLogin: _longIn,
        onSignup: _signUp,
        onRecoverPassword: _recoverPassword,
        onSubmitAnimationCompleted: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Navigate(
                email: this.email,
                dob: this.dob,
                gender: this.gender,
                name: this.name,
                path: this.path),
          ));
        },
        loginProviders: <LoginProvider>[
          LoginProvider(
            icon: FontAwesomeIcons.google,
            callback: () async {
              try {
                GoogleSignInAccount googleSignInAccount =
                    await _googleSignIn.signIn();
                GoogleSignInAuthentication googleSignInAuthentication =
                    await googleSignInAccount.authentication;
                AuthCredential credential = GoogleAuthProvider.credential(
                  accessToken: googleSignInAuthentication.accessToken,
                  idToken: googleSignInAuthentication.idToken,
                );
                await FirebaseAuth.instance.signInWithCredential(credential);
                await getData();
                await getPath();
                return null;
              } catch (e) {
                return 'Invalid Credential';
              }
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.facebookF,
            callback: () async {
              try {
                _fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
                final FacebookLoginResult facebookLoginResult =
                    await _fbLogin.logIn(['email']);
                if (facebookLoginResult.status ==
                    FacebookLoginStatus.loggedIn) {
                  FacebookAccessToken facebookAccessToken =
                      facebookLoginResult.accessToken;
                  final AuthCredential credential =
                      FacebookAuthProvider.credential(
                          facebookAccessToken.token);
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  await getData();
                  await getPath();
                  return null;
                }
                return 'Invalid Credential';
              } catch (e) {
                return 'Invalid Credential';
              }
            },
          ),
        ]);
  }
}
