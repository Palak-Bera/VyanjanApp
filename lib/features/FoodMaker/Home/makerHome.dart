import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Home/makerRecipe.dart';
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
    super.initState();
  }

  void listenFCM() async {
    print('listen');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = AndroidNotificationChannel(
          'high_importance_channel', 'High Importance Notifications',
          importance: Importance.high, enableVibration: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
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
          title: Center(child: Text('Maker Home')),
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
