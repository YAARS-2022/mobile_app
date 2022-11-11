import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaars/data/bus_data_controller.dart';
import 'package:yaars/map/map.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BusDataController busDataController = Get.put(BusDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => navigateToMap(),
          child: const Text('Find Ashmit'),
        ),
      ),
    );
  }

  navigateToMap() async {
    await busDataController.getLocationOfChild(name: 'Ashmit');
    if (busDataController.receivedBusDataLocation.isNotEmpty) {
      var latitude = busDataController.receivedBusDataLocation[0]['latitude'];
      var longitude = busDataController.receivedBusDataLocation[0]['longitude'];

      print('From home: Latitude = $latitude,  Longitude = $longitude');

      Get.to(() => MapView(latitude: latitude, longitude: longitude));
    }
  }
}
