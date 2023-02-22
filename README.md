## Pilltrack Project by : Malak Marrid, Mahmoud Massarwi & Zaina Darawsha.
In this project we have built a smart pill box that makes it easy for patients to track their pill doses over a week (7 days), pill doses times, and to get 
notified by a smartphone app when the pill times come and when they are late for pills. In addition, a helper of the patient can use the app to see the patient LOG and get notified when the patient is late for pills.
The smart pill box is responsive, and gives sound and visual notifications to help the patient. 

## Our Project in details :
First, the patient and his helper both signup to the app (each on his phone).
The patient enters the pill times and chooses a "refill day": when the box needs refill after 1 week of use.
1. Settings: Inside the app, the patient can update the pill times: 2 times per day in which the patient will take his pill doses (2 cells in the box per day) .
2. Search Box: If the patient forgot where the pill box is, he can press on "search box" botton in the app the that will cause the pill box to light in different colors 
and make loud continuous sounds to help the patient find the box location.
3. Reminders: 5 minutes before each pill does time, the patient will get a reminder notification to take his pills. and the suitable cell in the pill box will light in blue to help the patient take the right dose.
4. Pills taken in time: If the patient took his pills from the right cell, it will light in purple to confirm him that he's done okay, and he will get a "good job notification". There is a virtual pill box in the app that shows the status of each pill dose through the week and it will be updated in the suitable cell with a v mark.
5. Late for pills: If the patient did not take the pill in time untill 15 minutes after the pill dose time, the patient and the helper person will both get notified and the relevant cell in the pill box for that does will light in yellow. The helper person is expected to call the patient and assure he gets the pills asap.\
If the patient takes the pills now he is okay and the status in the app will be updated to "taken".
Otherwise, if the patient is 30 minutes late for the pill does, he and the helper again will get notified that he was too late to get his pills and the relevant cell
in the pill box will light on and off in red color with sound for 3sec and in the app the status will be updated to "late".
6. Refill day: One day before the "refill day" the patient will get a reminder that he needs to refill the pill box in the coming 24 hours (so he has time to buy pills in case they ran out).
one day after the refill day, and before the first does, if the patient did not refill the box according to the reminder notification, he will get another warning which asks him to refill since the pill box in that case is empty(after 1 week of use) so the whole system (pillbox + app) will freeze until the user confirms in the app that he refilled the whole box.
7. LOG: both the user and the helper can see a log of the operations (what was the status of taking pills in each date).
## Project Poster:
![pilltrack_poster_page-0001](https://user-images.githubusercontent.com/116976579/219964681-bfead2e6-48d1-4b6d-91fa-6e38bef64aa1.jpg)

## In this project git you will find these folders :
#### - README file : this file :D
#### - EspCode folder: in that folder you will find the source code we have built for the esp side (hardware).
#### - How to run the system: wiring diagram + steps to run the system.
#### - UNIT TESTS: contains tests we have does to validate how some hardware parts work.
#### - flutter_app : dart code files for the flutter app.
#### - StatesAndConfigirations: contains 2 files, one file is about configurable_parameters we used in the project code and another pdf file describing the different states in our system and how we move from one another, including how we handle errors.
#### - link to app features&tests: https://drive.google.com/drive/folders/1LCiqWJl7VVG6eHTiEd6VVtLLuSFPIfDv

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
