// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// / import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class BusData {
  int bus_number;
  GeoPoint geoPoint;
  String school;
  List<String> names;
  BusData({
    required this.bus_number,
    required this.geoPoint,
    required this.school,
    required this.names,
  });

  BusData copyWith({
    int? bus_number,
    GeoPoint? geoPoint,
    String? school,
    List<String>? names,
  }) {
    return BusData(
      bus_number: bus_number ?? this.bus_number,
      geoPoint: geoPoint ?? this.geoPoint,
      school: school ?? this.school,
      names: names ?? this.names,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bus_number': bus_number,
      'geoPoint': geoPoint,
      'school': school,
      'names': names,
    };
  }

  factory BusData.fromMap(Map<String, dynamic> map) {
    // print("Type of name: ")
    return BusData(
        bus_number: map['Bus Number'] as int,
        geoPoint: map['geometry'],
        school: map['School'] as String,
        names: List<String>.from(
          (map['name'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory BusData.fromJson(String source) =>
      BusData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BusData(bus_number: $bus_number, geoPoint: $geoPoint, school: $school, names: $names)';
  }

  @override
  bool operator ==(covariant BusData other) {
    if (identical(this, other)) return true;

    return other.bus_number == bus_number &&
        other.geoPoint == geoPoint &&
        other.school == school &&
        listEquals(other.names, names);
  }

  @override
  int get hashCode {
    return bus_number.hashCode ^
        geoPoint.hashCode ^
        school.hashCode ^
        names.hashCode;
  }
}
