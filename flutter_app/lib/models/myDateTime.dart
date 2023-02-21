import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';


tz.TZDateTime getTimeNow() {
  //tz.initializeTimeZones();
  //tz.setLocalLocation(tz.getLocation('Asia/Beirut'));
  var location = tz.getLocation('Asia/Beirut');
  var time =tz.TZDateTime.now(location);
  print('got time: $time');
  return time;
}

bool timeBefore(String t1, String t2){





  return false;
}

int getHour(String time){

  return int.parse(time.substring(0, 2));
}

int getMinutes(String time){

  return int.parse(time.substring(3, 5));
}

int convert_to_minutes(time){

  return (getHour(time) * 60 + getMinutes(time));
}