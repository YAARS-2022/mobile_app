import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:yaars/data/firestore_helper.dart';
import 'package:yaars/home.dart';
import 'package:yaars/utilities/distance_measurement.dart';
import 'package:yaars/utilities/notification_manager.dart';
import 'firebase_options.dart';
import 'package:yaars/utilities/background_manager.dart';
import 'dart:developer' as developer;

import 'models/bus_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    var notificationController = Get.put(NotificationController());

    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if(!locationServiceEnabled){
      notificationController.sendNotification('Location services disabled');
      return Future.error('Location services disabled.');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      notificationController.sendNotification('Location services denied');
      return Future.error('Location permissions are denied');
    }

    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var parentLat = userLocation.latitude;
    var parentLon = userLocation.longitude;

    double childLat;
    double childLon;

    developer.log('Parent locations: $parentLat, $parentLon', name: "Main");

    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    developer.log('Type of db : ${db.runtimeType}', name: "Main");
    await db.collection("Buses").get().then((event) {
      for (var doc in event.docs) {
        var busData = BusData.fromMap(doc.data());
        if (busData.names.contains('Ashmit')) {
          childLat = busData.geoPoint.latitude;
          childLon = busData.geoPoint.longitude;

          developer.log('Child position : $childLat, $childLon', name: "Main");

          var distance = Geolocator.distanceBetween(
              parentLat, parentLon, childLat, childLon);
          developer.log("The distance between parent and child is $distance m",
              name: "Main");

          notificationController.sendNotification(
              "Your child is approximately ${(distance / 1000).round()} km away.");
        }
        developer.log(busData.toString(), name: 'Main');
      }
    });
    return Future.value(true);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "task-identifier", "simpleTask",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'bus_group',
            channelKey: 'child',
            channelName: 'Child\'s bus',
            channelDescription: 'Notification channel for child\'s bus',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'schedule_group', channelGroupName: 'Basic group')
      ],
      debug: true);

  GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FSHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DistanceMeasurement.measureDistance();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
