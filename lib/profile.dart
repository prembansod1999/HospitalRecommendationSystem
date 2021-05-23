import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restart_app/restart_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String gender = "", dob = "", name = "", path = "", email = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _fbLogin = new FacebookLogin();

  User user;
  File imageFile;
  final _formKey = GlobalKey<FormState>();

  Future<void> getData() async {
    User user = _auth.currentUser;
    setState(() {
      email = user.email;
    });
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
      setState(() {
        path = "";
      });
    }
  }

  Future<void> getInfo() async {
    await getData();
    await getPath();
    print(email);
    print(name);
    print(dob);
    print(gender);
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            IconButton(
                onPressed: () async {
                  for (UserInfo user in _auth.currentUser.providerData) {
                    if (user.providerId == "facebook.com") {
                      print("Facebook");
                      await _auth.signOut();
                      await _fbLogin.logOut();
                    } else if (user.providerId == "google.com") {
                      print("Google");
                      await _auth.signOut();
                      await _googleSignIn.signOut();
                    } else {
                      print("Email");
                      await _auth.signOut();
                    }
                  }
                  Restart.restartApp();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                imageFile == null
                                    ? new Container(
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: path.isEmpty
                                              ? new DecorationImage(
                                                  image: new ExactAssetImage(
                                                      'assets/images/profilePic.png'),
                                                  fit: BoxFit.cover,
                                                )
                                              : new DecorationImage(
                                                  image: NetworkImage(path),
                                                  fit: BoxFit.cover,
                                                ),
                                        ))
                                    : new ClipOval(
                                        child: Image.file(
                                          imageFile,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new IconButton(
                                        icon: Icon(Icons.camera_alt),
                                        color: Colors.white,
                                        onPressed: () {
                                          _showPicker(context);
                                        },
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Parsonal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status
                                            ? _getEditIcon()
                                            : new Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email ID',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new Text(email),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: !_status
                                          ? TextFormField(
                                              initialValue: name,
                                              decoration: const InputDecoration(
                                                  hintText: "Enter Your Name"),
                                              enabled: !_status,
                                              onChanged: (value) {
                                                setState(() {
                                                  name = value;
                                                });
                                              },
                                              validator: validateName,
                                            )
                                          : name.isEmpty
                                              ? TextFormField(
                                                  initialValue: name,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Enter Your Name"),
                                                  enabled: false,
                                                )
                                              : Text(name),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'DOB',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: !_status
                                          ? new DateTimePicker(
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              initialDate: dob.isEmpty
                                                  ? DateTime.now()
                                                  : DateTime.parse(dob),
                                              dateLabelText: dob,
                                              enabled: !_status,
                                              onChanged: (value) {
                                                setState(() {
                                                  dob = value;
                                                });
                                              },
                                              validator: (value) {
                                                if (dob.isEmpty)
                                                  return 'Select Date Of Birth';
                                                else
                                                  return null;
                                              },
                                            )
                                          : dob.isEmpty
                                              ? TextFormField(
                                                  initialValue: dob,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Enter Date Of Birth"),
                                                  enabled: false,
                                                )
                                              : Text(dob),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            _status
                                ? new Container(
                                    color: Color(0xffFFFFFF),
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 25.0),
                                        child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                          child: gender.isEmpty
                                                              ? TextFormField(
                                                                  initialValue:
                                                                      gender,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText:
                                                                              "Select Gender"),
                                                                  enabled:
                                                                      false,
                                                                )
                                                              : Text(gender)),
                                                    ],
                                                  )),
                                            ])))
                                : new Container(
                                    color: Color(0xffFFFFFF),
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 25.0),
                                        child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                          child:
                                                              new RadioListTile(
                                                                  title: Text(
                                                                      'Male'),
                                                                  value: 'Male',
                                                                  groupValue:
                                                                      gender,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      gender =
                                                                          value;
                                                                    });
                                                                  })),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                          child:
                                                              new RadioListTile(
                                                                  title: Text(
                                                                      'Female'),
                                                                  value:
                                                                      'Female',
                                                                  groupValue:
                                                                      gender,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      gender =
                                                                          value;
                                                                    });
                                                                  })),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                          child:
                                                              new RadioListTile(
                                                                  title: Text(
                                                                      'Other'),
                                                                  value:
                                                                      'Other',
                                                                  groupValue:
                                                                      gender,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      gender =
                                                                          value;
                                                                    });
                                                                  })),
                                                    ],
                                                  )),
                                            ]))),
                            !_status ? _getActionButtons() : new Container(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  String validateName(String value) {
    if (value.length < 2)
      return 'Name must be more than 1 charater';
    else
      return null;
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            child: new Text("Save"),
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              if (gender.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Select Gender",
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1);
              }
              if (_formKey.currentState.validate() && gender.isNotEmpty) {
                setState(() {
                  _status = true;
                  FocusScope.of(context).requestFocus(new FocusNode());
                  user = _auth.currentUser;
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .set({'name': name, 'dob': dob, 'gender': gender});
                });
              }
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  _getFromGallery() async {
    File pickedFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile.path);
  }

  _getFromCamera() async {
    File pickedFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      maxHeight: 140,
      maxWidth: 140,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      sourcePath: filePath,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
      user = _auth.currentUser;
      _firebaseStorage.ref(user.uid).child(user.uid).putFile(imageFile);
    }
  }

  Future<void> _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
