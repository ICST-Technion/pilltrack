//CODE we have used to check how to read the switch using pull up feacher in esp32
#include "Arduino.h"
#include "PCF8574.h"

void setup() {

  Serial.begin(115200);
  pinMode(32, INPUT_PULLUP);
//	pcf8574.pinMode(P33, INPUT_PULLUP);

  // put your setup code here, to run once:

}

void loop() {
  uint8_t val0 = analogRead(32);
  Serial.print("pin 32 value is: ");
  Serial.println(val0);
  sleep(1);
  // put your main code here, to run repeatedly:

}

