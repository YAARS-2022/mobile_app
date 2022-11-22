import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaars/data/firestore_helper.dart';

class BusDataController extends GetxController {

  var receivedBusDataLocation = <Map<String, dynamic>>[].obs;

  Future<void> getLocationOfChild({required String name}) async {
    final storage = GetStorage();
    storage.write('child', name);
    var allBusData = await FSHelper.getData();
    int? indexOfChild;

    if (allBusData.isNotEmpty) {
      for (int i = 0; i < allBusData.length; i++) {
        var busData = allBusData[i];
        if (busData.names.contains(name)) {
          indexOfChild = i;
          receivedBusDataLocation.add({
            'latitude': busData.geoPoint.latitude,
            'longitude': busData.geoPoint.longitude,
            'number': busData.bus_number,
            'driver': busData.driver,
            'phone': busData.phone,
          });
          break;
        }
      }

      if (indexOfChild != null) {
        print('$name is in index $indexOfChild');
      }
    }
  }

  static Future<GeoPoint?> getBusLocation(String name) async {
    var busDataList = await FSHelper.getData();
    for (var busData in busDataList){
      var names = busData.names;
      if(names.contains(name)){
        double latitude = busData.geoPoint.latitude;
        double longitude = busData.geoPoint.longitude;
        return GeoPoint(latitude: latitude, longitude: longitude);
      }
    }
    return null;
  }
}
