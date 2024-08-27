import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/MQTT/MQTTClientWrapper.dart';
import 'HomePage.dart'; // Import the HomePage

final Color gold = Color(0xFFFFD835);
final Color darkNavyBlue = Color(0xFF000033);

class ManualModePage extends StatefulWidget {
  @override
  _ManualModePageState createState() => _ManualModePageState();
}

class _ManualModePageState extends State<ManualModePage> {
  double _currentSpeedValue = 1; // Initial speed value (Medium)

  // MQTT client wrapper
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  final String controlTopic = 'car/control'; // Topic to control the car when in manual mode
  final String speedTopic = 'car/speed'; // Topic to control the speed of the car

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
  }

  // Helper function to map slider value to speed label
  String _getSpeedLabel(double value) {
    if (value == 0) {
      return 'Low';
    } else if (value == 1) {
      return 'Medium';
    } else {
      return 'High';
    }
  }

  void _publishControlMessage(String message) {
    mqttClientWrapper.publishMessage(controlTopic, message);
  }

  void _publishSpeedMessage(String speed) {
    mqttClientWrapper.publishMessage(speedTopic, speed);
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;
    final double buttonSize = size.width * 0.2; // 20% of screen width for button size

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manual Mode Page', // Title of the page
          style: GoogleFonts.pacifico(
            fontSize: 24,
            color: darkNavyBlue,
          ),
        ),
        backgroundColor: gold,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: darkNavyBlue,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Up Button
              GestureDetector(
                onTapDown: (_) {
                  _publishControlMessage('forward'); // Publish 'forward' message
                },
                onTapUp: (_) {
                  _publishControlMessage('stop'); // Publish 'stop' message
                },
                onTapCancel: () {
                  _publishControlMessage('stop'); // Publish 'stop' message
                },
                child: ElevatedButton(
                  onPressed: () {}, // Empty onPressed to use GestureDetector
                  child: Icon(Icons.keyboard_double_arrow_up_rounded, size: buttonSize * 0.8, color: darkNavyBlue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    padding: EdgeInsets.all(buttonSize * 0.3),
                    shape: CircleBorder(),
                    minimumSize: Size(buttonSize, buttonSize),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Middle Row with Left, Honk, and Right Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTapDown: (_) {
                      _publishControlMessage('left'); // Publish 'left' message
                    },
                    onTapUp: (_) {
                      _publishControlMessage('stop'); // Publish 'stop' message
                    },
                    onTapCancel: () {
                      _publishControlMessage('stop'); // Publish 'stop' message
                    },
                    child: ElevatedButton(
                      onPressed: () {}, // Empty onPressed to use GestureDetector
                      child: Icon(Icons.keyboard_double_arrow_left_rounded, size: buttonSize * 0.8, color: darkNavyBlue),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        padding: EdgeInsets.all(buttonSize * 0.3),
                        shape: CircleBorder(),
                        minimumSize: Size(buttonSize, buttonSize),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _publishControlMessage('honk'); // Publish 'honk' message (no continuous action needed)
                    },
                    child: Icon(Icons.music_note_rounded, size: buttonSize * 0.8, color: darkNavyBlue),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      padding: EdgeInsets.all(buttonSize * 0.3),
                      shape: CircleBorder(),
                      minimumSize: Size(buttonSize, buttonSize),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTapDown: (_) {
                      _publishControlMessage('right'); // Publish 'right' message
                    },
                    onTapUp: (_) {
                      _publishControlMessage('stop'); // Publish 'stop' message
                    },
                    onTapCancel: () {
                      _publishControlMessage('stop'); // Publish 'stop' message
                    },
                    child: ElevatedButton(
                      onPressed: () {}, // Empty onPressed to use GestureDetector
                      child: Icon(Icons.keyboard_double_arrow_right_rounded, size: buttonSize * 0.8, color: darkNavyBlue),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        padding: EdgeInsets.all(buttonSize * 0.3),
                        shape: CircleBorder(),
                        minimumSize: Size(buttonSize, buttonSize),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Down Button
              GestureDetector(
                onTapDown: (_) {
                  _publishControlMessage('backward'); // Publish 'backward' message
                },
                onTapUp: (_) {
                  _publishControlMessage('stop'); // Publish 'stop' message
                },
                onTapCancel: () {
                  _publishControlMessage('stop'); // Publish 'stop' message
                },
                child: ElevatedButton(
                  onPressed: () {}, // Empty onPressed to use GestureDetector
                  child: Icon(Icons.keyboard_double_arrow_down_rounded, size: buttonSize * 0.8, color: darkNavyBlue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    padding: EdgeInsets.all(buttonSize * 0.3),
                    shape: CircleBorder(),
                    minimumSize: Size(buttonSize, buttonSize),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Slider for Speed Control
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Speed: ${_getSpeedLabel(_currentSpeedValue)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: _currentSpeedValue,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    onChanged: (value) {
                      setState(() {
                        _currentSpeedValue = value;
                      });
                      _publishSpeedMessage(_getSpeedLabel(value)); // Publish speed label directly
                    },
                    activeColor: gold,
                    inactiveColor: Colors.grey,
                    label: _getSpeedLabel(_currentSpeedValue),
                    thumbColor: gold,
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Home Button to navigate back to the HomePage
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(Icons.home, color: darkNavyBlue),
                label: Text(
                  'Home',
                  style: TextStyle(color: darkNavyBlue, fontFamily: "Times New Roman", fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
