import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaars/models/bus_data.dart';

class FSHelper {
  static late FirebaseFirestore _db;

  static init() {
    _db = FirebaseFirestore.instance;
  }

  static Future<List<BusData>> getData() async {
    var busDataList = <BusData>[];
    await _db.collection("Buses").get().then((event) {
      for (var doc in event.docs) {
        var busData = BusData.fromMap(doc.data());
        busDataList.add(busData);
        print(busData);
      }
    });

    return busDataList;
  }
}
