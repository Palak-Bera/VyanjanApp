import 'package:flutter/material.dart';

class NotificationBanner extends StatefulWidget {
  @override
  _NotificationBannerState createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('Order Received'),
            Row(
              children: [
                IconButton(
                    color: Colors.green,
                    onPressed: () {},
                    icon: Icon(Icons.check)),
                IconButton(
                    color: Colors.redAccent,
                    onPressed: () {},
                    icon: Icon(Icons.cancel_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }
}
