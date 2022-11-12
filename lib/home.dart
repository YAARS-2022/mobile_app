import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaars/data/bus_data_controller.dart';
import 'package:yaars/map/map.dart';
import 'package:yaars/utilities/distance_measurement.dart';
import 'package:yaars/utilities/notification_manager.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BusDataController busDataController = Get.put(BusDataController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(children: [
        Expanded(
          child: Stack(
            children: [
              Image.asset(
                'assets/school.jpg',
                fit: BoxFit.fill,
                height: 500,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Icon(
                          Icons.school,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Sahayatri',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => navigateToMap(),
          child: Container(
            width: 1080,
            height: 100,
            color: Colors.blueAccent,
            alignment: Alignment.center,
            child: const Text(
              "Find my child",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        )
      ]),
    );
  }

  navigateToMap() async {
    double distance = await DistanceMeasurement.measureDistance();

    await busDataController.getLocationOfChild(name: 'Ashmit');
    if (busDataController.receivedBusDataLocation.isNotEmpty) {
      var latitude = busDataController.receivedBusDataLocation[0]['latitude'];
      var longitude = busDataController.receivedBusDataLocation[0]['longitude'];
      var busNumber = busDataController.receivedBusDataLocation[0]['number'];
      var driver = busDataController.receivedBusDataLocation[0]['driver'];
      var phone = busDataController.receivedBusDataLocation[0]['phone'];

      Get.to(() => MapView(
            latitude: latitude,
            longitude: longitude,
            number: busNumber,
            driver: driver,
            phone: phone,
        distance: distance,
          ));
    }
  }
}
