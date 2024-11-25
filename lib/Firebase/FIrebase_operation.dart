import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseOperation {
  GoogleSignIn googleSignin=GoogleSignIn();
  FirebaseAuth _auth=FirebaseAuth.instance;
  Future<void> AddDetails (Map<String,dynamic> detailsMap,String id) async{
      return await FirebaseFirestore.instance.collection("Details").doc(id).set(detailsMap);
}

  Future deletedetails(String id) async{
    return await FirebaseFirestore.instance.collection('Details').doc(id).delete();
  }

  Future updateAll(Map<String, dynamic> infoDetails,String id) async{
    return await FirebaseFirestore.instance.collection('Details').doc(id).update(infoDetails);
  }
}