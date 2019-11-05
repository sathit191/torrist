import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:torrist/models/user_model.dart';
import 'package:torrist/screens/my_alert.dart';
import 'package:torrist/screens/my_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Explicit
  String resultCode = '';
  //Method

  Widget authenButton() {
    return RaisedButton(
      color: Colors.pinkAccent[700],
      child: Text(
        'Authentication',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print('คุณคลิ๊กปุ่ม');
        readQRCode();
      },
    );
  }

  Future<void> readQRCode() async {
    try {
      resultCode = await BarcodeScanner.scan();
      print('resultCode = $resultCode');
    } catch (e) {}
  }

  Future<void> getUserWhereResultCode() async {
    String urlAPI =
        'http://10.28.50.26/getUserWhereUserTor.php?isAdd=true&ResultCode=$resultCode';
    Response response = await get(urlAPI);
    //print('Response = $response');
    var result = json.decode(response.body);
    print('result = $result');

    if (result.toString() == 'null') {
      normalDialog('Result False', 'No $resultCode in My Database', context);
    } else {
      for (var map in result) {
        UserModel userModel = UserModel.fromJSON(map);
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) {
          return MyService(userModel: userModel,);
        });
        Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
            (Route<dynamic> route) {
          return false;
        });
      }
    }
  }

  Widget showLogo() {
    return Container(
      width: 150.0,
      height: 150.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Tor RIST',
      style: TextStyle(
        color: Colors.orange.shade900,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.purple],
              radius: 1.0,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                showAppName(),
                authenButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
