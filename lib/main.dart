import 'package:esathi_companion_app/login.dart';
import 'package:esathi_companion_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For Timer class
import 'dart:developer' as developer;
import 'package:intl/intl.dart'; // For date formatting
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart'; // Only using location package


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static const platform = MethodChannel('com.example.esathi_companion_app/wifi'); // Same channel name as in MainActivity.kt

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location = Location(); // Location object for handling permissions and location fetching
  String locationStatus = "Unknown"; // To hold location status message
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none; // Declare connection status
  String wifiStatus = "Unknown"; // Add this line to define wifiStatus
  final NetworkInfo _networkInfo = NetworkInfo(); // Moved inside the class

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  _getWifiInfo();  // Replace _getWifiStatus with _getWifiInfo to fetch the Wi-Fi info
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.isNotEmpty) {
      setState(() {
        _connectionStatus = result.first;
      });

      if (_connectionStatus == ConnectivityResult.wifi) {
        _checkLocationAndFetchWifiInfo();
      } else if (_connectionStatus == ConnectivityResult.mobile) {
        setState(() {
          wifiStatus = "Please Be In Your Corporate Network";
        });
      } else {
        setState(() {
          wifiStatus = "No Internet Connection, connect to your corporate network";
        });
      }
    }
  }

Future<void> _checkLocationAndFetchWifiInfo() async {
    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Request to enable location service if it's not enabled
      bool serviceRequested = await location.requestService();
      if (!serviceRequested) {
        setState(() {
          wifiStatus = "Please Enable Loaction to Check-In";
        });
        return;
      }
    }

     // Check if location permission is granted using package:location
    PermissionStatus permissionStatus = await location.requestPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Fetch the Wi-Fi info after location permission is granted
      _getWifiInfo();
    } else {
      setState(() {
        wifiStatus = "Permission denied for location.";
      });
    }
  }

Future<void> _getWifiInfo() async {
  try {
    // Fetch the Wi-Fi name
    final wifiName = await _networkInfo.getWifiName();
    print("wifi name fetched before trim: $wifiName");

    if (wifiName == null) {
      // If wifiName is null, retry by calling _checkLocationAndFetchWifiInfo()
      print("Wi-Fi name is null, trying again...");
      _checkLocationAndFetchWifiInfo();
      return; // Exit this method and let _checkLocationAndFetchWifiInfo handle it
    }

    // Trim and clean up the Wi-Fi name
    final wifiName_trimmed = wifiName.replaceAll('"', '').trim();
    print("wifi name fetched after trim: $wifiName_trimmed");

    // Check for specific Wi-Fi names and update message accordingly
    String connectionMessage = "Please be in your corporate network area"; // Default message

    if (wifiName_trimmed == "Airtel_! Jai Shree Krishna !_5G") {
      connectionMessage = "Connected via SuperTech";
    } else if (wifiName_trimmed == "MishiTech5G") {
      connectionMessage = "Connected via MishiTech";
    } else if (wifiName_trimmed == "Onelogica_5G") {
      connectionMessage = "Connected via Onelogica";
    } else if (wifiName_trimmed == "Airtel_TSA_5G") {
      connectionMessage = "Connected via Tathagat_G2-1204";
    } else if (wifiName_trimmed == "Airtel_! Jai Shree Krishna !") {
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


  @override
  Widget build(BuildContext context) {
    String LoggedUsername = 'Saurav Kumar Rathaur'; // Example status (can be dynamic)

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(
      //   LoggedUsername: LoggedUsername,
      //   wifiStatus: wifiStatus,
      //   connectionStatus: _connectionStatus, // Pass the _connectionStatus here
      // ), // Pass the wifiStatus to HomePage

      home: LoginScreen(
        // Pass the _connectionStatus here
      ), // Pass the wifiStatus to HomePage
    );
  }
}
