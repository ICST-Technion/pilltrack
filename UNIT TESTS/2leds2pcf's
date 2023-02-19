/*
The code we used to talk with 2 regular leds through 2 different pcf's: 
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
	pcf8574_1.pinMode(P0, OUTPUT);
	pcf8574_1.pinMode(P1, INPUT);
  pcf8574_1.begin();
  pcf8574_2.pinMode(P0, OUTPUT);
	pcf8574_2.pinMode(P1, INPUT);
  pcf8574_2.begin();
}

void loop()
{
  Serial.println("Adafruit Entering the loop!!!! ^__^");
	pcf8574_1.digitalWrite(P0, HIGH);
  pcf8574_2.digitalWrite(P0, LOW);

	delay(1000);
	pcf8574_1.digitalWrite(P0, LOW);
  pcf8574_2.digitalWrite(P0, HIGH);
	delay(1000);
}
