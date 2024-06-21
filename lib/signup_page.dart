import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your login page
import 'firebase_options.dart'; // Make sure you have imported necessary files
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _phoneNumberError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _signup(BuildContext context) async {
    // Validate form fields before proceeding
    if (_validateEmail(_emailController.text) == null &&
        _validatePhoneNumber(_phoneNumberController.text) == null &&
        _validatePassword(_passwordController.text) == null &&
        _validateConfirmPassword(_confirmPasswordController.text) == null) {
      try {
        // Create a new user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // User registration successful, handle the next step (e.g., navigate to another page)
        print('User registered: ${userCredential.user?.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase Auth exceptions
        String errorMessage = _handleFirebaseAuthError(e);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
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
        print('Error registering user: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while registering the user.'),
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

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'Error: ${e.message ?? 'An error occurred while registering the user.'}';
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

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Simple phone number validation example, adjust as needed
    if (value.length != 11) {
      return 'Phone number must be 11 digits';
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

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool _isObscure = true;
  bool _isObscureConfirm = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 450.0,
              height: 400.0,
              child: Center(
                child: Image.asset(
                  'assets/signup_image.png', // Replace with your image path
                  width: 450.0, // Adjust width to match the container
                  height: 400.0, // Adjust height to match the container
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
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      errorText: _phoneNumberError,
                    ),
                    onChanged: (_) {
                      setState(() {
                        _phoneNumberError =
                            _validatePhoneNumber(_phoneNumberController.text);
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
                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _isObscureConfirm, // Toggle visibility based on state
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText: _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signup(context), // Navigate to Login Page
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black), // Background color set to black
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 60)), // Increase button width
                      padding:
                          MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)), // Adjust padding
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    ), // Navigate to Login Page
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.white), // Background color set to black
                      minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 60)), // Increase button width
                      padding:
                      MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)), // Adjust padding
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
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

  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
