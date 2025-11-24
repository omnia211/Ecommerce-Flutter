import 'package:flutter/material.dart';
import 'features/auth/login.dart';

class Onboarding extends StatelessWidget {
  static const routeName = '/onboarding';
  @override
  Widget build(BuildContext context) {
    // Very simple 1-page onboarding with "Get Started"
    return Scaffold(
      appBar: AppBar(
          title: Text("Welcome"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag, size: 120),
                    SizedBox(height: 16),
                    Text(
                      "Shop the best products\nfrom Omnia's Store",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: SizedBox(
                width: double.infinity,
                child: Center(child: Text("Get Started")),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
