import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'hospitalList.dart';

class Symptom {
  final String name;
  final String val;
  Symptom({this.name, this.val});
}

class SymptomList extends StatefulWidget {
  @override
  _SymptomListState createState() => new _SymptomListState();
}

class _SymptomListState extends State<SymptomList> {
  MultiSelectController multiSelectContr = new MultiSelectController();
  MultiSelectController multiSelectContr2 = new MultiSelectController();
  TextEditingController textEditingContr = new TextEditingController();
  bool isSearching = false;

  List<Symptom> mainList = [
    Symptom(name: 'Abdominal Pain', val: 'abdominal_pain'),
    Symptom(name: 'Abnormal Menstruation', val: 'abnormal_menstruation'),
    Symptom(name: 'Acidity', val: 'acidity'),
    Symptom(name: 'acute_liver_failure', val: 'acute_liver_failure'),
    Symptom(name: 'altered_sensorium', val: 'altered_sensorium'),
    Symptom(name: 'anxiety', val: 'anxiety'),
    Symptom(name: 'back_pain', val: 'back_pain'),
    Symptom(name: 'belly_pain', val: 'belly_pain'),
    Symptom(name: 'blackheads', val: 'blackheads'),
    Symptom(name: 'bladder_discomfort', val: 'bladder_discomfort'),
    Symptom(name: 'blister', val: 'blister'),
    Symptom(name: 'blood_in_sputum', val: 'blood_in_sputum'),
    Symptom(name: 'bloody_stool', val: 'bloody_stool'),
    Symptom(
        name: 'blurred_and_distorted_vision',
        val: 'blurred_and_distorted_vision'),
    Symptom(name: 'breathlessness', val: 'breathlessness'),
    Symptom(name: 'brittle_nails', val: 'brittle_nails'),
    Symptom(name: 'bruising', val: 'bruising'),
    Symptom(name: 'burning_micturition', val: 'burning_micturition'),
    Symptom(name: 'chest_pain', val: 'chest_pain'),
    Symptom(name: 'chills', val: 'chills'),
    Symptom(name: 'cold_hands_and_feets', val: 'cold_hands_and_feets'),
    Symptom(name: 'coma', val: 'coma'),
    Symptom(name: 'congestion', val: 'congestion'),
    Symptom(name: 'constipation', val: 'constipation'),
    Symptom(name: 'continuous_feel_of_urine', val: 'continuous_feel_of_urine'),
    Symptom(name: 'continuous_sneezing', val: 'continuous_sneezing'),
    Symptom(name: 'cough', val: 'cough'),
    Symptom(name: 'cramps', val: 'cramps'),
    Symptom(name: 'dark_urine', val: 'dark_urine'),
    Symptom(name: 'dehydration', val: 'dehydration'),
    Symptom(name: 'depression', val: 'depression'),
    Symptom(name: 'diarrhoea', val: 'diarrhoea'),
    Symptom(name: 'dischromic _patches', val: 'dischromic _patches'),
    Symptom(name: 'distention_of_abdomen', val: 'distention_of_abdomen'),
    Symptom(name: 'dizziness', val: 'dizziness'),
    Symptom(name: 'drying_and_tingling_lips', val: 'drying_and_tingling_lips'),
    Symptom(name: 'enlarged_thyroid', val: 'enlarged_thyroid'),
    Symptom(name: 'excessive_hunger', val: 'excessive_hunger'),
    Symptom(name: 'extra_marital_contacts', val: 'extra_marital_contacts'),
    Symptom(name: 'family_history', val: 'family_history'),
    Symptom(name: 'fast_heart_rate', val: 'fast_heart_rate'),
    Symptom(name: 'fatigue', val: 'fatigue'),
    Symptom(name: 'fluid_overload', val: 'fluid_overload'),
    Symptom(name: 'foul_smell_of urine', val: 'foul_smell_of urine'),
    Symptom(name: 'headache', val: 'headache'),
    Symptom(name: 'high_fever', val: 'high_fever'),
    Symptom(name: 'hip_joint_pain', val: 'hip_joint_pain'),
    Symptom(
        name: 'history_of_alcohol_consumption',
        val: 'history_of_alcohol_consumption'),
    Symptom(name: 'increased_appetite', val: 'increased_appetite'),
    Symptom(name: 'indigestion', val: 'indigestion'),
    Symptom(name: 'inflammatory_nails', val: 'inflammatory_nails'),
    Symptom(name: 'internal_itching', val: 'internal_itching'),
    Symptom(name: 'irregular_sugar_level', val: 'irregular_sugar_level'),
    Symptom(name: 'irritability', val: 'irritability'),
    Symptom(name: 'irritation_in_anus', val: 'irritation_in_anus'),
    Symptom(name: 'itching', val: 'itching'),
    Symptom(name: 'joint_pain', val: 'joint_pain'),
    Symptom(name: 'knee_pain', val: 'knee_pain'),
    Symptom(name: 'lack_of_concentration', val: 'lack_of_concentration'),
    Symptom(name: 'lethargy', val: 'lethargy'),
    Symptom(name: 'loss_of_appetite', val: 'loss_of_appetite'),
    Symptom(name: 'loss_of_balance', val: 'loss_of_balance'),
    Symptom(name: 'loss_of_smell', val: 'loss_of_smell'),
    Symptom(name: 'malaise', val: 'malaise'),
    Symptom(name: 'mild_fever', val: 'mild_fever'),
    Symptom(name: 'mood_swings', val: 'mood_swings'),
    Symptom(name: 'movement_stiffness', val: 'movement_stiffness'),
    Symptom(name: 'mucoid_sputum', val: 'mucoid_sputum'),
    Symptom(name: 'muscle_pain', val: 'muscle_pain'),
    Symptom(name: 'muscle_wasting', val: 'muscle_wasting'),
    Symptom(name: 'muscle_weakness', val: 'muscle_weakness'),
    Symptom(name: 'nausea', val: 'nausea'),
    Symptom(name: 'neck_pain', val: 'neck_pain'),
    Symptom(name: 'nodal_skin_eruptions', val: 'nodal_skin_eruptions'),
    Symptom(name: 'obesity', val: 'obesity'),
    Symptom(name: 'pain_behind_the_eyes', val: 'pain_behind_the_eyes'),
    Symptom(
        name: 'pain_during_bowel_movements',
        val: 'pain_during_bowel_movements'),
    Symptom(name: 'pain_in_anal_region', val: 'pain_in_anal_region'),
    Symptom(name: 'painful_walking', val: 'painful_walking'),
    Symptom(name: 'palpitations', val: 'palpitations'),
    Symptom(name: 'passage_of_gases', val: 'passage_of_gases'),
    Symptom(name: 'patches_in_throat', val: 'patches_in_throat'),
    Symptom(name: 'phlegm', val: 'phlegm'),
    Symptom(name: 'polyuria', val: 'polyuria'),
    Symptom(name: 'prominent_veins_on_calf', val: 'prominent_veins_on_calf'),
    Symptom(name: 'puffy_face_and_eyes', val: 'puffy_face_and_eyes'),
    Symptom(name: 'pus_filled_pimples', val: 'pus_filled_pimples'),
    Symptom(
        name: 'receiving_blood_transfusion',
        val: 'receiving_blood_transfusion'),
    Symptom(
        name: 'receiving_unsterile_injections',
        val: 'receiving_unsterile_injections'),
    Symptom(name: 'red_sore_around_nose', val: 'red_sore_around_nose'),
    Symptom(name: 'red_spots_over_body', val: 'red_spots_over_body'),
    Symptom(name: 'redness_of_eyes', val: 'redness_of_eyes'),
    Symptom(name: 'restlessness', val: 'restlessness'),
    Symptom(name: 'runny_nose', val: 'runny_nose'),
    Symptom(name: 'rusty_sputum', val: 'rusty_sputum'),
    Symptom(name: 'scurring', val: 'scurring'),
    Symptom(name: 'shivering', val: 'shivering'),
    Symptom(name: 'silver_like_dusting', val: 'silver_like_dusting'),
    Symptom(name: 'sinus_pressure', val: 'sinus_pressure'),
    Symptom(name: 'skin_peeling', val: 'skin_peeling'),
    Symptom(name: 'skin_rash', val: 'skin_rash'),
    Symptom(name: 'slurred_speech', val: 'slurred_speech'),
    Symptom(name: 'small_dents_in_nails', val: 'small_dents_in_nails'),
    Symptom(name: 'spinning_movements', val: 'spinning_movements'),
    Symptom(name: 'spotting_ urination', val: 'spotting_ urination'),
    Symptom(name: 'stiff_neck', val: 'stiff_neck'),
    Symptom(name: 'stomach_bleeding', val: 'stomach_bleeding'),
    Symptom(name: 'stomach_pain', val: 'stomach_pain'),
    Symptom(name: 'sunken_eyes', val: 'sunken_eyes'),
    Symptom(name: 'sweating', val: 'sweating'),
    Symptom(name: 'swelled_lymph_nodes', val: 'swelled_lymph_nodes'),
    Symptom(name: 'swelling_joints', val: 'swelling_joints'),
    Symptom(name: 'swelling_of_stomach', val: 'swelling_of_stomach'),
    Symptom(name: 'swollen_blood_vessels', val: 'swollen_blood_vessels'),
    Symptom(name: 'swollen_extremeties', val: 'swollen_extremeties'),
    Symptom(name: 'swollen_legs', val: 'swollen_legs'),
    Symptom(name: 'throat_irritation', val: 'throat_irritation'),
    Symptom(name: 'toxic_look_(typhos)', val: 'toxic_look_(typhos)'),
    Symptom(name: 'ulcers_on_tongue', val: 'ulcers_on_tongue'),
    Symptom(name: 'unsteadiness', val: 'unsteadiness'),
    Symptom(name: 'visual_disturbances', val: 'visual_disturbances'),
    Symptom(name: 'vomiting', val: 'vomiting'),
    Symptom(name: 'watering_from_eyes', val: 'watering_from_eyes'),
    Symptom(name: 'weakness_in_limbs', val: 'weakness_in_limbs'),
    Symptom(
        name: 'weakness_of_one_body_side', val: 'weakness_of_one_body_side'),
    Symptom(name: 'weight_gain', val: 'weight_gain'),
    Symptom(name: 'weight_loss', val: 'weight_loss'),
    Symptom(name: 'yellow_crust_ooze', val: 'yellow_crust_ooze'),
    Symptom(name: 'yellow_urine', val: 'yellow_urine'),
    Symptom(name: 'yellowing_of_eyes', val: 'yellowing_of_eyes'),
    Symptom(name: 'yellowish_skin', val: 'yellowish_skin')
  ];

  List<Symptom> filterlist;

  @override
  void initState() {
    super.initState();
    setState(() {
      filterlist = mainList;
    });
    determinePosition();
    multiSelectContr.disableEditingWhenNoneSelected = true;
  }

  List<String> printData() {
    List<String> arr = [];
    List<int> indexex = multiSelectContr.selectedIndexes;
    for (int i in indexex) {
      arr.add("${mainList[i].val}");
    }
    print(arr);
    return arr;
  }

  void searchData(String data) {
    setState(() {
      filterlist.clear();
    });
    if (data.isEmpty) {
      return;
    }

    setState(() {
      mainList.forEach((sympt) {
        if (sympt.name.toLowerCase().contains(data.toLowerCase()))
          filterlist.add(sympt);
      });
    });
  }

  var locationStr;

  List<String> hospitalName = [];
  List<String> review = [];
  List<String> noOfReviewers = [];
  List<String> hospitalAddr = [];
  List<String> distance = [];

  Future<Map<String, dynamic>> getHospitalList(var arr) async {
    final response = await http.post(
      Uri.parse('https://captnemo.pythonanywhere.com//predictDisease'),
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
      locationStr = _locationData.latitude.toString() +
          " " +
          _locationData.longitude.toString();
      //print(locationStr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !this.isSearching
              ? Text("Select Symptoms")
              : TextField(
                  controller: textEditingContr,
                  onChanged: (value) {
                    searchData(value);
                    setState(() {
                      for (int i = 0; i < filterlist.length; i++) {
                        int ind = mainList.indexWhere((element) =>
                            element.name == "${filterlist[i].name}");
                        if (multiSelectContr.isSelected(ind)) {
                          multiSelectContr2.select(i);
                        } else {
                          multiSelectContr2.deselect(i);
                        }
                      }
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                    ),
                    hintText: "Search Symptom",
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
                        filterlist = mainList;
                        textEditingContr.clear();
                      });
                    },
                  )
          ]),
      body: isSearching
          ? ListView.builder(
              itemCount: filterlist.length,
              itemBuilder: (context, index) {
                return MultiSelectItem(
                  isSelecting: true,
                  onSelected: () {
                    setState(() {
                      multiSelectContr2.toggle(index);
                      int i = mainList.indexWhere((element) =>
                          element.name == "${filterlist[index].name}");

                      if (multiSelectContr2.isSelected(index)) {
                        multiSelectContr.select(i);
                      } else {
                        multiSelectContr.deselect(i);
                      }
                    });
                  },
                  child: Container(
                    child: ListTile(
                      title: new Text("${filterlist[index].name}"),
                    ),
                    decoration: multiSelectContr2.isSelected(index)
                        ? new BoxDecoration(color: Colors.grey[300])
                        : new BoxDecoration(),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: mainList.length,
              itemBuilder: (context, index) {
                return MultiSelectItem(
                  isSelecting: true,
                  onSelected: () {
                    setState(() {
                      multiSelectContr.toggle(index);
                    });
                  },
                  child: Container(
                    child: ListTile(
                      title: new Text("${mainList[index].name}"),
                    ),
                    decoration: multiSelectContr.isSelected(index)
                        ? new BoxDecoration(color: Colors.grey[300])
                        : new BoxDecoration(),
                  ),
                );
              },
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          List<String> arr = printData();
          if (arr.isEmpty) {
            Fluttertoast.showToast(
                msg: "Select Symptoms",
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1);
          } else {
            arr.add(locationStr);
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
            multiSelectContr.deselectAll();
          });
        },
        child: new Icon(Icons.next_plan),
      ),
    );
  }
}
