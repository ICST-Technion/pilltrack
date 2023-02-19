## Pilltrack Project by : Malak Marrid, Mahmoud Massarwi & Zaina Darawsha.
In this project we have built a smart pill box that makes it easy for patients to track their pill doses over a week (7 days), pill doses times, and to get 
notified by a smartphone app to take doses in time and to not miss any.
The smart pill box is responsive, and gives sound and visual notifications to help the patient. 

## Our Project in details :
First, the patient and his monitor log in our app.\
The patient chooses one day of the week as a "refill day".\
In the app, the patient can choose the 2 pill doses times through the day that he want to take the pill at these times through the week.\
If the patient forgot where the pill box is, he can press on search for box botton in the app the that will couse the pill box to light in different colors 
and make loud continuous sound to help the patient find the box location.\
5 minutes befroe each pill does time, the patiient will get notified in the app that he has to take his pill. and the suitable cell in the pill box will light in blue to help the patient take the right does.\
If the patient took his pill the suitable cell will light in purble to confirm taht and he will get app notification for that and there is a table in the app that shows the status of each pill dose through the week. and it will be updated in the suitable plcae that he took the pill for that does in time.\
If the patient did not take the pill in time untill 15 minutes after the pill dose time, the patient and the monitro will both get notified that the patient is 15 minutes late for the pill and the suitabel cell in the pill box for that does will light in yellow so the monitor can call the patient check him and assure he gets the pill in time.\
If the patient is reminded and took the pill, he will get notification for that and the pill does table will be updated accordingly.\
if the patient is 30 minutes late for the pill does, he and the monitor will get notified that he was too late to get his pill does and the suitable cell
in the pill box will light on and off in red color with on and off sound for three times and in the app the pill doses table will be updated that the patient
was late for this spesific dose.\
One day befroe the "refill time" the patient will get an app notification as a reminder that he need to refill the pill box in the coming 24 hours.\
in the refill day, and before the first does, if the patient did not refill the box according to the reminder notification (the pill box in that case gonna be empty) the system will stop.

## Project Poster:
![pilltrack_poster_page-0001](https://user-images.githubusercontent.com/116976579/219964681-bfead2e6-48d1-4b6d-91fa-6e38bef64aa1.jpg)

## In this project git you will find these folders :
#### - README file : this file :D
#### - EspCode folder: in that folder you will find the source code we have built for the esp side (hardware).
#### - SECRETS ?
#### - How to use file:
#### - UNIT TESTS file: contains tests we have does to validate how some hardware parts work.
#### - Configirations: in that file you can find description on how to config some parammeters we used in the project code.

## Arduino/ESP libraries installed for the project:
* Arduino_ConnectionHandler - version 0.7.2
* Arduino_DebugUtils - version 1.4.0
* ArduinoECCX08 - version 1.3.7
* ArduinoIO TCloud - version 1.8.0
* ArduinoMqttClient - version 0.1.6
* MKRGSM - version 1.5.0
* MKRNB - version 1.5.1
* MKRWAN - version 1.1.0
* RTCZero - version 1.6.0
* Wifi101 - version 0.16.1
* WiFiNINA - version 1.8.13
* Adafruit BusIO - version 1.14.1
* Adafruit PCF8574 - version 1.1.0
* Adafruit SleepyDog - version 1.6.3
* EasyPCF8574 - version 1.1.0
* FaBo 212 LCD PCF8574 - version 1.0.0
* FastLED - version 3.5.0
* Firebase Arduino Client Library for ESP8266 and ESP32 - version 4.2.7
* PCF8574 library - version 2.3.4
