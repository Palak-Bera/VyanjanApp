import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Home/makerRecipe.dart';
import 'package:food_app/features/FoodMaker/Home/notificationBanner.dart';
import 'package:food_app/features/FoodMaker/Home/orderHistory.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';

class MakerHome extends StatefulWidget {
  @override
  _MakerHomeState createState() => _MakerHomeState();
}

class _MakerHomeState extends State<MakerHome> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    loadFCM();
    listenFCM();
    setupInteractedMessage();
    super.initState();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    _handleMessage(initialMessage!);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message);
    String temp1 = message.notification!.body.toString();
    print(temp1);
    Map temp = jsonDecode(temp1);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationBanner(orderDetails: temp)));
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('notification received');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin
            .show(
          notification.hashCode,
          notification.title,
          'Click to accept or reject the order',
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
              importance: Importance.high,
              fullScreenIntent: true,
              enableVibration: true,
              playSound: true,
              priority: Priority.high,
            ),
          ),
        )
            .then((value) {
          String temp1 = notification.body.toString();
          Map temp = jsonDecode(temp1);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationBanner(
                orderDetails: temp,
              ),
            ),
          );
        });
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = AndroidNotificationChannel(
          'high_importance_channel', 'High Importance Notifications',
          importance: Importance.high, enableVibration: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: primaryGreen,
          backgroundColor: white,
          title: Text('Maker Home'),
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut();
                  preferences.setString('UserState', '');
                  Navigator.pushNamedAndRemoveUntil(
                      context, roleSelectorRoute, (route) => false);
                },
                icon: Icon(Icons.logout))
          ],
          bottom: TabBar(
            indicatorColor: primaryGreen,
            tabs: [
              Tab(
                child: Text(
                  'My Recipes',
                  style: TextStyle(
                    color: primaryBlack,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    color: primaryBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MakerRecipe(),
            OrderHistory(),
          ],
        ),
      ),
    );
  }
}
