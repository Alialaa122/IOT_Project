// Include necessary libraries
#include <ESP32Servo.h>                // Servo library for ESP32
#include <WiFi.h>                      // Wi-Fi library for ESP32
#include <WiFiClientSecure.h>           // Secure Wi-Fi client for HTTPS
#include <PubSubClient.h>               // MQTT library
#include "FS.h"                         // File System library for ESP32
#include "ca_cert.h"                    // CA certificate for secure connection
#include <Firebase_ESP_Client.h>        // Firebase ESP Client library
#include "addons/TokenHelper.h"         // Firebase token helper
#include "addons/RTDBHelper.h"          // Firebase RTDB helper

// Firebase credentials
#define API_KEY "AIzaSyAFfLLBWhHvfIkrOuMvLBjM1hJ2_gvnuek"
#define DATABASE_URL "https://iot-project-8339d-default-rtdb.firebaseio.com/"

// Wi-Fi credentials
#define WIFI_SSID "WE_ED0340"
#define WIFI_PASSWORD "alwaalaa12257*"

// MQTT server details (HiveMQ Cloud)
const char *mqtt_server = "9945f02056324a2bbf30ad838a527eed.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char *mqtt_username = "Moaz14060";
const char *mqtt_password = "Qwer2468";

// Define pins for motors, ultrasonic sensor, and servo
const int motorLeftForward = 19;
const int motorLeftBackward = 21;
const int motorRightForward = 22;
const int motorRightBackward = 23;
const int enaPin = 14;
const int enbPin = 27;
const int trigPin = 4;
const int echoPin = 5;
const int servoPin = 18;

// Define thresholds and speed settings
const int distanceThreshold = 30;  // Distance threshold for obstacle detection (in cm)
const int SPEED_LOW = 100;         // Low speed for motors
const int SPEED_MED = 150;         // Medium speed for motors (default)
const int SPEED_HIGH = 200;        // High speed for motors
int motorSpeed = SPEED_MED;        // Initialize with medium speed

int mode = 0; // Mode of the car (0 = manual, 1 = auto)

// Firebase objects for authentication and configuration
FirebaseData fbdo;        // Firebase Data object
FirebaseAuth auth;        // Firebase Auth object
FirebaseConfig config;    // Firebase Config object

// MQTT objects
WiFiClientSecure espClient;      // Secure Wi-Fi client for MQTT
PubSubClient client(espClient);  // MQTT client

// Create a Servo object for ultrasonic sensor rotation
Servo ultrasonicServo;

// Timers for sending data to Firebase
unsigned long sendDataPrevMillis = 0; // Previous time for sending data
bool firebaseReady = false;           // Flag to check if Firebase is ready

// Function prototypes
void setup_wifi();        // Connects to Wi-Fi
void callback(char *topic, byte *payload, unsigned int length); // Handles MQTT messages
void reconnect();         // Reconnects to MQTT server
long measureDistance();   // Measures distance using ultrasonic sensor
void moveForward();       // Moves the car forward
void moveBackward();      // Moves the car backward
void turnRight();         // Turns the car to the right
void turnLeft();          // Turns the car to the left
void stopCar();           // Stops the car
void autoMode();          // Autonomous driving mode

// Setup function, runs once at the start
void setup() {
  Serial.begin(115200);   // Start the Serial Monitor

  // Setup secure WiFi client and connect to Wi-Fi
  espClient.setCACert(ca_cert);   // Set the CA certificate for secure connection
  setup_wifi();                   // Call the Wi-Fi connection function

  // Initialize Firebase with API key and database URL
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  auth.user.email = "aa3020942@gmail.com";    // Firebase email
  auth.user.password = "alialaa123";          // Firebase password
  Firebase.begin(&config, &auth);             // Initialize Firebase
  Firebase.reconnectWiFi(true);               // Reconnect Wi-Fi if disconnected

  // Check if signed in successfully to Firebase
  if (auth.token.uid.length() > 0) {
    Serial.println("Firebase signed in successfully");
    firebaseReady = true;    // Firebase is ready
  } else {
    Serial.println("Failed to sign in to Firebase");
  }

  // Setup MQTT client
  client.setServer(mqtt_server, mqtt_port);   // Set MQTT server and port
  client.setCallback(callback);               // Set callback function to handle MQTT messages

  // Setup pins for motors and ultrasonic sensor
  pinMode(motorLeftForward, OUTPUT);
  pinMode(motorLeftBackward, OUTPUT);
  pinMode(motorRightForward, OUTPUT);
  pinMode(motorRightBackward, OUTPUT);
  pinMode(enaPin, OUTPUT);
  pinMode(enbPin, OUTPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Attach servo to pin and center it
  ultrasonicServo.attach(servoPin);
  ultrasonicServo.write(90);  // Center the servo at 90 degrees
}

// Main loop function, runs continuously
void loop() {
  if (!client.connected()) {  // Check if connected to MQTT
    reconnect();              // Reconnect if not connected
  }
  client.loop();              // Maintain MQTT connection

  if (Firebase.ready() && firebaseReady) {   // Check if Firebase is ready
    // Send data every 5 seconds
    if (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0) {
      sendDataPrevMillis = millis();  // Update last send time

      long distance = measureDistance(); // Measure distance using ultrasonic sensor

      // Send distance data to Firebase
      if (Firebase.RTDB.setFloat(&fbdo, "/AutoMode/distance", distance)) {
        Serial.println("Distance data sent successfully.");
      } else {
        Serial.println(fbdo.errorReason());
      }
    }
  }

  if (mode == 1) {  // If auto mode is enabled
    autoMode();     // Call the autonomous driving function
  }

  delay(100);       // Delay for stability
}

// Connect to Wi-Fi network
void setup_wifi() {
  delay(10);
  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);  // Begin Wi-Fi connection

  // Wait until connected to Wi-Fi
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");  // Wi-Fi connected successfully
  Serial.println("WiFi connected");
}

// Callback function to handle incoming MQTT messages
void callback(char *topic, byte *payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];  // Construct message from payload
  }

  // Handle different topics and commands
  if (String(topic) == "car/mode") {
    if (message == "manual" || message == "0") {
      mode = 0; // Switch to manual mode
      stopCar();  // Stop the car
      Serial.println("Car is now in manual mode.");
    } else if (message == "auto" || message == "1") {
      mode = 1; // Switch to auto mode
      Serial.println("Car is now in auto mode.");
    }
  }

  // If in manual mode, control the car based on the received commands
  if ((mode == 0 || message == "manual") && String(topic) == "car/control") {
    if (message == "forward") {
      moveForward();
    } else if (message == "backward") {
      moveBackward();
    } else if (message == "left") {
      turnLeft();
    } else if (message == "right") {
      turnRight();
    } else if (message == "stop") {
      stopCar();
    }
  }

  // If in manual mode, control car speed based on received message
  if ((mode == 0 || message == "manual") && String(topic) == "car/speed") {
    if (message == "low") {
      motorSpeed = SPEED_LOW;
    } else if (message == "med" || message == "medium") {
      motorSpeed = SPEED_MED;
    } else if (message == "high") {
      motorSpeed = SPEED_HIGH;
    }
  }
}

// Reconnect to MQTT server if disconnected
void reconnect() {
  while (!client.connected()) {   // Loop until connected
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP32Client", mqtt_username, mqtt_password)) { // Connect to MQTT
      Serial.println("connected");
      client.subscribe("car/mode");      // Subscribe to mode topic
      client.subscribe("car/control");   // Subscribe to control topic
      client.subscribe("car/speed");     // Subscribe to speed topic
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());   // Print connection state
      Serial.println(" try again in 5 seconds");
      delay(5000);    // Wait 5 seconds before retrying
    }
  }
}

// Measure distance using the ultrasonic sensor
long measureDistance() {
  digitalWrite(trigPin, LOW);   // Clear the trigger pin
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);  // Send a pulse on the trigger pin
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Calculate distance based on the duration of the echo pin
  long duration = pulseIn(echoPin, HIGH);
  long distance = duration * 0.034 / 2;
  return distance;  // Return the distance in cm
}

// Moves the car forward
void moveForward() {
  digitalWrite(motorLeftForward, HIGH);
  digitalWrite(motorLeftBackward, LOW);
  digitalWrite(motorRightForward, HIGH);
  digitalWrite(motorRightBackward, LOW);
  analogWrite(enaPin, motorSpeed);  // Set motor speed for left motors
  analogWrite(enbPin, motorSpeed);  // Set motor speed for right motors
}

// Moves the car backward
void moveBackward() {
  digitalWrite(motorLeftForward, LOW);
  digitalWrite(motorLeftBackward, HIGH);
  digitalWrite(motorRightForward, LOW);
  digitalWrite(motorRightBackward, HIGH);
  analogWrite(enaPin, motorSpeed);  // Set motor speed for left motors
  analogWrite(enbPin, motorSpeed);  // Set motor speed for right motors
}

// Turns the car to the right
void turnRight() {
  digitalWrite(motorLeftForward, HIGH);
  digitalWrite(motorLeftBackward, LOW);
  digitalWrite(motorRightForward, LOW);
  digitalWrite(motorRightBackward, HIGH);
  analogWrite(enaPin, motorSpeed);  // Set motor speed for left motors
  analogWrite(enbPin, motorSpeed);  // Set motor speed for right motors
}

// Turns the car to the left
void turnLeft() {
  digitalWrite(motorLeftForward, LOW);
  digitalWrite(motorLeftBackward, HIGH);
  digitalWrite(motorRightForward, HIGH);
  digitalWrite(motorRightBackward, LOW);
  analogWrite(enaPin, motorSpeed);  // Set motor speed for left motors
  analogWrite(enbPin, motorSpeed);  // Set motor speed for right motors
}

// Stops the car
void stopCar() {
  digitalWrite(motorLeftForward, LOW);
  digitalWrite(motorLeftBackward, LOW);
  digitalWrite(motorRightForward, LOW);
  digitalWrite(motorRightBackward, LOW);
  analogWrite(enaPin, 0);   // Set motor speed to 0 for left motors
  analogWrite(enbPin, 0);   // Set motor speed to 0 for right motors
}

// Autonomous driving mode
void autoMode() {
  // Measure the distance to an obstacle in front of the car
  long distance = measureDistance();
  // Get the current angle of the ultrasonic servo motor
  int servoAngle = ultrasonicServo.read();

  // Check if the car is too close to an obstacle
  if (distance < distanceThreshold) {
    stopCar();          // Stop the car to avoid collision
    delay(500);         // Wait for 500 milliseconds

    // Publish a message to the MQTT broker indicating an obstacle was detected
    client.publish("car/status", "Obstacle detected");

    // Move the car backward to create space from the obstacle
    moveBackward();
    delay(1000);        // Move backward for 1 second
    stopCar();          // Stop the car after moving back

    // Declare variables for storing distances to the left and right
    long leftDistance, rightDistance;

    // Rotate the servo motor to the left (30 degrees) to measure distance on the left side
    ultrasonicServo.write(30);
    delay(500);         // Wait for 500 milliseconds to allow the sensor to stabilize
    leftDistance = measureDistance();  // Measure the distance on the left

    // Rotate the servo motor to the right (150 degrees) to measure distance on the right side
    ultrasonicServo.write(150);
    delay(500);         // Wait for 500 milliseconds
    rightDistance = measureDistance();  // Measure the distance on the right

    // Return the servo motor to the front (90 degrees) position
    ultrasonicServo.write(90);

    // Compare distances on the left and right to decide which direction to turn
    if (leftDistance > rightDistance) {
      turnLeft();       // Turn left if the left side is clear
    } else {
      turnRight();      // Otherwise, turn right
    }
    delay(1000);        // Turn for 1 second before stopping or making further decisions
  } else {
    // If no obstacle is detected, continue moving forward
    moveForward();
  }
}


