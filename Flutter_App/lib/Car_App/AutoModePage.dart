import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import this library to use different fonts
import 'package:project/MQTT/MQTTClientWrapper.dart';
import 'HomePage.dart'; // Import the HomePage

final Color gold = Color(0xFFFFD835);
final Color darkNavyBlue = Color(0xFF000033);

class AutoModePage extends StatefulWidget {
  @override
  _AutoModePageState createState() => _AutoModePageState();
}

class _AutoModePageState extends State<AutoModePage> {
  late MQTTClientWrapper mqttClientWrapper;
  bool isConnecting = true;
  String statusMessage = "Waiting for status...";

  @override
  void initState() {
    super.initState();
    mqttClientWrapper = MQTTClientWrapper();
    _initializeMqttClient();
  }

  void _initializeMqttClient() async {
    await mqttClientWrapper.prepareMqttClient();
    _checkConnection();
  }

  void _checkConnection() async {
    if (mqttClientWrapper.isConnected) {
      setState(() {
        isConnecting = false;
      });
      _subscribeToStatusTopic();
    } else {
      await mqttClientWrapper.reconnect();
      if (mqttClientWrapper.isConnected) {
        setState(() {
          isConnecting = false;
        });
        _subscribeToStatusTopic();
      } else {
        setState(() {
          isConnecting = true;
        });
      }
    }
  }

  void _subscribeToStatusTopic() {
    try {
      mqttClientWrapper.subscribeToTopic('car/status');
      mqttClientWrapper.onMessageReceived = (String message) {
        setState(() {
          statusMessage = message; // Update status message on receiving new data
        });
        print('Received message: $message'); // Print message to console
      };
    } catch (e) {
      print('Subscription error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Auto Mode Page',
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: darkNavyBlue,
          ),
        ),
        backgroundColor: gold,
      ),
      body: Container(
        color: darkNavyBlue, // Set the background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isConnecting
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while connecting
                : Expanded(
                    child: Center(
                      child: Text(
                        statusMessage, // Display the received status message
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: gold, // Set text color to gold for better contrast
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false, // Remove all previous routes
                  );
                },
                icon: Icon(
                  Icons.home,
                  color: darkNavyBlue, // Icon color
                ),
                label: Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 18, // Smaller font size for the button
                    fontWeight: FontWeight.bold,
                    color: darkNavyBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
