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
        title: Text("New Page"),
      ),
      body: new ListView(
        children: new List.generate(size, (int index) {
          return new Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: new Column(
              children: <Widget>[
                new Align(
                  child: new Text(
                    hospitalName.elementAt(index),
                    style: new TextStyle(fontSize: 30.0),
                  ), //so big text
                  alignment: FractionalOffset.topLeft,
                ),
                new Divider(
                  color: Colors.blue,
                ),
                new Align(
                  child: new Text(hospitalAddr[index]),
                  alignment: FractionalOffset.topLeft,
                ),
                new Divider(
                  color: Colors.blue,
                ),
                new Align(
                  child: new Text(
                      "Number of reviewers " + noOfReviewers.elementAt(index)),
                  alignment: FractionalOffset.topLeft,
                ),
                new Divider(
                  color: Colors.blue,
                ),
                new Align(
                  child: new Text("Distance " + distance.elementAt(index)),
                  alignment: FractionalOffset.topLeft,
                ),
                new Align(
                  child: new Text("Review " + review.elementAt(index)),
                  alignment: FractionalOffset.topRight,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //add some actions, icons...etc
                    new IconButton(
                        icon: Icon(Icons.directions),
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
