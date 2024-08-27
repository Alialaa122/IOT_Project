import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/MQTT/MQTTClientWrapper.dart';


final Color gold = Color(0xFFFFD835);
final Color darkNavyBlue = Color(0xFF000033);

class CarModePage extends StatefulWidget {
  @override
  _CarModePageState createState() => _CarModePageState();
}

class _CarModePageState extends State<CarModePage> {
  late MQTTClientWrapper mqttClientWrapper;
  bool isConnecting = true;

  @override
  void initState() {
    super.initState();
    mqttClientWrapper = MQTTClientWrapper();
    _checkConnection();
  }

  void _checkConnection() async {
    // Check connection status
    if (mqttClientWrapper.isConnected) {
      setState(() {
        isConnecting = false;
      });
    } else {
      // Try reconnecting if not connected
      await mqttClientWrapper.reconnect();
      setState(() {
        isConnecting = !mqttClientWrapper.isConnected;
      });
    }
  }

  void _publishMessage(String message) {
    mqttClientWrapper.publishMessage('car/mode', message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Mode Page',
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: darkNavyBlue,
          ),
        ),
        backgroundColor: gold,
      ),
      body: isConnecting
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while connecting
          : Container(
              decoration: BoxDecoration(
                color: darkNavyBlue,
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'What mode would you like the car to run on?',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: gold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: mqttClientWrapper.isConnected
                              ? () {
                                  _publishMessage('auto'); // Publish "auto" when Auto button is pressed
                                  Navigator.pushNamed(context, '/auto_mode');
                                }
                              : null, // Disable button if not connected
                          icon: Icon(
                            FontAwesomeIcons.carSide,
                            color: darkNavyBlue,
                            size: 24,
                          ),
                          label: Text(
                            'Auto',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                                color: darkNavyBlue,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: mqttClientWrapper.isConnected
                              ? () {
                                  _publishMessage('manual'); // Publish "manual" when Manual button is pressed
                                  Navigator.pushNamed(context, '/manual_mode');
                                }
                              : null, // Disable button if not connected
                          icon: Icon(
                            FontAwesomeIcons.tools,
                            color: darkNavyBlue,
                            size: 24,
                          ),
                          label: Text(
                            'Manual',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                  color: darkNavyBlue,
                            ),
                          ),
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
