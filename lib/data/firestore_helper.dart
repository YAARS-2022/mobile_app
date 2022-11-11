import 'package:cloud_firestore/cloud_firestore.dart';

class FSHelper {
  static late FirebaseFirestore _db;

  static init() {
    _db = FirebaseFirestore.instance;
  }

  static getData() async {
    await _db.collection("Buses").get().then((event) {
      for (var doc in event.docs) {
        print("Doc ID: ${doc.id}");
        print("Data : ${doc.data()}");
      }
    });
  }
}
