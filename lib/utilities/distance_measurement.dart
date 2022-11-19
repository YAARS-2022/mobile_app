import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaars/data/bus_data_controller.dart';
import 'package:yaars/utilities/notification_manager.dart';
import 'dart:developer' as developer;

class DistanceMeasurement {
  static Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  static Future<double> measureDistance() async {
    final notificationController = Get.put(NotificationController());
    double? parentLat, parentLon;
    double childLat, childLon;

    getNewParentLocation();

    parentLat = GetStorage().read('parentLat');
    parentLon = GetStorage().read('parentLon');

    String? child = GetStorage().read('child');

    BusDataController busDataController = Get.put(BusDataController());

    if (child != null && parentLat != null && parentLon != null) {
      await busDataController.getLocationOfChild(name: child);
      childLat = busDataController.receivedBusDataLocation[0]['latitude'];
      childLon = busDataController.receivedBusDataLocation[0]['longitude'];
      developer.log('Child: Lat: $childLat, Lon: $childLon', name: 'DistanceMeasurement');
      developer.log('Parent: Lat: $parentLat, Lon: $parentLon', name: 'DistanceMeasurement');

      var distance =
          Geolocator.distanceBetween(childLat, childLon, parentLat, parentLon);
      developer.log('The distance is $distance', name: 'DistanceMeasurement');

      notificationController.sendNotification();

      return distance;
    } else {
      developer.log('No child or parent location stored stored', name: 'DistanceMeasurement');
      return 100.0;
    }
  }

  static void getNewParentLocation() async {
    Position currentPosition = await determinePosition();
    var parentLat = currentPosition.latitude;
    var parentLon = currentPosition.longitude;

    await GetStorage().write('parentLat', parentLat);
    await GetStorage().write('parentLon', parentLon);
  }
}
