IoT Car Project
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
Project Overview
Manual Mode
In this mode, the user can control the car directly from the Flutter app. Features include:

Forward, backward, left, and right movement control
Speed adjustment via a slider
MQTT messages are sent from the app to the ESP32 to control the motors.
Automatic Mode
When automatic mode is enabled:

The car navigates autonomously, avoiding obstacles detected by the ultrasonic sensor.
The servo motor rotates left and right to scan for obstacles.
The car adjusts its path based on sensor readings.
The ultrasonic readings and servo motor angle data are sent to Firebase for real-time updates.
MQTT Topics
Manual Control: The Flutter app publishes movement and speed control messages to the ESP32.
Sensor Data: The ESP32 publishes ultrasonic sensor readings and obstacle detection data, which are displayed in the app.
Firebase Integration
Authentication: The app uses Firebase Authentication to manage user sign-up and login.
Realtime Database: Ultrasonic sensor readings and servo motor angles are stored in Firebase and updated in real-time.
How to Run the Project
Hardware Setup:

Connect the ESP32 to your motor driver, DC motors, ultrasonic sensor, and servo motor.
Power the ESP32 using a Li-ion 3.7V battery.
ESP32 Firmware:

Flash the ESP32 with the firmware that handles MQTT communication, obstacle detection, and car control.
Flutter App:

Clone the Flutter app repository.
Configure Firebase for authentication and real-time database.
Connect the app to HiveMQ for MQTT communication.
MQTT Setup:

Set up HiveMQ broker for handling MQTT topics.
