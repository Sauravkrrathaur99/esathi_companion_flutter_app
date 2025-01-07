// // lib/background_tasks.dart

// import 'package:workmanager/workmanager.dart';
// import 'dart:developer' as developer;

// class BackgroundTasks {
//   static Future<bool> backgroundTaskHandler(String taskId, Map<String, dynamic>? inputData) async {
//     print("Background Task running for task: $taskId");

//     // Ensure inputData is not null
//     inputData ??= {};  // If inputData is null, use an empty map

//     // Your background task code goes here
//     await Future.delayed(const Duration(seconds: 5));
    
//     print("Background Task completed for task: $taskId");

//     return Future.value(true); // Return Future<bool>
//   }

//   // You can add other background tasks in this file as needed
// }



import 'package:workmanager/workmanager.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';

class BackgroundTasks {
  static Future<bool> backgroundTaskHandler(String taskId, Map<String, dynamic>? inputData) async {
    developer.log("Background Task running for task: $taskId");

    // Check internet connection
    await ConnectivityService.initConnectivity();

    // Simulate some background processing
    await Future.delayed(const Duration(seconds: 5));
    developer.log("Background Task completed for task: $taskId");

    return Future.value(true); // Return success
  }
}

// Connectivity Service to handle internet status
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static final NetworkInfo _networkInfo = NetworkInfo();
  static ConnectivityResult _connectionStatus = ConnectivityResult.none;
  static String wifiStatus = "Unknown";

  // Initialize connectivity
  static Future<void> initConnectivity() async {
    List<ConnectivityResult> result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // Update connection status
    await _updateConnectionStatus(result);
  }

  // Update Connection Status
  static Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.isNotEmpty) {
      _connectionStatus = result.first;

      if (_connectionStatus == ConnectivityResult.wifi) {
        await _getWifiInfo(); // Fetch Wi-Fi details
      } else if (_connectionStatus == ConnectivityResult.mobile) {
        wifiStatus = "Please Be In Your Corporate Network";
        developer.log("MOBILE DATA IS CONNECTED");
      } else {
        wifiStatus = "No Internet Connection, connect to your corporate network";
        developer.log("NO INTERNET CONNECTION");
      }
    }
  }

  // Get Wi-Fi Information
  static Future<void> _getWifiInfo() async {
    try {
      // final wifiName = await _networkInfo.getWifiName();
      final wifiName = (await _networkInfo.getWifiName())?.replaceAll('"', '').trim();
      print("wifi name fetched after trim: $wifiName");

      // Check for specific Wi-Fi names and update message accordingly
      String connectionMessage = "Please be in your corporate network area"; // Default message
      
      if (wifiName == "Airtel_! Jai Shree Krishna !_5G") {
        connectionMessage = "Connected via SuperTech";
      } else if (wifiName == "MishiTech5G") {
        connectionMessage = "Connected via MishiTech";
      } else if (wifiName == "Onelogica_5G") {
        connectionMessage = "Connected via Onelogica";
      } else if (wifiName == "Airtel_TSA_5G") {
        connectionMessage = "Connected via Tathagat_G2-1204";
      }else if (wifiName == "Airtel_! Jai Shree Krishna !") {
        connectionMessage = "Connected via SuperTech";
      }

      setState(() {
        wifiStatus = connectionMessage;
      });
    } catch (e) {
      setState(() {
        wifiStatus = "Error: $e";
      });
    }
  }
}

// WorkManager callback
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    developer.log("Background Task Dispatcher triggered for task: $task");
    return await BackgroundTasks.backgroundTaskHandler(task, inputData);
  });
}
