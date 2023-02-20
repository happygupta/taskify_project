import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskify_project/Screens/home/home.dart';
import 'package:taskify_project/main.dart';
import './onBoarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_new
    new Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                   StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went Wront!'));
                } else if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return Onboarding();
                }
              }
              )
                      ),
            )
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF6E40),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    );
  }
}
