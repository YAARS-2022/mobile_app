import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapView extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapView({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(latitude: latitude, longitude: longitude),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );

    var staticPointOfChild = StaticPositionGeoPoint(
        'child',
        const MarkerIcon(
          iconWidget: const Text('Ashmit'),
        ),
        [GeoPoint(latitude: latitude, longitude: longitude)]);

    List<StaticPositionGeoPoint> staticPoints = [staticPointOfChild];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: OSMFlutter(
        staticPoints: staticPoints,
        controller: mapController,
        trackMyPosition: false,
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
      ),
    );
  }
}
