import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding.dart';

class Splash extends StatefulWidget {
  static const routeName = '/';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // show splash for 2 seconds then go to onboarding
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, Onboarding.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    // simple centered logo + name
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 96),
            SizedBox(height: 16),
            Text("Omnia's Store",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
