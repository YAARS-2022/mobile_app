import 'package:get/get.dart';
import 'package:yaars/data/firestore_helper.dart';

class BusDataController extends GetxController {
  static var receivedBusDataLocation = <Map<String, dynamic>>[].obs;

  Future<void> getLocationOfChild({required String name}) async {
    var allBusData = await FSHelper.getData();
    int? indexOfChild;

    if (allBusData.isNotEmpty) {
      for (int i = 0; i < allBusData.length; i++) {
        var busData = allBusData[i];
        if (busData.names.contains(name)) {
          indexOfChild = i;
          receivedBusDataLocation.add({
            'latitude': busData.geoPoint.latitude,
            'longitude': busData.geoPoint.longitude
          });
          print(receivedBusDataLocation);
          break;
        }
      }

      if (indexOfChild != null) {
        print('$name is in index $indexOfChild');
      }
    }
  }
}
