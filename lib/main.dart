import 'package:flutter/material.dart';
import 'dart:async'; // For Timer class
import 'package:intl/intl.dart'; // For date formatting
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const platform = MethodChannel('com.example.esathi_companion_app/wifi'); // Same channel name as in MainActivity.kt

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default to Home page

  final List<Widget> _screens = [
    const HistoryPage(), // History screen
    const HomePageContent(), // Home screen
    const UserPage(), // User screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_currentIndex], // Display the selected screen within SafeArea
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _start = 3600; // 1 hour countdown (in seconds)
  String wifiStatus = "Unknown"; // Add this line to define wifiStatus
  final NetworkInfo _networkInfo = NetworkInfo(); // Moved inside the class

  @override
  void initState() {
    super.initState();
    _startTimer();
    _getWifiStatus();
     _getWifiInfo();  // Call this to get Wi-Fi info on startup
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    int hours = _start ~/ 3600;
    int minutes = (_start % 3600) ~/ 60;
    int seconds = _start % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _formattedDate {
    final now = DateTime.now();
    return DateFormat('EEEE, MMM dd, yyyy').format(now);
  }

// Future<void> _getWifiStatus() async {
//   // Request permission before accessing Wi-Fi info
//   PermissionStatus permissionStatus = await Permission.locationWhenInUse.request();
//   print('Location Permission Status: $permissionStatus');
  
  
//   if (permissionStatus.isGranted) {
//     try {
//       final String status = await MyApp.platform.invokeMethod('getWiFiStatus');
//       print('Status wifi: $status');
//       setState(() {
//         wifiStatus = status;
//       });
//     } on PlatformException catch (e) {
//       setState(() {
//         wifiStatus = "Error: ${e.message}";
//       });
//     }
//   } else {
//     setState(() {
//       wifiStatus = "Permission denied";
//     });
//   }
// }




Future<void> _getWifiStatus() async {
  // Request permission before accessing Wi-Fi info
  PermissionStatus permissionStatus = await Permission.locationWhenInUse.request();
  print('Location Permission Status: $permissionStatus');

  if (permissionStatus.isGranted) {
    try {
      final String status = await MyApp.platform.invokeMethod('getWiFiStatus');
      print('Status wifi: $status');
      setState(() {
        wifiStatus = status;
      });
    } on PlatformException catch (e) {
      setState(() {
        wifiStatus = "Error: ${e.message}";
      });
    }
    _getWifiInfo();  // Get Wi-Fi info after permission is granted
  } else {
    setState(() {
      wifiStatus = "Permission denied";
    });
  }
}

Future<void> _getWifiInfo() async {
  try {
    final wifiName = await _networkInfo.getWifiName();
    final wifiBSSID = await _networkInfo.getWifiBSSID();
    final wifiIP = await _networkInfo.getWifiIP();
    setState(() {
      wifiStatus = '"Wi-Fi Name": $wifiName, BSSID: $wifiBSSID, IP: $wifiIP';
    });
  } catch (e) {
    setState(() {
      wifiStatus = "Error: $e";
    });
  }
}



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Upper Section (Blue background)
            Container(
              color: const Color(0xFF0F1C3E),
              height: screenHeight * 0.3, // 30% of screen height
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Welcome, Saurav Kumar Rathaur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/image_checkincheckout_home.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Cylindrical Shape above the junction using Transform
            Transform.translate(
              offset: const Offset(0, -10), // Move up by 10 units
              child: Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(top: 1), // Keep original margin
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _formattedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.timer, color: Colors.blue),
                    Text(
                      'Work Time: $_formattedTime',
                      style: const TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            // Connectivity Status
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.network_check, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      wifiStatus,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Lower Section (Grid with Info Boxes)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: screenWidth > 600 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(
                  4,
                      (index) => _buildInfoBox(
                    'assets/set_location_attendance.png',
                    'Action ${index + 1}',
                    screenWidth,
                    screenHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String imagePath, String text, double width, double height) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: width * 0.15, // Adjust size of the image
            height: height * 0.15,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('History Page'),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('User Page'),
      ),
    );
  }
}
