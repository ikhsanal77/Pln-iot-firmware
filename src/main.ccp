// src/main.cpp
#include <Arduino.h>
#include "vibration_detection/vibration_detector.h"
#include "lora_comms/lora_handler.h"

VibrationDetector vibDetector;
LoraHandler lora;
unsigned long lastReport = 0;
const unsigned long reportInterval = 10000;

void setup() {
  Serial.begin(115200);
  if(!vibDetector.begin()) while(1);
  vibDetector.calibrate();
  lora.setup();
}

void loop() {
  if(vibDetector.detectAnomaly()) {
    String payload = "ALERT:" + String(vibDetector.getVibrationMagnitude());
    lora.sendData(payload);
  }
  if(millis() - lastReport > reportInterval) {
    String payload = "NORMAL:" + String(vibDetector.getVibrationMagnitude());
    lora.sendData(payload);
    lastReport = millis();
  }
  delay(100);
}
