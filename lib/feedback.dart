import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Feedback1 extends StatefulWidget {
  @override
  _Feedback1State createState() => _Feedback1State();
}

class _Feedback1State extends State<Feedback1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Color(0xff6190E8),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Image.network(
                    'https://cdn.dribbble.com/users/6458339/screenshots/14690891/media/b7a8bc22c81b7c4d589a0e441a857fa9.gif',
                    width: 350,
                    height: 330,
                    fit: BoxFit.contain,
                    //alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    "Dear User,",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            //https://cdn.dribbble.com/users/6458339/screenshots/14690891/media/b7a8bc22c81b7c4d589a0e441a857fa9.gif
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 2),
              child: Text(
                "                 Thanks for using our app we hope that you will found it very helpful we request you to share your experience with us by clicking on the below submit button. So, that we can help more people effectively.",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // isExtended: true,
        label: Text('Submit'),
        icon: Icon(Icons.send_rounded),
        backgroundColor: Color(0xff6190E8),
        onPressed: () {
          setState(() {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FeedbackForm()));
          });
        },
      ),
    );
  }
}

class FeedbackForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form'),
        backgroundColor: Color(0xff6190E8),
      ),
      body: Container(
        //margin: EdgeInsets.only(bottom: 50),
        height: double.infinity,
        width: double.infinity,
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl:
              'https://docs.google.com/forms/d/e/1FAIpQLSeOFSTYloiY_1BA-hUtbQhzVcreRKikSTeMZC-kV39CIhxPfQ/viewform',
        ),
      ),
    );
  }
}
