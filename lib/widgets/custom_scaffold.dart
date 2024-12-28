import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/login_bg.png',  // Ensure the background image exists at this path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // SafeArea to ensure content is not hidden behind the status bar
          SafeArea(
            child: child!, // This ensures that the child widget inside is not affected by system UI areas
          ),
        ],
      ),
    );
  }
}
