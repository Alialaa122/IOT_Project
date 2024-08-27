import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/Authentication/LogIn.dart';
import 'package:project/Authentication/SignUp.dart';
import 'package:project/Authentication/firebase_options.dart';
import 'package:project/Car_App/AutoModePage.dart';
import 'package:project/Car_App/CarModePage.dart';
import 'package:project/Car_App/HomePage.dart';
import 'package:project/Car_App/ManualModePage.dart';
import 'package:project/MQTT/MQTTClientWrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize MQTT client
  await MQTTClientWrapper().prepareMqttClient();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto/Manual Car App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Set initial route to login
      routes: {
        '/login': (context) => LogIn(), // Login page route
        '/signup': (context) => SignUp(), // SignUp page route
        '/home': (context) => HomePage(), // Home page route
        '/car_mode': (context) => CarModePage(), // Car mode page route
        '/auto_mode': (context) => AutoModePage(), // Auto mode page route
        '/manual_mode': (context) => ManualModePage(), // Manual mode page route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
