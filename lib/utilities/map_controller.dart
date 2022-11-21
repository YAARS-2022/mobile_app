import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:yaars/data/bus_data_controller.dart';
import 'dart:developer' as developer;

class RouteController extends GetxController{

    static final mapController = MapController(
      initMapWithUserPosition: true,
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    ).obs;

    MarkerIcon childMarkerOnMap = MarkerIcon(
      assetMarker: AssetMarker(
          image: const AssetImage('assets/marker.png'), scaleAssetImage: 4),
    );

    setMapController(String name) async {

      developer.log("Setting the map controller", name: "RouteController");

      GeoPoint? childBusLocation = await BusDataController.getBusLocation(name);

      if(childBusLocation == null){
        Get.snackbar(
          'No Data Found',
          'We could not find $name in our database.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Add child's bus marker

        await mapController.value.addMarker(childBusLocation, markerIcon: childMarkerOnMap);

        var newMapController = MapController(
          initMapWithUserPosition: true,
          areaLimit: BoundingBox(
            east: 10.4922941,
            north: 47.8084648,
            south: 45.817995,
            west: 5.9559113,
          ),
        );

        await newMapController.addMarker(childBusLocation, markerIcon: childMarkerOnMap);

        mapController.value = newMapController;
      }

    }
}