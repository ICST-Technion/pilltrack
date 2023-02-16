import 'package:iot/models/box_cell_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

var sysOK = 1;
String currUserType = 'patient';
String currUserID = 'userID';
int late1_time = 1;
int late2_time = 4;
int reminder_before = 5;

Future<void> sendMail() async {
  String username = 'pilltrack.22.iot@gmail.com';
  String password = 'mmz22iot';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Your name')
    ..recipients.add('malakmarred159@gmail.com')
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
/*
tz.TZDateTime getTimeNow() {
  //tz.initializeTimeZones();
  //tz.setLocalLocation(tz.getLocation('Asia/Beirut'));
  var location = tz.getLocation('Asia/Beirut');
  var time =tz.TZDateTime.now(location);
  print('got time: $time');
  return time;
}*/

List<String> items = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];

Map<String, int> days = {
  'Sunday': 0,
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
};

Map<int, String> int_to_days = {
  0: 'Sunday',
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
};
List<Cell_info> morning_cells = [
  Cell_info(
      id: 'sun',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/v.jpg'),
  Cell_info(
      id: 'mon',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'tue',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'wed',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'thu',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'fri',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'sat',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
];

List<Cell_info> evening_cells = [
  Cell_info(
      id: 'sun',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/late.png'),
  Cell_info(
      id: 'mon',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'tue',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'wed',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'thu',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'fri',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
  Cell_info(
      id: 'sat',
      dosetime: '',
      is_filled: false,
      open_next: false,
      imageURL: 'assets/images/pill.jpg'),
];
String next_dose_time = '';

// next_pill_time=

String getDay(int day) {
  if (day == 0) return 'Sunday';
  if (day == 1) return 'Monday';
  if (day == 2) return 'Tuesday';
  if (day == 3) return 'Wednesday';
  if (day == 4) return 'Thursday';
  if (day == 5) return 'Friday';
  if (day == 6) return 'Saturday';
  return 'Sunday';
}
