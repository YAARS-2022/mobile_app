import 'package:workmanager/workmanager.dart';
import 'dart:developer' as developer;

class BackgroundManager {
  @pragma("vm:entry-point")
  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) {
      developer.log('Native called background task: $taskName', name: "BackgroundManager");
      return Future.value(true);
    });
  }
}