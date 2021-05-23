import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  final String email, name, gender, dob, path;

  Profile({Key key, this.dob, this.email, this.gender, this.name, this.path})
      : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String gender = "", dob = "", name = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  User user;
  File imageFile;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.name.isNotEmpty) {
      setState(() {
        name = widget.name;
      });
    }
    if (widget.dob.isNotEmpty) {
      setState(() {
        dob = widget.dob;
      });
    }
    if (widget.gender.isNotEmpty) {
      setState(() {
        gender = widget.gender;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
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
                                          image: widget.path.isEmpty
                                              ? new DecorationImage(
                                                  image: new ExactAssetImage(
                                                      'assets/images/profilePic.png'),
                                                  fit: BoxFit.cover,
                                                )
                                              : new DecorationImage(
                                                  image:
                                                      NetworkImage(widget.path),
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
                                      child: new TextFormField(
                                        initialValue: widget.email,
                                        enabled: false,
                                      ),
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
                                      child: new TextFormField(
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
                                      ),
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
                                    !_status
                                        ? new Flexible(
                                            child: new DateTimePicker(
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
                                            ),
                                          )
                                        : new Flexible(
                                            child: new TextFormField(
                                            initialValue: dob,
                                            enabled: false,
                                          )),
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
                                                          child:
                                                              new TextFormField(
                                                                  initialValue:
                                                                      gender,
                                                                  enabled:
                                                                      false)),
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
