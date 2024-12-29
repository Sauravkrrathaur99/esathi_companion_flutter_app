import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Define the background task
  service.onDataReceived.listen((event) {
    if (event!['action'] == 'stopService') {
      service.stopSelf();
    }
  });

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'background_service',
      initialNotificationTitle: 'Network Monitor',
      initialNotificationContent: 'Monitoring network connectivity...',
    ),
  );

  service.startService();
}

void onStart(ServiceInstance service) async {
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      // Update notification
      service.setForegroundNotificationInfo(
        title: "Network Status",
        content: "Monitoring network...",
      );
    }

    // Perform network status check
    final connectivityResult = await Connectivity().checkConnectivity();
    String networkStatus = 'No Connection';

    if (connectivityResult == ConnectivityResult.wifi) {
      networkStatus = "Wi-Fi Connected";
    } else if (connectivityResult == ConnectivityResult.mobile) {
      networkStatus = "Mobile Network Connected";
    }

    service.sendData({'networkStatus': networkStatus});
  });
}

// iOS background task handler
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
