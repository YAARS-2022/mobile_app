import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yaars/models/bus_data.dart';
import 'dart:developer';
import 'package:flutter_osm_interface/flutter_osm_interface.dart' as osm;
import 'package:yaars/utilities/map_controller.dart';

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
    final routeController = Get.put(RouteController());
    final docRef = _db.collection(collection).doc(documentID);
    docRef.snapshots().listen((event) {
      log('Current data is ${event.data()}', name: 'FSHelper');
      if(event.data() != null) {
        var busData = BusData.fromMap(event.data()!);
        var newGeopoint = osm.GeoPoint(latitude: busData.geoPoint.latitude,longitude:  busData.geoPoint.longitude);
        routeController.changeLocation(newGeopoint);
      }
    }, onError: (error) {
      log('An error has occurred. $error', name: 'FSHelper');
    });
  }
}
