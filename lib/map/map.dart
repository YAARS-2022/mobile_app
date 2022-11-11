import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:yaars/data/firestore_helper.dart';
import 'package:yaars/models/bus_data.dart';

class MapView extends StatelessWidget {
  final BusData busData;
  const MapView({super.key, required this.busData});

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
          latitude: busData.geoPoint.latitude,
          longitude: busData.geoPoint.longitude),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );

    getDataFromFirestore();

    return OSMFlutter(
      controller: mapController,
      trackMyPosition: true,
      initZoom: 12,
      minZoomLevel: 8,
      maxZoomLevel: 14,
      stepZoom: 1.0,
      userLocationMarker: UserLocationMaker(
        personMarker: const MarkerIcon(
          icon: Icon(
            Icons.location_history_rounded,
            color: Colors.red,
            size: 48,
          ),
        ),
        directionArrowMarker: const MarkerIcon(
          icon: Icon(
            Icons.double_arrow,
            size: 48,
          ),
        ),
      ),
      roadConfiguration: RoadConfiguration(
        startIcon: const MarkerIcon(
          icon: Icon(
            Icons.person,
            size: 64,
            color: Colors.brown,
          ),
        ),
        roadColor: Colors.yellowAccent,
      ),
      markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 56,
        ),
      )),
    );
    ;
  }

  void getDataFromFirestore() async {
    await FSHelper.getData();
  }
}
