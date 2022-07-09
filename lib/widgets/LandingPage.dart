import 'package:flutter/material.dart';

import '../httpClient.dart';
import 'WAQrScannerScreen.dart';

class LandingPage extends StatefulWidget {
  final String userId;

  LandingPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageStatefulWidget();
}

class LandingPageStatefulWidget extends State<LandingPage> {

  static const String _title = 'Welcome To GMS';


  Future _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/login');
              logout();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Logout') {
               _onWillPop();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Welcome ${widget.userId}'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => WAQrScannerScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
