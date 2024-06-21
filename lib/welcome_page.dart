import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _navigateToSignupPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.png', // Ensure you have this image in your assets folder
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60.0),
                child: const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 48, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Changed color to black
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToLoginPage(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Sphere shape
                    ), // Text color black
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Increased padding
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Increased font size and bold
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _navigateToSignupPage(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Sphere shape
                    ), // Text color black
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Increased padding
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Increased font size and bold
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
