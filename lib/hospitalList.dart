import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalList extends StatelessWidget {
  HospitalList(
      {Key key,
      this.hospitalName,
      this.hospitalAddr,
      this.review,
      this.distance,
      this.noOfReviewers,
      this.locationStr})
      : super(key: key);

  final List<String> hospitalName,
      review,
      noOfReviewers,
      hospitalAddr,
      distance;
  final String locationStr;

  @override
  Widget build(BuildContext context) {
    int size = hospitalName.length;

    print(size);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6190E8),
        title: Text("Best Hospitals for You!"),
      ),
      body: new ListView(
        padding: EdgeInsets.only(bottom: 20),
        children: new List.generate(size, (int index) {
          return new Container(
            margin: const EdgeInsets.only(
              top: 10.0,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: Color(0XffF9F8F8),
              border: Border.all(
                color: Color(0xff6190E8),
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 7.0),
            child: new Column(
              children: <Widget>[
                new Align(
                  child: new Text(
                    hospitalName.elementAt(index),
                    style: new TextStyle(fontSize: 25.0),
                  ), //so big text
                  alignment: FractionalOffset.topLeft,
                ),
                new Divider(
                  color: Color(0xff6190E8),
                  thickness: 1,
                ),
                new Align(
                  child: new Text(hospitalAddr[index]),
                  alignment: FractionalOffset.topLeft,
                ),
                new Divider(
                  color: Color(0xff6190E8),
                  thickness: 1,
                ),
                new Align(
                  child: new Text("Number of Reviewers: " +
                      noOfReviewers.elementAt(index)),
                  alignment: FractionalOffset.topLeft,
                ),
                new Divider(
                  color: Color(0xff6190E8),
                  thickness: 1,
                ),
                /*new Align(
                  child: new Text("Distance: " + distance.elementAt(index)),
                  alignment: FractionalOffset.topLeft,
                ),*/
                new Align(
                  child: new Text("Review: " + review.elementAt(index)),
                  alignment: FractionalOffset.topRight,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //add some actions, icons...etc
                    new IconButton(
                        icon: Icon(Icons.directions_outlined),
                        color: Color(0xff6190E8),
                        iconSize: 35,
                        onPressed: () async {
                          String dest = Uri.encodeComponent(
                              hospitalAddr.elementAt(index));
                          String src = locationStr;
                          String _url = 'https://www.google.co.in/maps/dir/' +
                              src +
                              '/' +
                              dest +
                              '/';
                          await canLaunch(_url)
                              ? await launch(_url)
                              : throw 'Could not launch $_url';
                        }),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
