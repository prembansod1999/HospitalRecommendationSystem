import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/hospitalList.dart';
import 'package:location/location.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class DiseaseList extends StatefulWidget {
  @override
  _DiseaseListState createState() => new _DiseaseListState();
}

class _DiseaseListState extends State<DiseaseList> {
  TextEditingController textEditingContr = new TextEditingController();

  @override
  void initState() {
    super.initState();
    determinePosition();

    setState(() {
      filterlist = diseaseNames;
    });
  }

  @override
  void dispose() {
    textEditingContr.dispose();
    super.dispose();
  }

  String disease = "";
  List<String> diseaseNames = [
    "(vertigo) Paroymsal  Positional Vertigo",
    "Acne",
    "AIDS",
    "Alcoholic hepatitis",
    "Allergy",
    "Arthritis",
    "Bronchial Asthma",
    "Cervical spondylosis",
    "Chicken pox",
    "Chronic cholestasis",
    "Common Cold",
    "Dengue",
    "Diabetes",
    "Dimorphic hemmorhoids(piles)",
    "Drug Reaction",
    "Fungal infection",
    "Gastroenteritis",
    "GERD",
    "Heart attack",
    "Hepatitis A",
    "Hepatitis B",
    "Hepatitis C",
    "Hepatitis D",
    "Hepatitis E",
    "Hypertension",
    "Hyperthyroidism",
    "Hypoglycemia",
    "Hypothyroidism",
    "Impetigo",
    "Jaundice",
    "Malaria",
    "Migraine",
    "Osteoarthristis",
    "Paralysis (brain hemorrhage)",
    "Peptic ulcer disease",
    "Pneumonia",
    "Psoriasis",
    "Tuberculosis",
    "Typhoid",
    "Urinary tract infection",
    "Varicose veins"
  ];
  List<String> filterlist = [];
  bool isSearching = false;
  var locationStr;
  List<String> arr = [];

  List<String> hospitalName = [];
  List<String> review = [];
  List<String> noOfReviewers = [];
  List<String> hospitalAddr = [];
  List<String> distance = [];

  void searchData(String data) {
    setState(() {
      filterlist.clear();
    });
    if (data.isEmpty) {
      return;
    }

    setState(() {
      diseaseNames.forEach((dis) {
        if (dis.toLowerCase().contains(data.toLowerCase())) filterlist.add(dis);
      });
    });
  }

  Future<Map<String, dynamic>> getHospitalList(var arr) async {
    final response = await http.post(
      Uri.parse('https://captnemo.pythonanywhere.com//getHospitals'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(arr),
    );
    Map<String, dynamic> decoded = {};
    if (response.statusCode == 200) {
      decoded = json.decode(response.body);
    } else {
      print('Error occur in sending');
    }
    return decoded;
  }

  LocationData _locationData;
  void determinePosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      this._locationData = _locationData;
      arr.add(_locationData.latitude.toString());
      arr.add(_locationData.longitude.toString());
      locationStr = _locationData.latitude.toString() +
          " " +
          _locationData.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !this.isSearching
              ? Text("Select Disease")
              : TextField(
                  controller: textEditingContr,
                  onChanged: (value) {
                    searchData(value);
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                    ),
                    hintText: "Search Disease",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
          actions: [
            !this.isSearching
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                        filterlist = [];
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        this.isSearching = false;
                        filterlist = diseaseNames;
                        textEditingContr.clear();
                      });
                    },
                  )
          ]),
      body: isSearching
          ? ListView.builder(
              itemCount: filterlist.length,
              itemBuilder: (context, index) {
                return Container(
                  color: filterlist[index] == disease ? Colors.blue : null,
                  child: ListTile(
                    title: Text(filterlist[index]),
                    selectedTileColor: Colors.blue,
                    onTap: () {
                      setState(() {
                        disease = filterlist[index];
                      });
                    },
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: diseaseNames.length,
              itemBuilder: (context, index) {
                return Container(
                  color: diseaseNames[index] == disease
                      ? Colors.blue
                      : null, // if current item is selected show blue color

                  child: ListTile(
                    title: Text(diseaseNames[index]),
                    selectedTileColor: Colors.blue,
                    onTap: () {
                      setState(() {
                        disease = diseaseNames[index];
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.next_plan),
        onPressed: () async {
          if (disease.isEmpty) {
            Fluttertoast.showToast(
                msg: "Select Disease",
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1);
          } else {
            setState(() {
              arr.add(disease);
            });
            Map<String, dynamic> decoded = await showDialog(
              context: context,
              builder: (context) => FutureProgressDialog(getHospitalList(arr),
                  message: Text('Loading...')),
            );

            hospitalName.clear();
            hospitalAddr.clear();
            review.clear();
            noOfReviewers.clear();
            distance.clear();
            setState(() {
              for (var h_name in decoded.keys) {
                hospitalName.add(h_name);
                review.add(double.parse(decoded[h_name]['review'])
                    .toStringAsPrecision(2));
                noOfReviewers.add(decoded[h_name]['count']);
                hospitalAddr.add(decoded[h_name]['address']);
                distance.add(decoded[h_name]['distance']);
              }
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HospitalList(
                  hospitalAddr: this.hospitalAddr,
                  hospitalName: this.hospitalName,
                  noOfReviewers: this.noOfReviewers,
                  review: this.review,
                  distance: this.distance,
                  locationStr: this.locationStr,
                ),
              ),
            );
          }

          setState(() {
            arr.remove(disease);
            disease = "";
          });
        },
      ),
    );
  }
}
