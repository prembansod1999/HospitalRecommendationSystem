import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'navigate.dart';

class LogIn extends StatefulWidget {
  LogIn({Key key}) : super(key: key);
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _fbLogin = new FacebookLogin();

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
        onSubmitAnimationCompleted: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Navigate(),
          ));
        },
        theme: LoginTheme(
          primaryColor: Color(0xff6190E8),
        ),
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
