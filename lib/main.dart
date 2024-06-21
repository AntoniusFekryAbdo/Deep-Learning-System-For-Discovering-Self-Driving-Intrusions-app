import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter_application_1/welcome_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyB2hq91sWvZHZCMLAUaKIPB_D8lcI1ixgc',
          appId: '1:389387411447:android:2ff2517683f9792a0f98f2',
          messagingSenderId: '389387411447',
          projectId: 'self-driving-intrusions',
          storageBucket: 'self-driving-intrusions.appspot.com',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Handle initialization error
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
