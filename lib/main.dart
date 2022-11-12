import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yaars/data/firestore_helper.dart';
import 'package:yaars/home.dart';
import 'package:yaars/utilities/distance_measurement.dart';
import 'package:yaars/utilities/notification_manager.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'bus_group',
            channelKey: 'child',
            channelName: 'Child\'s bus',
            channelDescription:
                'Notification channel for child\'s bus',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'schedule_group', channelGroupName: 'Basic group')
      ],
      debug: true);

  await GetStorage.init();
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
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
