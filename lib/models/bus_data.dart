// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// / import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class BusData {
  String? id;
  int busNumber;
  GeoPoint geoPoint;
  String school;
  List<String> names;
  String driver;
  String phone;

  BusData({
    required this.busNumber,
    required this.geoPoint,
    required this.school,
    required this.names,
    required this.driver,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bus_number': busNumber,
      'geoPoint': geoPoint,
      'school': school,
      'names': names,
    };
  }

  factory BusData.fromMap(Map<String, dynamic> map) {
    // print("Type of name: ")
    return BusData(
        busNumber: map['number'] as int,
        geoPoint: map['geometry'],
        school: map['School'] as String,
        names: List<String>.from(
          (map['name'] as List<dynamic>),
        ),
        driver: map['driver'] as String,
        phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusData.fromJson(String source) =>
      BusData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BusData(id: $id, bus_number: $busNumber, geoPoint: $geoPoint, school: $school, names: $names)';
  }

  @override
  bool operator ==(covariant BusData other) {
    if (identical(this, other)) return true;

    return other.busNumber == busNumber &&
        other.geoPoint == geoPoint &&
        other.school == school &&
        listEquals(other.names, names);
  }

  @override
  int get hashCode {
    return busNumber.hashCode ^
        geoPoint.hashCode ^
        school.hashCode ^
        names.hashCode;
  }

  void setId(String id){
    this.id = id;
  }
}
