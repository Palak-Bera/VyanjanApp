import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/features/InitialScreens/roleSelector.dart';
import 'package:food_app/resources/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RoleSelector(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///replace [logo] image here
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset('assets/images/logo.jpg'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            padding:
                EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: primaryGreen,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0)),
            child: Text(
              'Pure veg',
              style: TextStyle(color: primaryGreen),
            ),
          )
        ],
      ),
    );
  }
}
