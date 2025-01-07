import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> checkPermissions() async {
    // Check if the required permissions are granted
    final locationPermission = await Permission.locationAlways.isGranted;
    final batteryPermission = await Permission.ignoreBatteryOptimizations.isGranted;
    final notificationPermission = await Permission.notification.isGranted;

    // If any permission is not granted, return false
    if (!locationPermission || !batteryPermission || !notificationPermission) {
      return false;
    }
    return true;
  }

  static Future<void> requestPermissions() async {
    // Request required permissions
    await Permission.locationAlways.request();
    await Permission.ignoreBatteryOptimizations.request();
    await Permission.notification.request();

    // Optionally, you can check if the permissions were granted after requesting them
    final locationPermission = await Permission.locationAlways.isGranted;
    final batteryPermission = await Permission.ignoreBatteryOptimizations.isGranted;
    final notificationPermission = await Permission.notification.isGranted;

    if (!locationPermission || !batteryPermission || !notificationPermission) {
      // Handle the case where permission is still not granted, e.g., show a dialog
      print("Permissions are not granted. Please enable them manually.");
    }
  }
}
