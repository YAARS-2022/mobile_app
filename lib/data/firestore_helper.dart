import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaars/models/bus_data.dart';

class FSHelper {
  static late FirebaseFirestore _db;

  static init() {
    _db = FirebaseFirestore.instance;
  }

  static getData() async {
    await _db.collection("Buses").get().then((event) {
      for (var doc in event.docs) {
        var busData = BusData.fromMap(doc.data());
        print(busData);
      }
    });
  }
}
