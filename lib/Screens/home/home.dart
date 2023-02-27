

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:taskify_project/Screens/home/description.dart';
import 'package:taskify_project/service/ad_mob.dart';

import 'add_task.dart';

String path = 'package:cloud_firestore/src/collection_reference.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd? _interstitialAd;

  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid;
  @override
  void initState() {
    uid = getuid();
    super.initState();
    _createInterstitialAd();
  }

  String getuid() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return (uid);

    // here you write the codes to input the data into firestore
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35))),
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          SizedBox(width: 10),
          Text("All Task's",
              style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 38)),
        ]),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(
                Icons.login,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () {
                _showInterstitialAd;
                FancySnackbar.showSnackbar(
                  context,
                  snackBarType: FancySnackBarType.success,
                  title: "Successfully Logged Out",
                  message: "",
                  duration: 4,
                );
                new Future.delayed(const Duration(seconds: 1), () {
                  FirebaseAuth.instance.signOut();
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('mytasks')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 90,
                  child: Center(child: const CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Image.asset("assets/no_data.jpg"),
                        Text('No Data Found',
                            style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 19)),
                      ],
                    ),
                  ),
                );
              }

              final doc = snapshot.data!.docs;
              return ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, index) {
                  var time = (doc[index]['timestamp'] as Timestamp).toDate();
                  print("working");

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                  title: doc[index]['title'],
                                  description: doc[index]['description'])));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                                color: Colors.black.withOpacity(0.2))
                          ]),
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    doc[index]['title'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                      DateFormat.MMMd().add_jm().format(time)),
                                )
                              ]),
                          Container(
                            child: IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(uid)
                                    .collection('mytasks')
                                    .doc(doc[index]['time'])
                                    .delete();
                                FancySnackbar.showSnackbar(
                                  context,
                                  snackBarType: FancySnackBarType.info,
                                  title: "Task Deleted",
                                  message: "",
                                  duration: 4,
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            // }
            ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
      ),
    );
  }
}
