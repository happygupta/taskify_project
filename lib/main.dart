// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify_project/Screens/home/add_task.dart';
import 'package:taskify_project/service/Upcoming.dart';
import 'package:taskify_project/service/dailyTask.dart';
import 'Screens/splash.dart';
import 'demo.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // MobileAds.instance.initialize();

  runApp(const MyApp());
}

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  void _checkVersion() {
    // final newVersion = NewVersion(
    //   androidId: 'com.anoop.taskify',
    // );
    // newVersion.showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorkey,
      title: 'Taskify',
      theme: ThemeData(),
      home: SplashScreen(),
    );
  }
}
