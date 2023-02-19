/*
Code we used to read 2 switches using 2 deifferent pcf's
*/
/*
To be added to github ^_^ 
*/
#include "Arduino.h"
#include "PCF8574.h"

// Set i2c address
PCF8574 pcf8574_1(0x20);
PCF8574 pcf8574_2(0x21);


void setup()
{
	Serial.begin(115200);
	// Set pinMode to OUTPUT
	//pcf8574_1.pinMode(P0, OUTPUT);
	pcf8574_1.pinMode(P1, INPUT_PULLUP);
  pcf8574_1.begin();
  //pcf8574_2.pinMode(P0, OUTPUT);
	pcf8574_2.pinMode(P1, INPUT_PULLUP);
  pcf8574_2.begin();
}

void loop()
{
  //Serial.println("Adafruit Entering the loop!!!! ^__^");
  uint8_t val0 =pcf8574_1.digitalRead(P1);
  uint8_t val1 =pcf8574_2.digitalRead(P1);
  Serial.print("first switch value is: ");
  Serial.println(val0);
  Serial.print("second switch value is: ");
  Serial.println(val1);
  sleep(1);
}
