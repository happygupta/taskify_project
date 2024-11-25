import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOperation {
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