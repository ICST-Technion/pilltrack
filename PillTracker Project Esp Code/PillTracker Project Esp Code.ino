//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 02_Read_Data
/*
 *  Reference : https://randomnerdtutorials.com/esp32-firebase-realtime-database/
 */

//======================================== Including the libraries.
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include <BluetoothSerial.h>
#include "driver/adc.h"
#include <esp_bt.h>
#include "Arduino.h"
#include "PCF8574.h"
#include "time.h"
#include <FastLED.h>
//======================================== 

//defines :
//======================================== Insert your network credentials.
//#define WIFI_SSID "Mahmoud"
//#define WIFI_PASSWORD "Mahmoud123"
#define WIFI_SSID "HOTBOX-C27C"
#define WIFI_PASSWORD "7c034cbdc27c"
//#define WIFI_SSID "ICST"
//#define WIFI_PASSWORD "arduino123"
//#define WIFI_SSID "Zaina"
//#define WIFI_PASSWORD "isco2003"
//#define WIFI_SSID "Malak"
//#define WIFI_PASSWORD "1234malak"

//---for LED STRIP:
#define LED_PIN     4
#define LED2_PIN     12
#define NUM_LEDS    7
int BRIGHTNESS = 100;
#define LED_TYPE    WS2811
#define COLOR_ORDER GRB

//======================================== 
//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"
// Defines the Digital Pin of the "On Board LED".
#define On_Board_LED 2
// Insert Firebase project API Key
#define API_KEY "AIzaSyA2kwBfTpwbMU1fbguQJpqAiEbzZhYhomE"
// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://test-244b7-default-rtdb.firebaseio.com/" 

//Define Firebase Data object.
FirebaseData fbdo;

// Define firebase authentication.
FirebaseAuth auth;

// Definee firebase configuration.
FirebaseConfig config;

// Boolean variable for sign in status.
bool signupOK = false;
        

//-------------------------------------------------Config Params-----------------------------------------------------
#define UnrefilledBoxWarningNumber 10
bool connected = false;
int didNotRefillWorningCounter = UnrefilledBoxWarningNumber;
int searchBoxTimeInMinutes = 1;
int closePillMinutes = 1;
int modemSleepMins = 1;
int late1Time = 1 ;
int late2Time = 2;
//Global VARS:
int nextDoseRemainingMinutes = 0;
int nextDoseNumber = 0;
int modemSleepTime;
int tmpNum;
int tmpRemain;
int logIndex = 0;
bool tmpBool;
bool late1_reminder_flag = false;
bool late2_reminder_flag = false; 
bool boxes_light_on_flag = false;
bool pillTaken =false;
bool refill_untill_tommorow_reminder_flag = false;
CRGB leds[NUM_LEDS];
CRGB leds2[NUM_LEDS];
bool searchBox = false;
bool systemOk = true; 
bool refelling = false;
bool openBoxesMatrix[2][7] = {{false}};
String firstDoseTime;
String secondDoseTime;
String currentDay;
String currentHourMinte;
String nextDoseTime;
String tmpString;
String tmpPath;
String nextDoseState;
String refillDay;
String TmpDateTimeString;
String TmpOperationTimeString;


//For PCF:
PCF8574 pcf8574_1(0x20);
PCF8574 pcf8574_2(0x21);

//For Time Server
const char* ntpServer = "il.pool.ntp.org";
const long  gmtOffset_sec = 7200;
const int   daylightOffset_sec = 7200;//GMT+5:30

char buffer[25];
String tmp;



//--------------------------------------------------------
//________________________________________________________________________________ VOID SETUP
void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(115200);
  pinMode(0,OUTPUT);

  FastLED.addLeds<LED_TYPE, LED2_PIN, COLOR_ORDER>(leds, NUM_LEDS);
  FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds2, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  pcf8574_1.pinMode(P0, INPUT_PULLUP);
  pcf8574_1.pinMode(P1, INPUT_PULLUP);
  pcf8574_1.pinMode(P2, INPUT_PULLUP);
  pcf8574_1.pinMode(P3, INPUT_PULLUP);
  pcf8574_1.pinMode(P4, INPUT_PULLUP);
  pcf8574_1.pinMode(P5, INPUT_PULLUP);
  pcf8574_1.pinMode(P6, INPUT_PULLUP);
  pcf8574_1.begin();
  pcf8574_2.pinMode(P0, INPUT_PULLUP);
  pcf8574_2.pinMode(P1, INPUT_PULLUP);
  pcf8574_2.pinMode(P2, INPUT_PULLUP);
  pcf8574_2.pinMode(P3, INPUT_PULLUP);
  pcf8574_2.pinMode(P4, INPUT_PULLUP);
  pcf8574_2.pinMode(P5, INPUT_PULLUP);
  pcf8574_2.pinMode(P6, INPUT_PULLUP);
  pcf8574_2.begin();

  Serial.println();

  pinMode(On_Board_LED, OUTPUT);

  //---------------------------------------- The process of connecting the WiFi on the ESP32 to the WiFi Router/Hotspot.
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.println("---------------Connection");
  Serial.print("Connecting to : ");
  Serial.println(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");

    digitalWrite(On_Board_LED, HIGH);
    delay(250);
    digitalWrite(On_Board_LED, LOW);
    delay(250);
  }
  digitalWrite(On_Board_LED, LOW);
  Serial.println();
  Serial.print("Successfully connected to : ");
  Serial.println(WIFI_SSID);
  if(!connected){
    connected = true;
    boxConnectedApprovalLights();
  }
  
  //Serial.print("IP : ");
  //Serial.println(WiFi.localIP());
  Serial.println("---------------");
  //---------------------------------------- 

  // Init and get the time
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  printLocalTime();

  // Assign the api key (required).
  config.api_key = API_KEY;
  // Assign the RTDB URL (required).
  config.database_url = DATABASE_URL;
  // Sign up.
  Serial.println();
  Serial.println("---------------Sign up");
  Serial.print("Sign up new user... ");
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  Serial.println("---------------");
  
  // Assign the callback function for the long running token generation task.
  config.token_status_callback = tokenStatusCallback; //--> see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}
//________________________________________________________________________________

//________________________________________________________________________________ VOID LOOP

void loop() {
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  delay(150);

  // put your main code here, to run repeatedly:
  buildDateString();

  if (Firebase.ready() && signupOK ){
    //---------------------------------------- The process of reading data from firebase database.
    Serial.println();
    Serial.println("---------------Get Data");
    digitalWrite(On_Board_LED, HIGH);

    
    while(!Firebase.RTDB.getInt(&fbdo, "/userID/LOG INDEX")){delay(1000);}
    logIndex = fbdo.intData();
    Serial.print("logIndex is : ");
    Serial.println(logIndex);


    while(!Firebase.RTDB.getString(&fbdo, "/userID/pill times/first dose")){delay(1000);}
    firstDoseTime = fbdo.stringData();
    Serial.print("first does time is : ");
    Serial.println(firstDoseTime);
    
    
    while(!Firebase.RTDB.getString(&fbdo, "/userID/pill times/second dose")){delay(1000);}
    secondDoseTime = fbdo.stringData();
    Serial.print("second does time is : ");
    Serial.println(secondDoseTime);

    while(!Firebase.RTDB.getString(&fbdo, "/userID/info/refill day")){delay(1000);}
    refillDay = fbdo.stringData();
    Serial.print("refilling day is : ");
    Serial.println(secondDoseTime);
      
   
    while(!Firebase.RTDB.getBool(&fbdo, "/userID/search box")){delay(1000);}
    searchBox = fbdo.boolData();
    Serial.print("search box flag is : ");
    Serial.println(searchBox);
      
    
    while(!Firebase.RTDB.getBool(&fbdo, "/userID/systemOk")){delay(1000);}
    systemOk = fbdo.boolData();
    Serial.print("systemOk flag is : ");
    Serial.println(systemOk);
       
    
    while (!Firebase.RTDB.getBool(&fbdo, "/userID/refill box")){delay(1000);}
    refelling = fbdo.boolData();
    Serial.print("boxesRefelling flag is : ");
    Serial.println(refelling);

    digitalWrite(On_Board_LED, LOW);
  
//---------------------------------------------------------------------------------------
    currentDay = GetCurrentDay();
    currentHourMinte = GetCurrentHourMinute();
    Serial.print("current day is : ");
    Serial.println(currentDay);
    Serial.print("current HourMinute is : ");
    Serial.println(currentHourMinte);
    nextDoseTime = getNextDoseTime(currentHourMinte, firstDoseTime, secondDoseTime);
    Serial.print("next dose time is : ");
    Serial.println(nextDoseTime);
    nextDoseRemainingMinutes = (nextDoseTime == "END") ? -1 : TimeUntillReffInMinutes(currentHourMinte,nextDoseTime);
    Serial.print("remaining time till next dose is : ");
    Serial.println(nextDoseRemainingMinutes);
    nextDoseNumber = getDoseNumber(nextDoseTime, firstDoseTime, secondDoseTime);
    Serial.print("next dose number is : ");
    Serial.println(nextDoseNumber);
    //---------------------
    if(nextDoseNumber == 1){
         tmpString = "first cell";
    }else{
      tmpString = "second cell";            
    }
    if(nextDoseNumber == 1 || nextDoseNumber == 2){
       tmpPath = "/userID/taking pills/"+currentDay+"/"+tmpString;
       while(!Firebase.RTDB.getString(&fbdo,tmpPath) ){delay(1000);}
       nextDoseState = fbdo.stringData();
    }else{
      nextDoseState = "No Remaining Doses For Current Day ";
    }
    Serial.print("nextDoseState  is : ");
    Serial.println(nextDoseState);    
  }

    if((currentDay == refillDay) && (!refill_untill_tommorow_reminder_flag) && TimePassedBeforeHour(currentHourMinte,firstDoseTime)){
      tmpBool = true;
      while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/refill",tmpBool) ){delay(50);}
      while( !Firebase.RTDB.setBool(&fbdo,"/userID/waiting_for_refill",tmpBool) ){delay(50);}
      delay(1500);
      tmpBool = false;
      while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/refill",tmpBool) ){delay(50);}
      refill_untill_tommorow_reminder_flag = true ;
    }else if(currentDay == get_day_after_given(refillDay) && refill_untill_tommorow_reminder_flag  && TimePassedBeforeHour(currentHourMinte,firstDoseTime)){
      while(!Firebase.RTDB.getBool(&fbdo, "/userID/waiting_for_refill")){delay(50);}
      refill_untill_tommorow_reminder_flag = fbdo.boolData();
      Serial.print("refill_untill_tommorow_reminder_flag  is : ");
      Serial.println(refill_untill_tommorow_reminder_flag);      
      if(refill_untill_tommorow_reminder_flag){
      didNotRefillWorningCounter = didNotRefillWorningCounter - 1;
      tmpBool = true;
      if(didNotRefillWorningCounter >= 0) { 
        while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/didNotRefill",tmpBool) ){delay(50);}
      }
      delay(1500);
      tmpBool = false;
      while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/didNotRefill",tmpBool) ){delay(50);}
      while( !Firebase.RTDB.setBool(&fbdo,"/userID/systemOk",tmpBool) ){delay(50);}
      systemOk = false;        
      }else{
        didNotRefillWorningCounter = UnrefilledBoxWarningNumber;
        tmpBool = true;
        while( !Firebase.RTDB.setBool(&fbdo,"/userID/systemOk",tmpBool) ){delay(50);}
        systemOk = true;
      }
    }
    
    //---------------------------------------------------------------------------- crutial params end 
    if(refelling && systemOk){
      // if the user is filling the boxes:
      while(true){
        refillColors();
        BRIGHTNESS = (BRIGHTNESS+2)%100 ;        
        FastLED.setBrightness(BRIGHTNESS);
        FastLED.show();
        if (Firebase.ready() && signupOK ){
          while (!Firebase.RTDB.getBool(&fbdo, "/userID/refill box")){delay(1000);}
          refelling = fbdo.boolData();
          Serial.print("boxesRefelling flag is : ");
          Serial.println(refelling);
        }
        if(!refelling){
          BRIGHTNESS = 100 ;        
          FastLED.setBrightness(BRIGHTNESS);
          boxesLightOff();
          break;
        }
      }
    }else if(searchBox && systemOk){
      //if user is searching for the pills box :
      uint32_t oldtime = millis();
      while(true){
        if (Firebase.ready() && signupOK ){
          //---------------------------------------- The process of reading data from firebase database.
          Serial.println("---------------Get Data");
          digitalWrite(On_Board_LED, HIGH);
          if (Firebase.RTDB.getBool(&fbdo, "/userID/search box")) {
            searchBox = fbdo.boolData();
            Serial.print("search box flag is : ");
            Serial.println(searchBox);
            delay(50);
            while(!Firebase.RTDB.getBool(&fbdo, "/userID/systemOk")){delay(50);}
            systemOk = fbdo.boolData();
            Serial.print("systemOk flag is : ");
            Serial.println(systemOk);
              
            if(searchBox && systemOk){
              Serial.println("pill box search mode is on !!!");
              digitalWrite(0,HIGH);
              searchColors1();
              FastLED.show();
              delay(500);
              digitalWrite(0,LOW);
              searchColors2();
              FastLED.show();       
            }else{
              digitalWrite(0,LOW);
              boxesLightOff();
              digitalWrite(On_Board_LED, LOW);
              if(!systemOk){
                Serial.println("System is Broken ! :'(");
              }else{
                Serial.println("the user has found his pill box :)");
              }
              break;
            }
          }
          else {
            Serial.println(fbdo.errorReason());
          }
          digitalWrite(On_Board_LED, LOW);
        }
        if( (millis() - oldtime) > (searchBoxTimeInMinutes * 60 * 1000) ){
          tmpBool = false;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/search box",tmpBool) ){delay(50);}
          break;
        }
      }
    }else if((nextDoseRemainingMinutes > closePillMinutes || (nextDoseRemainingMinutes == -1) || nextDoseState=="taken") && systemOk){
      //if there are more than closePillMinutes minutes untill the next dose :  
      tmpNum = nextDoseRemainingMinutes - closePillMinutes;
     
      modemSleepTime = (tmpNum < 0) ? modemSleepMins : myMin(tmpNum, modemSleepMins);
      uint32_t oldtime = millis();
      setModemSleep();
      tmpRemain = modemSleepTime;
      while(true){
        // if patient opened box not int the right time:
        Serial.print("modem sleep for ");
        Serial.print(tmpRemain);
        Serial.println(" Minutes");
        tmpNum = getOpenBoxesNumber();
        lightRedOpenedBoxes();
        Serial.println(tmpNum);
        if( tmpNum > 0){
          Serial.println("please close opened boxes !!!");
          Serial.println("this is wrong to open a pill box at this time");
          digitalWrite(0,HIGH);
        }else {
          digitalWrite(0,LOW);
        }
        if ( (millis() - oldtime) > (modemSleepTime * 60 * 1000) ){
          digitalWrite(0,LOW);
          wakeModemSleep();
          // i am trying to not make new key:
          /*
          //--------For DB AFTER WAKEUP---------------------
          // Assign the api key (required).
          config.api_key = API_KEY;
          // Assign the RTDB URL (required).
          config.database_url = DATABASE_URL;
          // Sign up.
          Serial.println();
          Serial.println("---------------Sign up");
          Serial.print("Sign up new user... ");
          if (Firebase.signUp(&config, &auth, "", "")){
            Serial.println("ok");
            signupOK = true;
          }
          else{
            Serial.printf("%s\n", config.signer.signupError.message.c_str());
          }
          Serial.println("---------------");
  
          // Assign the callback function for the long running token generation task.
          config.token_status_callback = tokenStatusCallback; //--> see addons/TokenHelper.h
          Firebase.begin(&config, &auth);
          */  // try end
          Firebase.reconnectWiFi(true);
          //--------For DB AFTER WAKEUP---------------------
          boxesLightOff();
          break;
        }
        tmpRemain = modemSleepTime - (int)((millis() - oldtime)/60000);
        delay(100);
      }
    }else if((nextDoseRemainingMinutes <= closePillMinutes && nextDoseRemainingMinutes >= 0) && (nextDoseState != "taken") && systemOk){
      tmpBool = true;
      while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/reminder",tmpBool) ){delay(50);}
      Serial.println("Pill in comming minutes");
      tmpNum = getDayIndexForLeds(currentDay);
      if(nextDoseNumber == 1){
        leds[tmpNum] = CRGB::Aqua;
      }else if(nextDoseNumber == 2 ){
        leds2[tmpNum] = CRGB::Aqua;
      }
        FastLED.show();

      /*Notice that in case if pill taking there are two places in the DP that you have to update :
      1) /userID/notification/taken_pill which Malak use to notify the user in the smartphone app
      2) /userID/taking pills/<Rellevant Day>/took <first/second> to update it to one of the following :
      - "taken" : if the user opens the right cell within the pill taking time.
      - "late" : pill taking time passed and the user yet took his rellevant pill.
      Also,  if the user parcially is late after 15 mins of late time  update : "/userID/notification/late1" to be true .
             if the user did not take the pill in oll the pill time update : "/userID/notification/late2" to be true .
      */  
      while(true){
        currentHourMinte = GetCurrentHourMinute();
        // Dealing with box opennning ---------------------------
        resetOpenBoxesMatrix();
        int cnt = getOpenBoxesNumberInArray();
        while(cnt>1){
          lightRedOpenedBoxes();
          boxes_light_on_flag = true;
          digitalWrite(0,HIGH);
          resetOpenBoxesMatrix();
          cnt = getOpenBoxesNumberInArray();
          delay(50);          
        }
        digitalWrite(0,LOW);
        if(boxes_light_on_flag){
          boxesLightOff();
          boxes_light_on_flag = false;
          if(!late1_reminder_flag && !late2_reminder_flag){
            tmpNum = getDayIndexForLeds(currentDay);
            if(nextDoseNumber == 1){
             leds[tmpNum] = CRGB::Aqua;
            }else if(nextDoseNumber == 2 ){
              leds2[tmpNum] = CRGB::Aqua;
           }
           FastLED.show();
          }else{
            tmpNum = getDayIndexForLeds(currentDay);
            if(nextDoseNumber == 1){
             leds[tmpNum] = CRGB::Yellow;
            }else if(nextDoseNumber == 2 ){
              leds2[tmpNum] = CRGB::Yellow;
           }
           FastLED.show();
          }
        }

        resetOpenBoxesMatrix();
        cnt = getOpenBoxesNumberInArray();
        while(cnt == 1){
          int doseDayIndex = getDayIndexForLeds(currentDay);
          //if he opened the right pill cell :
          if(openBoxesMatrix[nextDoseNumber-1][doseDayIndex]){
            pillTaken = true;
           if(nextDoseNumber == 1){
             leds[tmpNum] = CRGB::Crimson;
           }else if(nextDoseNumber == 2 ){
             leds2[tmpNum] = CRGB::Crimson;
           }
            FastLED.show();
            delay(3000);
            break;
          }else{
            lightRedOpenedBoxes();
            boxes_light_on_flag = true;
            digitalWrite(0,HIGH);
          }
          resetOpenBoxesMatrix();
          cnt = getOpenBoxesNumberInArray();
          delay(50);          
        }
        digitalWrite(0,LOW);

        if(boxes_light_on_flag){
          boxesLightOff();
          boxes_light_on_flag = false;
          if(!late1_reminder_flag && !late2_reminder_flag){
            tmpNum = getDayIndexForLeds(currentDay);
            if(nextDoseNumber == 1){
             leds[tmpNum] = CRGB::Aqua;
            }else if(nextDoseNumber == 2 ){
              leds2[tmpNum] = CRGB::Aqua;
           }
           FastLED.show();
          }else{
            tmpNum = getDayIndexForLeds(currentDay);
            if(nextDoseNumber == 1){
             leds[tmpNum] = CRGB::Yellow;
            }else if(nextDoseNumber == 2 ){
            leds2[tmpNum] = CRGB::Yellow;
           }
           FastLED.show();
          }
        }
        
        if(pillTaken){ 
          tmpBool = true;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/taken_pill",tmpBool) ){delay(50);}
          if(nextDoseNumber == 1){
            tmpString = "first cell";
          }else if (nextDoseNumber == 2){
              tmpString = "second cell";            
          }else{
            while(true){
              Serial.println("Error Unvalid Dose Number");
            }
          }
          tmpPath = "/userID/taking pills/"+currentDay+"/"+tmpString;
          tmpString = "taken";
          while(!Firebase.RTDB.setString(&fbdo,tmpPath,tmpString) ){delay(50);}
          boxesLightOff();
          pillTaken =false;
//====================
          delay(1000);
          tmpBool = false;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/taken_pill",tmpBool) ){delay(50);}
//====================
          tmpString = String(logIndex);
          tmpPath = "/userID/LOG/"+tmpString+"/date";
          while(!Firebase.RTDB.setString(&fbdo,tmpPath,TmpDateTimeString) ){delay(50);}
          tmpPath = "/userID/LOG/"+tmpString+"/operation";
          TmpOperationTimeString = currentHourMinte + "     took pills";
          while(!Firebase.RTDB.setString(&fbdo,tmpPath,TmpOperationTimeString) ){delay(50);}

          tmpPath = "/userID/LOG/"+tmpString+"/selected";
          while(!Firebase.RTDB.setBool(&fbdo,tmpPath,false) ){delay(50);}

          tmpPath = "/userID/LOG/"+tmpString+"/status";
          while(!Firebase.RTDB.setInt(&fbdo,tmpPath,1) ){delay(50);}


          logIndex = logIndex + 1;
          while(!Firebase.RTDB.setInt(&fbdo,"/userID/LOG INDEX",logIndex) ){delay(50);}
          break;          
        }
        
        if(TimeUntillReffInMinutes(nextDoseTime,currentHourMinte) >= late1Time && !late1_reminder_flag){
          late1_reminder_flag = true;
          tmpBool = true;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/late1",tmpBool) ){delay(50);}
          delay(2000);
          while( !Firebase.RTDB.setBool(&fbdo,"/monitor/notification/late1",tmpBool) ){delay(50);}
          Serial.println("you are late1 for the pill");
          if(nextDoseNumber == 1){
            leds[tmpNum] = CRGB::Yellow;
          }else if(nextDoseNumber == 2 ){
           leds2[tmpNum] = CRGB::Yellow;
          }
          FastLED.show();
//====================
          delay(1000);
          tmpBool = false;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/late1",tmpBool) ){delay(50);}
          while( !Firebase.RTDB.setBool(&fbdo,"/monitor/notification/late1",tmpBool) ){delay(50);}
//====================
        }
        
        if(TimeUntillReffInMinutes(nextDoseTime,currentHourMinte) >= late2Time && !late2_reminder_flag ){
          late2_reminder_flag = true;
          tmpBool = true;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/late2",tmpBool) ){delay(50);}
          delay(2000);
          while( !Firebase.RTDB.setBool(&fbdo,"/monitor/notification/late2",tmpBool) ){delay(50);}
          Serial.println("you are late 2 for the pill");
//====================
          delay(1000);
          tmpBool = false;
          while( !Firebase.RTDB.setBool(&fbdo,"/userID/notification/late2",tmpBool) ){delay(50);}
          while( !Firebase.RTDB.setBool(&fbdo,"/monitor/notification/late2",tmpBool) ){delay(50);}
//====================
          if(nextDoseNumber == 1){
            tmpString = "first cell";
          }else if (nextDoseNumber == 2){
              tmpString = "second cell";            
          }else{
            while(true){
              Serial.println("Error Unvalid Dose Number");
            }
          }
          tmpPath = "/userID/taking pills/"+currentDay+"/"+tmpString;
          tmpString = "late";
          while( !Firebase.RTDB.setString(&fbdo,tmpPath,tmpString) ){delay(50);}
          // To be added : ligh red relivant box for 5 seconds
          late2_reminder_flag = false ;
          late1_reminder_flag = false ;

          for(int i=0 ; i<3 ;i++){
          if(nextDoseNumber == 1){
            leds[tmpNum] = CRGB::Red;
          }else if(nextDoseNumber == 2 ){
           leds2[tmpNum] = CRGB::Red;
          }
          FastLED.show();
          digitalWrite(0,HIGH);
          delay(1000);
          boxesLightOff();
          digitalWrite(0,LOW);
          delay(500);
          }
//////////////////////////////////////////////////////////////////// For Log
          tmpString = String(logIndex);
          tmpPath = "/userID/LOG/"+tmpString+"/date";
          while(!Firebase.RTDB.setString(&fbdo,tmpPath,TmpDateTimeString) ){delay(50);}
          tmpPath = "/userID/LOG/"+tmpString+"/operation";
          TmpOperationTimeString = currentHourMinte + "     late for pills";
          while(!Firebase.RTDB.setString(&fbdo,tmpPath,TmpOperationTimeString) ){delay(50);}

          tmpPath = "/userID/LOG/"+tmpString+"/selected";
          while(!Firebase.RTDB.setBool(&fbdo,tmpPath,false) ){delay(50);}

          tmpPath = "/userID/LOG/"+tmpString+"/status";
          while(!Firebase.RTDB.setInt(&fbdo,tmpPath,0) ){delay(50);}


          logIndex = logIndex + 1;
          while(!Firebase.RTDB.setInt(&fbdo,"/userID/LOG INDEX",logIndex) ){delay(50);}         
////////////////////////////////////////////////////////////////////////////////////
          break;
        }
        delay(500);
      }
    }
  delay(2000);  
}

//________________________________________________________________________________
void searchColors1(){
  leds[0] = CRGB::Yellow;
  leds[1] = CRGB::Aqua;
  leds[2] = CRGB::Green;
  leds[3] = CRGB::Red;
  leds[4] = CRGB::Chartreuse;
  leds[5] = CRGB::BurlyWood;
  leds[6] = CRGB::Brown;
  leds2[0] = CRGB::CornflowerBlue;
  leds2[1] = CRGB::Crimson;
  leds2[2] = CRGB::Cyan;
  leds2[3] = CRGB::DarkBlue;
  leds2[4] = CRGB::DarkGoldenrod;
  leds2[5] = CRGB::DarkGreen;
  leds2[6] = CRGB::Maroon;
}

void searchColors2(){
  leds[0] = CRGB::Cyan;
  leds[1] = CRGB::Beige;
  leds[2] = CRGB::DarkBlue;
  leds[3] = CRGB::DarkGoldenrod;
  leds[4] = CRGB::Crimson;
  leds[5] = CRGB::Chartreuse;
  leds[6] = CRGB::CornflowerBlue;
  leds2[0] = CRGB::Brown;
  leds2[1] = CRGB::BurlyWood;
  leds2[2] = CRGB::Yellow;
  leds2[3] = CRGB::Aquamarine;
  leds2[4] = CRGB::DarkGreen;
  leds2[5] = CRGB::Red;
  leds2[6] = CRGB::DarkOliveGreen;
}

void boxConnectedApprovalLights(){
  for(int i = 0 ; i<3 ; i++){
  leds[0] = CRGB::Green;
  leds[1] = CRGB::Green;
  leds[2] = CRGB::Green;
  leds[3] = CRGB::Green;
  leds[4] = CRGB::Green;
  leds[5] = CRGB::Green;
  leds[6] = CRGB::Green;
  leds2[0] = CRGB::Green;
  leds2[1] = CRGB::Green;
  leds2[2] = CRGB::Green;
  leds2[3] = CRGB::Green;
  leds2[4] = CRGB::Green;
  leds2[5] = CRGB::Green;
  leds2[6] = CRGB::Green;
  FastLED.show();
  delay(1000);
  boxesLightOff();
  delay(500);
  }
}

void refillColors(){
  leds[0] = CRGB::MintCream;
  leds[1] = CRGB::MintCream;
  leds[2] = CRGB::MintCream;
  leds[3] = CRGB::MintCream;
  leds[4] = CRGB::MintCream;
  leds[5] = CRGB::MintCream;
  leds[6] = CRGB::MintCream;
  leds2[0] = CRGB::MintCream;
  leds2[1] = CRGB::MintCream;
  leds2[2] = CRGB::MintCream;
  leds2[3] = CRGB::MintCream;
  leds2[4] = CRGB::MintCream;
  leds2[5] = CRGB::MintCream;
  leds2[6] = CRGB::MintCream;
}

int getDayIndexForLeds(String day){
  //returns natural day number minus 1
  if(day == "Sunday"){
    return 0;
  }else if(day == "Monday"){
    return 1;
  }else if ( day == "Tuesday"){
    return 2;
  }else if (day == "Wednesday"){
    return 3;    
  }else if (day == "Thursday"){
    return 4;
  }else if(day == "Friday"){
    return 5;
  }else if (day == "Saturday"){
    return 6;
  }else{
    return -1;
  }
}
void boxesLightOff(){
  leds[0] = CRGB::Black;
  leds[1] = CRGB::Black;
  leds[2] = CRGB::Black;
  leds[3] = CRGB::Black;
  leds[4] = CRGB::Black;
  leds[5] = CRGB::Black;
  leds[6] = CRGB::Black;
  leds2[0] = CRGB::Black;
  leds2[1] = CRGB::Black;
  leds2[2] = CRGB::Black;
  leds2[3] = CRGB::Black;
  leds2[4] = CRGB::Black;
  leds2[5] = CRGB::Black;
  leds2[6] = CRGB::Black;
  FastLED.show();
}
void lightRedOpenedBoxes(){
  uint8_t val0 =pcf8574_1.digitalRead(P0);
  uint8_t val1 =pcf8574_1.digitalRead(P1);
  uint8_t val2 =pcf8574_1.digitalRead(P2);
  uint8_t val3 =pcf8574_1.digitalRead(P3);
  uint8_t val4 =pcf8574_1.digitalRead(P4);
  uint8_t val5 =pcf8574_1.digitalRead(P5);
  uint8_t val6 =pcf8574_1.digitalRead(P6);
  uint8_t val0_2 =pcf8574_2.digitalRead(P0);
  uint8_t val1_2 =pcf8574_2.digitalRead(P1);
  uint8_t val2_2 =pcf8574_2.digitalRead(P2);
  uint8_t val3_2 =pcf8574_2.digitalRead(P3);
  uint8_t val4_2 =pcf8574_2.digitalRead(P4);
  uint8_t val5_2 =pcf8574_2.digitalRead(P5);
  uint8_t val6_2 =pcf8574_2.digitalRead(P6);
  if(val0){
    leds[0] = CRGB::Red;
  }else{
    leds[0] = CRGB::Black;
  }
  if(val0_2){
    leds2[0] = CRGB::Red;
  }else{
    leds2[0] = CRGB::Black;
  }
  if(val1){
    leds[1] = CRGB::Red;
  }else{
    leds[1] = CRGB::Black;
  }
  if(val1_2){
    leds2[1] = CRGB::Red;
  }else{
    leds2[1] = CRGB::Black;
  }
  if(val2){
    leds[2] = CRGB::Red;
  }else{
    leds[2] = CRGB::Black;
  }
  if(val2_2){
    leds2[2] = CRGB::Red;
  }else{
    leds2[2] = CRGB::Black;
  }
  if(val3){
    leds[3] = CRGB::Red;
  }else{
    leds[3] = CRGB::Black;
  }
  if(val3_2){
    leds2[3] = CRGB::Red;
  }else{
    leds2[3] = CRGB::Black;
  }
  if(val4){
    leds[4] = CRGB::Red;
  }else{
    leds[4] = CRGB::Black;
  }
  if(val4_2){
    leds2[4] = CRGB::Red;
  }else{
    leds2[4] = CRGB::Black;
  }
  if(val5){
    leds[5] = CRGB::Red;
  }else{
    leds[5] = CRGB::Black;    
  }
  if(val5_2){
    leds2[5] = CRGB::Red;
  }else{
    leds2[5] = CRGB::Black;
  }
  if(val6){
    leds[6] = CRGB::Red;
  }else{
    leds[6] = CRGB::Black;
  }
  if(val6_2){
    leds2[6] = CRGB::Red;
  }else{
    leds2[6] = CRGB::Black;
  }
  FastLED.show();
  delay(50);
}
 
int getOpenBoxesNumber(){
  int c = 0;
  uint8_t val0 =pcf8574_1.digitalRead(P0);
  if(val0){c++;}
  uint8_t val1 =pcf8574_1.digitalRead(P1);
  if(val1){c++;}
  uint8_t val2 =pcf8574_1.digitalRead(P2);
  if(val2){c++;}
  uint8_t val3 =pcf8574_1.digitalRead(P3);
  if(val3){c++;}
  uint8_t val4 =pcf8574_1.digitalRead(P4);
  if(val4){c++;}
  uint8_t val5 =pcf8574_1.digitalRead(P5);
  if(val5){c++;}
  uint8_t val6 =pcf8574_1.digitalRead(P6);
  if(val6){c++;}
  uint8_t val0_2 =pcf8574_2.digitalRead(P0);
  if(val0_2){c++;}
  uint8_t val1_2 =pcf8574_2.digitalRead(P1);
  if(val1_2){c++;}
  uint8_t val2_2 =pcf8574_2.digitalRead(P2);
  if(val2_2){c++;}
  uint8_t val3_2 =pcf8574_2.digitalRead(P3);
  if(val3_2){c++;}
  uint8_t val4_2 =pcf8574_2.digitalRead(P4);
  if(val4_2){c++;}
  uint8_t val5_2 =pcf8574_2.digitalRead(P5);
  if(val5_2){c++;}
  uint8_t val6_2 =pcf8574_2.digitalRead(P6);
  if(val6_2){c++;}
  delay(50);
  return c;
}

//openBoxesMatrix[doseNum][days]
int getOpenBoxesNumberInArray(){
  int c = 0;
  uint8_t val0 =pcf8574_1.digitalRead(P0);
  if(val0){
    c++;
    openBoxesMatrix[0][0]=true;
    }
  uint8_t val1 =pcf8574_1.digitalRead(P1);
  if(val1){
    c++;
    openBoxesMatrix[0][1]=true;
    }
  uint8_t val2 =pcf8574_1.digitalRead(P2);
  if(val2){
    c++;
    openBoxesMatrix[0][2]=true;
    }
  uint8_t val3 =pcf8574_1.digitalRead(P3);
  if(val3){
    c++;
    openBoxesMatrix[0][3]=true;
    }
  uint8_t val4 =pcf8574_1.digitalRead(P4);
  if(val4){
    c++;
    openBoxesMatrix[0][4]=true;
    }
  uint8_t val5 =pcf8574_1.digitalRead(P5);
  if(val5){
    c++;
    openBoxesMatrix[0][5]=true;
    }
  uint8_t val6 =pcf8574_1.digitalRead(P6);
  if(val6){
    c++;
    openBoxesMatrix[0][6]=true;
    }
  uint8_t val0_2 =pcf8574_2.digitalRead(P0);
  if(val0_2){
    c++;
    openBoxesMatrix[1][0]=true;
    }
  uint8_t val1_2 =pcf8574_2.digitalRead(P1);
  if(val1_2){
    c++;
    openBoxesMatrix[1][1]=true;
  }
  uint8_t val2_2 =pcf8574_2.digitalRead(P2);
  if(val2_2){
    c++;
    openBoxesMatrix[1][2]=true;
  }
  uint8_t val3_2 =pcf8574_2.digitalRead(P3);
  if(val3_2){
    c++;
    openBoxesMatrix[1][3]=true;
  }
  uint8_t val4_2 =pcf8574_2.digitalRead(P4);
  if(val4_2){
    c++;
    openBoxesMatrix[1][4]=true;
  }
  uint8_t val5_2 =pcf8574_2.digitalRead(P5);
  if(val5_2){
    c++;
    openBoxesMatrix[1][5]=true;
  }
  uint8_t val6_2 =pcf8574_2.digitalRead(P6);
  if(val6_2){
    c++;
    openBoxesMatrix[1][6]=true;
  }
  delay(50);
  return c;
}


void resetOpenBoxesMatrix(){
  for(int i = 0; i<2 ;i++){
    for(int j =0; j<7;j++){
      openBoxesMatrix[i][j]=false;
    }
  }
}

int myMin(int num1, int num2){
  return (num1 < num2)? num1 : num2;
}
int getDoseNumber(String nextDoseTime,String firstDoseTime,String secondDoseTime){
  if(nextDoseTime == firstDoseTime){
    return 1;
  }else if(nextDoseTime == secondDoseTime){
    return 2;
  }else {
    return 3;
  }
}
String getNextDoseTime(String currentHourMinte, String firstDoseTime, String secondDoseTime){
  if(!TimePassed(currentHourMinte,firstDoseTime)){
    return firstDoseTime;
  }else if (!TimePassed(currentHourMinte,secondDoseTime)){
    return secondDoseTime;
  }else {
    return "END";
  }
}

void setModemSleep() {
    disableWiFi();
    disableBluetooth();
    //setCpuFrequencyMhz(40);
    // Use this if 40Mhz is not supported
    // setCpuFrequencyMhz(80);
}
void wakeModemSleep() {
    //setCpuFrequencyMhz(240);
    enableWiFi();
}
void disableWiFi(){
    adc_power_off();
    WiFi.disconnect(true);  // Disconnect from the network
    WiFi.mode(WIFI_OFF);    // Switch WiFi off
    Serial2.println("");
    Serial2.println("WiFi disconnected!");
}
void disableBluetooth(){
    // Quite unusefully, no relevable power consumption
    btStop();
    Serial2.println("");
    Serial2.println("Bluetooth stop!");
}
 
void enableWiFi(){
    adc_power_on();
    delay(200);
 
    WiFi.disconnect(false);  // Reconnect the network
    WiFi.mode(WIFI_STA);    // Switch WiFi off
 
    delay(200);
 
    Serial2.println("START WIFI");
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

 
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial2.print(".");
    }
    Serial2.println("");
    Serial2.println("WiFi connected");
    Serial2.println("IP address: ");
    Serial2.println(WiFi.localIP());
}

String GetCurrentDay(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return "";
  }
  sprintf(buffer,"%d", timeinfo.tm_wday);
  return Day_Hash_Map(buffer);
}

String GetCurrentHour(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return "";
  }
  sprintf(buffer,"%d", timeinfo.tm_hour);
  return buffer;
}

String GetCurrentMinute(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return "";
  }
  sprintf(buffer,"%d", timeinfo.tm_min);
  return buffer;
}

String GetCurrentSec(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return "";
  }
  sprintf(buffer,"%d", timeinfo.tm_sec);
  return buffer;
}

String GetCurrentHourMinute(){
  String hourTmp = GetCurrentHour();
  if(hourTmp.length() == 1){
    hourTmp = "0" + hourTmp; 
  }
  String minuteTmp = GetCurrentMinute();
  if(minuteTmp.length() == 1){
    minuteTmp = "0" + minuteTmp;
  }
  sprintf(buffer,"%S:%S",hourTmp,minuteTmp);
  return buffer;  
}

void printLocalTime(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }
  Serial.println(&timeinfo, "%A, %B %d %Y %H:%M:%S");
  sprintf(buffer,"%d", timeinfo.tm_wday);
  Serial.print("The Day is: ");
  tmp = Day_Hash_Map(buffer);
  Serial.println(tmp);
  sprintf(buffer,"%d", timeinfo.tm_hour);
  //tmp = (char[10])timeinfo.tm_hour;
  Serial.print("The Hour is:");
  Serial.println(buffer);
  sprintf(buffer,"%d", timeinfo.tm_min);
  Serial.print("The Minute is:");
  Serial.println(buffer);
  sprintf(buffer,"%d", timeinfo.tm_sec);
  Serial.print("The Sec is:");
  Serial.println(buffer);
}

String Day_Hash_Map(String x){
  if (x == "1"){
    return "Monday";
  }else if(x == "2"){
    return "Tuesday";
  }else if(x == "3"){
    return "Wednesday";
  }else if(x == "4"){
    return "Thursday";
  }else if(x == "5"){
    return "Friday";
  }else if(x == "6"){
    return "Saturday";
  }else if(x == "7"){
    return "Sunday";
  }
}

String get_day_after_given(String given_day){
  if (given_day == "Monday"){
    return "Tuesday";
  }else if(given_day == "Tuesday"){
    return "Wednesday";
  }else if(given_day == "Wednesday"){
    return "Thursday";
  }else if(given_day == "Thursday"){
    return "Friday";
  }else if(given_day == "Friday"){
    return "Saturday";
  }else if(given_day == "Saturday"){
    return "Sunday";
  }else if(given_day == "Sunday"){
    return "Monday";
  }
}

int TimeUntillReffInMinutes(String Time1, String Ref)
{
  if(TimePassed(Time1,Ref)){
    return -1;
  }else{
    String tmpHour;
    String tmpMinute;
    int Hour1;
    int Minute1;
    int Hour2;
    int Minute2;
    tmpHour = getValue(Time1, ':', 0);
    tmpMinute = getValue(Time1, ':', 1);
    Hour1 = tmpHour.toInt();
    Minute1 = tmpMinute.toInt();
    tmpHour = getValue(Ref, ':', 0);
    tmpMinute = getValue(Ref, ':', 1);
    Hour2 = tmpHour.toInt();
    Minute2 = tmpMinute.toInt();
    return((Hour2-Hour1)*60 + (Minute2-Minute1));
  }  
}


bool TimePassed(String Time1, String Time2)
{
    String tmpHour;
    String tmpMinute;
    int Hour1;
    int Minute1;
    int Hour2;
    int Minute2;
    tmpHour = getValue(Time1, ':', 0);
    tmpMinute = getValue(Time1, ':', 1);
    Hour1 = tmpHour.toInt();
    Minute1 = tmpMinute.toInt();
    tmpHour = getValue(Time2, ':', 0);
    tmpMinute = getValue(Time2, ':', 1);
    Hour2 = tmpHour.toInt();
    Minute2 = tmpMinute.toInt();
    if((Hour1 > Hour2) || ((Hour1 == Hour2)&&(Minute1>Minute2))){
      return true;
    }else{
       return false;
    }
}

bool TimePassedBeforeHour(String Time1, String Time2)
{
    String tmpHour;
    String tmpMinute;
    int Hour1;
    int Minute1;
    int Hour2;
    int Minute2;
    tmpHour = getValue(Time1, ':', 0);
    tmpMinute = getValue(Time1, ':', 1);
    Hour1 = tmpHour.toInt();
    Minute1 = tmpMinute.toInt();
    tmpHour = getValue(Time2, ':', 0);
    tmpMinute = getValue(Time2, ':', 1);
    Hour2 = tmpHour.toInt();
    Hour2 = Hour2 - 1;    
    Minute2 = tmpMinute.toInt();
    if((Hour1 > Hour2) || ((Hour1 == Hour2)&&(Minute1>Minute2))){
      return true;
    }else{
       return false;
    }
}



String getValue(String data, char separator, int index)
{
    int found = 0;
    int strIndex[] = { 0, -1 };
    int maxIndex = data.length() - 1;

    for (int i = 0; i <= maxIndex && found <= index; i++) {
        if (data.charAt(i) == separator || i == maxIndex) {
            found++;
            strIndex[0] = strIndex[1] + 1;
            strIndex[1] = (i == maxIndex) ? i+1 : i;
        }
    }
    return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}


//LEDS IO  TO DAYS OF THE WEEK Mapping 
/*
les[0]  <----  Sunday FIRST
les2[0] <----  Sunday SECOND

les[1]  <----  Monday FIRST
les2[1] <----  Monday SECOND

les[2]  <----  Tuesday FIRST
les2[2] <----  Tuseday SECOND

les[3]  <----  Wednesday FIRST
les2[3] <----  Wednesday SECOND

les[4]  <----  Thursday FIRST
les2[4] <----  Thursday SECOND

les[5]  <----  Friday FIRST
les2[5] <----  Friday SECOND

les[6]  <----  Saturday FIRST
les2[6] <----  Saturday SECOND
*/

void buildDateString(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }

  Serial.println("heeeereeee heeeeer heeeeer");
  sprintf(buffer,"%d", timeinfo.tm_year);
  TmpDateTimeString = String(buffer);
  tmpNum = TmpDateTimeString.toInt();
  tmpNum = tmpNum + 1900;
  sprintf(buffer,"%d",tmpNum);
  String yyyear = String(buffer);
  //Serial.println(buffer);
  sprintf(buffer,"%d", timeinfo.tm_mon);
  TmpDateTimeString = String(buffer);
  tmpNum = TmpDateTimeString.toInt();
  tmpNum = tmpNum + 1;
  sprintf(buffer,"%d",tmpNum);
  String mmmonth = String(buffer);
  if(mmmonth.length() == 1){
    mmmonth = "0" + mmmonth;
  }
  //Serial.println(buffer);
  sprintf(buffer,"%d", timeinfo.tm_mday);
  String ddday = String(buffer);
  if(ddday.length() == 1){
    ddday = "0" + ddday;
  }
  //Serial.println(buffer);
  TmpDateTimeString = ddday+"/"+mmmonth+"/"+yyyear;
  Serial.println(TmpDateTimeString);
}
