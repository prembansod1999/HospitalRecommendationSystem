import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'hospitalList.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

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
    Symptom(name: 'Acute Liver Failure', val: 'acute_liver_failure'),
    Symptom(name: 'Altered Sensorium', val: 'altered_sensorium'),
    Symptom(name: 'Anxiety', val: 'anxiety'),
    Symptom(name: 'Back Pain', val: 'back_pain'),
    Symptom(name: 'Belly Pain', val: 'belly_pain'),
    Symptom(name: 'Blackheads', val: 'blackheads'),
    Symptom(name: 'Bladder Discomfort', val: 'bladder_discomfort'),
    Symptom(name: 'Blister', val: 'blister'),
    Symptom(name: 'Blood In Sputum', val: 'blood_in_sputum'),
    Symptom(name: 'Bloody Stool', val: 'bloody_stool'),
    Symptom(
        name: 'Blurred and Distorted Vision',
        val: 'blurred_and_distorted_vision'),
    Symptom(name: 'Breathlessness', val: 'breathlessness'),
    Symptom(name: 'Brittle Nails', val: 'brittle_nails'),
    Symptom(name: 'Bruising', val: 'bruising'),
    Symptom(name: 'Burning Micturition', val: 'burning_micturition'),
    Symptom(name: 'Chest Pain', val: 'chest_pain'),
    Symptom(name: 'Chills', val: 'chills'),
    Symptom(name: 'Cold Hands and Feets', val: 'cold_hands_and_feets'),
    Symptom(name: 'Coma', val: 'coma'),
    Symptom(name: 'Congestion', val: 'congestion'),
    Symptom(name: 'Constipation', val: 'constipation'),
    Symptom(name: 'Continuous Feel of Urine', val: 'continuous_feel_of_urine'),
    Symptom(name: 'Continuous Sneezing', val: 'continuous_sneezing'),
    Symptom(name: 'Cough', val: 'cough'),
    Symptom(name: 'Cramps', val: 'cramps'),
    Symptom(name: 'Dark Urine', val: 'dark_urine'),
    Symptom(name: 'Dehydration', val: 'dehydration'),
    Symptom(name: 'Depression', val: 'depression'),
    Symptom(name: 'Diarrhoea', val: 'diarrhoea'),
    Symptom(name: 'Dischromic Patches', val: 'dischromic _patches'),
    Symptom(name: 'Distention of Abdomen', val: 'distention_of_abdomen'),
    Symptom(name: 'Dizziness', val: 'dizziness'),
    Symptom(name: 'Drying and Tingling Lips', val: 'drying_and_tingling_lips'),
    Symptom(name: 'Enlarged Thyroid', val: 'enlarged_thyroid'),
    Symptom(name: 'Excessive Hunger', val: 'excessive_hunger'),
    Symptom(name: 'Extra Marital Contacts', val: 'extra_marital_contacts'),
    Symptom(name: 'Family History', val: 'family_history'),
    Symptom(name: 'Fast Heart Rate', val: 'fast_heart_rate'),
    Symptom(name: 'Fatigue', val: 'fatigue'),
    Symptom(name: 'Fluid Overload', val: 'fluid_overload'),
    Symptom(name: 'Foul Smell of Urine', val: 'foul_smell_of urine'),
    Symptom(name: 'Headache', val: 'headache'),
    Symptom(name: 'High Fever', val: 'high_fever'),
    Symptom(name: 'Hip Joint Pain', val: 'hip_joint_pain'),
    Symptom(
        name: 'History of Alcohol Consumption',
        val: 'history_of_alcohol_consumption'),
    Symptom(name: 'Increased Appetite', val: 'increased_appetite'),
    Symptom(name: 'Indigestion', val: 'indigestion'),
    Symptom(name: 'Inflammatory Nails', val: 'inflammatory_nails'),
    Symptom(name: 'Internal Itching', val: 'internal_itching'),
    Symptom(name: 'Irregular Sugar Level', val: 'irregular_sugar_level'),
    Symptom(name: 'Irritability', val: 'irritability'),
    Symptom(name: 'Irritation in Anus', val: 'irritation_in_anus'),
    Symptom(name: 'Itching', val: 'itching'),
    Symptom(name: 'Joint Pain', val: 'joint_pain'),
    Symptom(name: 'Knee Pain', val: 'knee_pain'),
    Symptom(name: 'Lack of Concentration', val: 'lack_of_concentration'),
    Symptom(name: 'Lethargy', val: 'lethargy'),
    Symptom(name: 'Loss of Appetite', val: 'loss_of_appetite'),
    Symptom(name: 'Loss of Balance', val: 'loss_of_balance'),
    Symptom(name: 'Loss of Smell', val: 'loss_of_smell'),
    Symptom(name: 'Malaise', val: 'malaise'),
    Symptom(name: 'Mild Fever', val: 'mild_fever'),
    Symptom(name: 'Mood Swings', val: 'mood_swings'),
    Symptom(name: 'Movement Stiffness', val: 'movement_stiffness'),
    Symptom(name: 'Mucoid Sputum', val: 'mucoid_sputum'),
    Symptom(name: 'Muscle Pain', val: 'muscle_pain'),
    Symptom(name: 'Muscle Wasting', val: 'muscle_wasting'),
    Symptom(name: 'Muscle Weakness', val: 'muscle_weakness'),
    Symptom(name: 'Nausea', val: 'nausea'),
    Symptom(name: 'Neck Pain', val: 'neck_pain'),
    Symptom(name: 'Nodal Skin Eruptions', val: 'nodal_skin_eruptions'),
    Symptom(name: 'Obesity', val: 'obesity'),
    Symptom(name: 'Pain Behind the Eyes', val: 'pain_behind_the_eyes'),
    Symptom(
        name: 'Pain During Bowel Movements',
        val: 'pain_during_bowel_movements'),
    Symptom(name: 'Pain in Anal Region', val: 'pain_in_anal_region'),
    Symptom(name: 'Painful Walking', val: 'painful_walking'),
    Symptom(name: 'Palpitations', val: 'palpitations'),
    Symptom(name: 'Passage of gases', val: 'passage_of_gases'),
    Symptom(name: 'Patches in Throat', val: 'patches_in_throat'),
    Symptom(name: 'Phlegm', val: 'phlegm'),
    Symptom(name: 'Polyuria', val: 'polyuria'),
    Symptom(name: 'Prominent Veins on Calf', val: 'prominent_veins_on_calf'),
    Symptom(name: 'Puffy Face and Eyes', val: 'puffy_face_and_eyes'),
    Symptom(name: 'Pus Filled Pimples', val: 'pus_filled_pimples'),
    Symptom(
        name: 'Receiving Blood Transfusion',
        val: 'receiving_blood_transfusion'),
    Symptom(
        name: 'Receiving Unsterile Injections',
        val: 'receiving_unsterile_injections'),
    Symptom(name: 'Red Sore Around Nose', val: 'red_sore_around_nose'),
    Symptom(name: 'Red Spots Over Body', val: 'red_spots_over_body'),
    Symptom(name: 'Redness of Eyes', val: 'redness_of_eyes'),
    Symptom(name: 'Restlessness', val: 'restlessness'),
    Symptom(name: 'Runny Nose', val: 'runny_nose'),
    Symptom(name: 'Rusty Sputum', val: 'rusty_sputum'),
    Symptom(name: 'Scurring', val: 'scurring'),
    Symptom(name: 'Shivering', val: 'shivering'),
    Symptom(name: 'Silver Like Dusting', val: 'silver_like_dusting'),
    Symptom(name: 'Sinus Pressure', val: 'sinus_pressure'),
    Symptom(name: 'Skin Peeling', val: 'skin_peeling'),
    Symptom(name: 'Skin Rash', val: 'skin_rash'),
    Symptom(name: 'Slurred Speech', val: 'slurred_speech'),
    Symptom(name: 'Small Dents in Nails', val: 'small_dents_in_nails'),
    Symptom(name: 'Spinning Movements', val: 'spinning_movements'),
    Symptom(name: 'Spotting Urination', val: 'spotting_ urination'),
    Symptom(name: 'Stiff Neck', val: 'stiff_neck'),
    Symptom(name: 'Stomach Bleeding', val: 'stomach_bleeding'),
    Symptom(name: 'Stomach Pain', val: 'stomach_pain'),
    Symptom(name: 'Sunken Eyes', val: 'sunken_eyes'),
    Symptom(name: 'Sweating', val: 'sweating'),
    Symptom(name: 'Swelled Lymph Nodes', val: 'swelled_lymph_nodes'),
    Symptom(name: 'Swelling Joints', val: 'swelling_joints'),
    Symptom(name: 'Swelling of Stomach', val: 'swelling_of_stomach'),
    Symptom(name: 'Swollen Blood Vessels', val: 'swollen_blood_vessels'),
    Symptom(name: 'Swollen Extremeties', val: 'swollen_extremeties'),
    Symptom(name: 'Swollen Legs', val: 'swollen_legs'),
    Symptom(name: 'Throat Irritation', val: 'throat_irritation'),
    Symptom(name: 'Toxic Look (Typhos)', val: 'toxic_look_(typhos)'),
    Symptom(name: 'Ulcers on Tongue', val: 'ulcers_on_tongue'),
    Symptom(name: 'Unsteadiness', val: 'unsteadiness'),
    Symptom(name: 'Visual Disturbances', val: 'visual_disturbances'),
    Symptom(name: 'Vomiting', val: 'vomiting'),
    Symptom(name: 'Watering From Eyes', val: 'watering_from_eyes'),
    Symptom(name: 'Weakness in Limbs', val: 'weakness_in_limbs'),
    Symptom(
        name: 'Weakness of One Body Side', val: 'weakness_of_one_body_side'),
    Symptom(name: 'Weight Gain', val: 'weight_gain'),
    Symptom(name: 'Weight Loss', val: 'weight_loss'),
    Symptom(name: 'Yellow Crust Ooze', val: 'yellow_crust_ooze'),
    Symptom(name: 'Yellow Urine', val: 'yellow_urine'),
    Symptom(name: 'Yellowing of Eyes', val: 'yellowing_of_eyes'),
    Symptom(name: 'Yellowish Skin', val: 'yellowish_skin')
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
          backgroundColor: Color(0xff6190E8),
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
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search Symptom",
                    hintStyle: TextStyle(color: Colors.white54),
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
      body: Container(
        color: Colors.white,
        child: isSearching
            ? ListView.builder(
                padding: new EdgeInsets.only(bottom: 20),
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
                      padding: new EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 5.0),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: ListTile(
                        title: new Text("${filterlist[index].name}"),
                      ),
                      decoration: multiSelectContr2.isSelected(index)
                          ? new BoxDecoration(
                              border: Border.all(color: Color(0xff6190E8)),
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xffA7BFE8))
                          : new BoxDecoration(
                              border: Border.all(color: Color(0xffA7BFE8)),
                              borderRadius: BorderRadius.circular(50)),
                    ),
                  );
                },
              )
            : ListView.builder(
                padding: new EdgeInsets.only(bottom: 20),
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
                      padding: new EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 5.0),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 7),
                      child: ListTile(
                        title: new Text("${mainList[index].name}"),
                      ),
                      decoration: multiSelectContr.isSelected(index)
                          ? new BoxDecoration(
                              border: Border.all(color: Color(0xff6190E8)),
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xffA7BFE8))
                          : new BoxDecoration(
                              border: Border.all(color: Color(0xffA7BFE8)),
                              borderRadius: BorderRadius.circular(50)),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color(0xff6190E8),
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
        child: new Icon(Icons.navigate_next),
      ),
    );
  }
}
