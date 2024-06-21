import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup_page.dart';
import 'home_page.dart'; // Import your home page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true; // Manage password visibility
  String? _emailError;
  String? _passwordError;

  void _login(BuildContext context) async {
    // Validate form fields before proceeding
    if (_validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null) {
      try {
        // Sign in with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Login successful, handle the next step (e.g., navigate to another page)
        print('User logged in: ${userCredential.user?.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase Auth exceptions
        print('Error logging in: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(e.message ?? 'An error occurred while logging in.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } catch (e) {
        // Handle any other exceptions
        print('Error logging in: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while logging in.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      // Show error dialog or message for invalid inputs
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fix the errors in the form.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple email validation example, adjust as needed
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for lowercase letters
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Home Page on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  void _signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        // Sign in with credential
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to Home Page on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        print('Facebook login failed');
      }
    } catch (e) {
      print('Error signing in with Facebook: $e');
    }
  }

  void _signInWithTwitter(BuildContext context) async {
    try {
      // TODO: implement
      final TwitterLogin twitterLogin = TwitterLogin(
        apiKey: 'oYSZHD1OVEC5O17XCEUcOI7CK',
        apiSecretKey: 'N8mDUo3QUBMxW5vhcG3hgwh0DWuZUyP4ySlfLSVpfFhlTA4g6i',
        redirectURI: 'https://self-driving-intrusions.firebaseapp.com/__/auth/handler',
      );

      final authResult = await twitterLogin.login();

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final OAuthCredential credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!,
          );

          // Sign in with credential
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);

          // Navigate to Home Page on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          break;
        case TwitterLoginStatus.cancelledByUser:
          print('Twitter login cancelled by user');
          break;
        case TwitterLoginStatus.error:
          print('Error signing in with Twitter: ${authResult.errorMessage}');
          break;
        case null:
        // TODO: Handle this case.
      }
    } catch (e) {
      print('Error signing in with Twitter: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 450.0,
              height: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(110.0),
                  bottomRight: Radius.circular(110.0),
                ),
                child: Image.asset(
                  'assets/login_image.png', // Replace with your image path
                  width: 450.0, // Adjust width to match the container
                  height: 350.0, // Adjust height to match the container
                  fit: BoxFit.cover, // This will ensure the image covers the container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _emailError,
                    ),
                    onChanged: (_) {
                      setState(() {
                        _emailError = _validateEmail(_emailController.text);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscure, // Toggle visibility based on state
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _passwordError =
                            _validatePassword(_passwordController.text);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Handle "Forget Password?" action
                      // Implement your logic here
                      // Example: show a dialog or navigate to a password reset page
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: Colors.black, // Change color as needed
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _login(context), // Navigate to Home Page
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.black), // Background color set to black
                      minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 60)), // Increase button width
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15)), // Adjust padding
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Login'),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: Text('or'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    ), // Navigate to Home Page
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white), // Background color set to black
                      minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 60)), // Increase button width
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15)), // Adjust padding
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Sign up'),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle Google login
                        },
                        child: Image.asset(
                          'assets/google_logo.png', // Replace with your Google logo path
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // Handle Facebook login
                          _signInWithFacebook(context);
                        },
                        child: Image.asset(
                          'assets/facebook_logo.png', // Replace with your Facebook logo path
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // Handle Twitter login
                          _signInWithTwitter(context);
                        },
                        child: Image.asset(
                          'assets/twitter_logo.png', // Replace with your Twitter logo path
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ],
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
