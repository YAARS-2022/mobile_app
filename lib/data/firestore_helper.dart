import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaars/models/bus_data.dart';
import 'dart:developer';

class FSHelper {
  static late FirebaseFirestore _db;

  static init() {
    _db = FirebaseFirestore.instance;
  }

  static Future<List<BusData>> getData() async {
    var busDataList = <BusData>[];
    await _db.collection("Buses").get().then((event) {
      for (var doc in event.docs) {
        var id = doc.id;
        var busData = BusData.fromMap(doc.data());
        busData.setId(id);
        busDataList.add(busData);
        log(busData.toString(), name: "FSHelper");
      }
    });

    return busDataList;
  }

  static void listenToUpdates(String collection, String documentID) {
    final docRef = _db.collection(collection).doc(documentID);
    docRef.snapshots().listen((event) {
      log('Current data is ${event.data()}', name: 'FSHelper');
    }, onError: (error) {
      log('An error has occurred. $error', name: 'FSHelper');
    });
  }
}
