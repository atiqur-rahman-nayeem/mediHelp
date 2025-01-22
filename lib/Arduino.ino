#include <WiFi.h>
#include <FirebaseESP32.h>
const char* ssid = "BB";
const char* password = "12345123";
const char* firebaseHost = "https://medihelp-35d06-default-rtdb.firebaseio.com";
const char* firebaseAuth = "AIzaSyAlysZ6hWd4skpk8oF6GBephvvJMkER5Vs";

// Define the Firebase Data object
FirebaseData firebaseData;
const int pulsePin = 4; // Replace with the GPIO pin you're using
const int numSamples = 10;
int sensorValues[numSamples];
int currentIndex = 0;
const int tempPin = 2;     //analog input pin constant

int tempVal;    // temperature sensor raw readings

float volts;    // variable for storing voltage

float temp;
unsigned long lastBeatTime = 0;
int beatsPerMinute;
int beatThreshold = 550; // Adjust this threshold based on your sensor's output
unsigned long lastBPMUpdateTime = 0;
const int bpmUpdateInterval = 1000; // Update BPM every 1 second

void setup() {
    Serial.begin(115200);
    // Connect to Wi-Fi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    // Initialize Firebase
    Firebase.begin(firebaseHost, firebaseAuth);
    pinMode(pulsePin, INPUT);

    for (int i = 0; i < numSamples; i++) {
        sensorValues[i] = 0;
    }
}

void loop() {

    tempVal = analogRead(tempPin);

    volts = tempVal/1023.0;             // normalize by the maximum temperature raw reading range

    temp = (volts - 0.5) * 100 ;         //calculate temperature celsius from voltage as per the equation found on the sensor spec sheet.

    Serial.print(" Temperature is:   "); // print out the following string to the serial monitor
    Serial.print(temp);                  // in the same line print the temperature
    Serial.println (" degrees C");       // still in the same line print degrees C, then go to next line.


    // Read the sensor value
    int sensorValue = analogRead(pulsePin);

    // Store the value in the array
    sensorValues[currentIndex] = sensorValue;
    currentIndex = (currentIndex + 1) % numSamples;

    // Check for a heartbeat using a threshold
    if (sensorValue > beatThreshold && sensorValues[(currentIndex + 1) % numSamples] < beatThreshold) {
        // A beat is detected
        unsigned long currentTime = millis();
        unsigned long timeSinceLastBeat = currentTime - lastBeatTime;
        lastBeatTime = currentTime;

        // Calculate beats per minute
        if (timeSinceLastBeat > 0) {
            beatsPerMinute = 60000 / timeSinceLastBeat;
        }

        // Only update BPM once every second to filter out rapid fluctuations
        if (currentTime - lastBPMUpdateTime >= bpmUpdateInterval) {
            // Display BPM in the serial monitor
            float x = map(beatsPerMinute, 0, 4095, 50, 120);
            Serial.print("BPM: ");
            Serial.println(x);

            lastBPMUpdateTime = currentTime;
        }
    }

    if (Firebase.setFloat(firebaseData, "heart_rate", x)) {
        Serial.print("BPM: ");
        Serial.println(x);
    } else {
        Serial.println("Failed to upload BPM data to Firebase.");
        Serial.println("Error: " + firebaseData.errorReason());
    }

    // Upload the MQ7 sensor value to Firebase
    if (Firebase.setFloat(firebaseData, "body_temp", temp)) {
        Serial.print("TEmp: ");
        Serial.println(temp);
    } else {
        Serial.println("Failed to upload temp data to Firebase.");
        Serial.println("Error: " + firebaseData.errorReason());
    }

    delay(10000);
}
