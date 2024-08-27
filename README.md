This project demonstrates an IoT-enabled car using the ESP32 microcontroller, capable of operating in two modes: Manual Mode and Automatic Mode. The car is controlled via a Flutter app, which communicates with the ESP32 using MQTT (via HiveMQ) and Firebase.

Features

Manual Mode: Control the car's movement (forward, backward, left, right) and adjust speed through the Flutter app.

Auto Mode: The car automatically detects obstacles using an ultrasonic sensor. The servo motor helps the car look left and right to decide the best path.

MQTT Communication: The ESP32 publishes and subscribes to topics via HiveMQ, enabling real-time control and data exchange with the Flutter app.

Firebase Integration:
Authentication: Users can sign up and log in to the Flutter app via Firebase Authentication.
Realtime Database: The ultrasonic sensor readings and other car data are sent from the ESP32 to Firebase, allowing live monitoring.


Technology Stack

Microcontroller: ESP32

Mobile App: Flutter

Communication Protocol: MQTT (HiveMQ broker)

Authentication: Firebase Authentication

Database: Firebase Realtime Database

Ultrasonic Sensor: Used for obstacle detection in auto mode

Servo Motor: Used to change the direction of the ultrasonic sensor for better obstacle detection

Power Supply: Li-ion 3.7V battery
