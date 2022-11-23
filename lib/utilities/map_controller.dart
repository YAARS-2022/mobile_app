import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaars/data/bus_data_controller.dart';
import 'dart:developer' as developer;

import 'package:yaars/data/firestore_helper.dart';

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
    static String? id;

    MarkerIcon childMarkerOnMap = MarkerIcon(
      assetMarker: AssetMarker(
          image: const AssetImage('assets/marker.png'), scaleAssetImage: 4),
    );

    setMapController(String name) async {

      developer.log("Setting the map controller", name: "RouteController");

      GeoPoint? childBusLocation = await BusDataController.getBusLocation(name);
      GeoPoint? userLocation = await getUserLocation();

      developer.log("The id of bus where $name is is: $id", name: "RouteController");

      if(childBusLocation == null){
        Get.snackbar(
          'No Data Found',
          'We could not find $name in our database.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Add child's bus marker

        // await mapController.value.addMarker(childBusLocation, markerIcon: childMarkerOnMap);

        await mapController.value.setStaticPosition([childBusLocation], 'childBus');
        await mapController.value.setMarkerOfStaticPoint(id: 'childBus', markerIcon: childMarkerOnMap);

        drawRoad(childBusLocation, userLocation);

        if(id != null){
          FSHelper.listenToUpdates('Buses', id!);
        }
      }

    }

    changeLocation(GeoPoint geoPoint)async{
      developer.log('New location : ${geoPoint.latitude}, ${geoPoint.longitude}');
      await mapController.value.setStaticPosition([geoPoint],'childBus' );
      drawRoad(geoPoint);
    }

    static setBusId(String? idStr){
      id = idStr;
    }

    drawRoad(GeoPoint start, [GeoPoint? end]) async {
      end ??= await getUserLocation();
      RoadInfo roadInfo = await mapController.value.drawRoad(
        start,
        end,
        roadType: RoadType.car,
        roadOption: const RoadOption(
          roadWidth: 10,
          roadColor: Colors.blue,
          showMarkerOfPOI: false,
          zoomInto: true,
        ),
      );
    }

  Future<GeoPoint> getUserLocation() async {
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if(!locationServiceEnabled){
      return Future.error('Location services disabled.');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      return Future.error('Location permissions are denied');
    }

    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var parentLat = userLocation.latitude;
    var parentLon = userLocation.longitude;

    return GeoPoint(latitude: parentLat, longitude: parentLon);
  }
}