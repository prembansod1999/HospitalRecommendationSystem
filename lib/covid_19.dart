import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Covid19 extends StatelessWidget {
  const Covid19({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid-19 Active Cases'),          
        backgroundColor: Color(0xff6190E8),
      ),
      body: Container(//margin: EdgeInsets.only(bottom: 50),
        height: double.infinity,
        width: double.infinity,
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.covid19india.org/state/MH',
        ),
      ),
    );
  }
}