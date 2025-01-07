import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'history_page.dart';
import 'user_page.dart';
import '../widgets/bottom_navbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  final String LoggedUsername; // Accept status as a parameter
  final String wifiStatus; // Accept wifiStatus as a parameter
  final ConnectivityResult connectionStatus; // Add this field

  const HomePage({
    Key? key,
    required this.LoggedUsername,
    required this.wifiStatus,
    required this.connectionStatus, // Initialize this in the constructor
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default to Home page

  @override
  Widget build(BuildContext context) {
    // Pass the status directly from widget.LoggedUsername
    final List<Widget> _screens = [
      const HistoryPage(),
      HomePageContent(
        LoggedUsername: widget.LoggedUsername,
        wifiStatus: widget.wifiStatus,
        connectionStatus: widget.connectionStatus, // Pass connectionStatus to HomePageContent
      ), // Pass LoggedUsername, wifiStatus, and connectionStatus to HomePageContent
      const UserPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final String LoggedUsername; // Accept the status as a parameter
  final String wifiStatus; // Accept wifiStatus as a parameter
  final ConnectivityResult connectionStatus; // Add this field to access connection status

  const HomePageContent({
    super.key, 
    required this.LoggedUsername, 
    required this.wifiStatus,
    required this.connectionStatus, // Initialize this in the constructor
  });

  // Function to select icon based on connection status
  Icon _getConnectionIcon() {
    if (connectionStatus == ConnectivityResult.wifi) {
      return const Icon(Icons.wifi, color: Colors.green);
    } else if (connectionStatus == ConnectivityResult.mobile) {
      return const Icon(Icons.signal_cellular_alt, color: Colors.orange);
    } else {
      return const Icon(Icons.signal_wifi_off, color: Colors.red);
    }
  }

  // Get current date and format it
  String get _formattedDate {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  // Get current time and format it
  String get _formattedTime {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(now);
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
                  Text(
                    'Welcome, $LoggedUsername',
                    style: const TextStyle(
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
              offset: const Offset(0, -10), // Move up by 10 units to make it float above
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
            
            // Cylindrical Shape for Wi-Fi Status (New Shape)
            Transform.translate(
              offset: const Offset(0, -10), // Move up by 10 units to make it float above
              child: Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(top: 15), // Adjust top margin to place it below
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
                    _getConnectionIcon(), // Call the function from utils.dart
                    const SizedBox(width: 10),
                    Text(
                      wifiStatus,
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Additional sections can be added here as needed
          ],
        ),
      ),
    );
  }
}
