import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot/login2.dart';
import 'package:iot/pages/choose_refillday.dart';
import 'package:iot/pages/choose_times.dart';
import 'package:iot/pages/patient_log.dart';
import 'package:iot/shared.dart';
import 'package:iot/pages/pill_box_page.dart';
import 'package:iot/pages/refill_box_page.dart';
import 'package:iot/pages/sign_up.dart';
import 'package:iot/pages/set_pill_time_page.dart';
import 'package:iot/theme/colors/light_colors.dart';
import 'package:iot/pages/tabs_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'pages/refill_box_page.dart';
import 'pages/search_box_page.dart';
import 'pages/log_page.dart';
import 'dart:convert';
import 'shared.dart';

Future<void> bk_handler(RemoteMessage msg) async {
  print('init worked');
  return;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  RemoteNotification notification = message.notification!;
  AndroidNotification android = notification.android!;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: android.smallIcon,
          ),
        ));
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  // This widget is the root of your application.
  String message = '';
  var token;
  late String first_screen;
  final _auth = FirebaseAuth.instance;
  String userEmail = '';

  @override
  void initState() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Beirut'));

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    _fcm.requestPermission();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      //AndroidNotification android = message.notification?.android;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //icon: android?.smallIcon,
              ),
            ));
      }
    });
    super.initState();
  }

  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/log_in',
      //initialRoute: '/log_in2',

      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('error');
            return Text('error');
          } else if (snapshot.hasData) {
            return LoginScreen();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      routes: {
        '/pages/tab_screen': (context) => TabsScreen(),
        '/log_in2': (context) => LoginScreen(),
        '/pages/pill_box_page': (context) => PillBox(),
        '/pages/signup': (context) => const SignUpPage(),
        '/pages/set_pill_time_page': (context) => SetPillTimePage(),
        '/pages/refill_box_page': (context) => RefillBoxPage(),
        '/pages/search_box_page': (context) => SearchBoxPage(),
        '/pages/log_page': (context) => LOGPage(),
        '/pages/info_page': (context) => InfoPage(),
        '/choose_refillday': (context) => ChooseRefillDay(),
        '/pages/choose_times': (context) => ChoosePillTimePage(),
      },
    );
  }
}
