import 'package:flutter/material.dart';
import 'widgets/custom_scaffold.dart';
// If you need this for another button

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
          children: [
            // Welcome text section
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome Back!\n',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between text and button
            // Login button section - Directly below the text
            ElevatedButton(
              onPressed: () {
                // Add your login button logic here
                print("Sign in Button Pressed");
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 30.0,
                ),
                backgroundColor: Colors.white, // Neutral background
                foregroundColor: Colors.black, // Text color for contrast
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Subtle rounded corners
                  side: BorderSide(
                    color: Colors.grey.shade300, // Subtle border
                  ),
                ),
                elevation: 3, // Slight shadow for depth
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Microsoft logo
                  Image.asset(
                    'assets/Microsoft_Logo_512px.png',
                    height: 24.0,
                    width: 24.0,
                  ),
                  const SizedBox(width: 10), // Space between logo and text
                  // Button text
                  const Text(
                    'Sign in with Microsoft',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
