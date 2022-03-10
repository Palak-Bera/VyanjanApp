import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/dividers.dart';

import '../../../routes/constants.dart';
import '../../FoodSeeker/Home/seekerHome.dart';

class NotificationBanner extends StatefulWidget {
  final Map orderDetails;
  NotificationBanner({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  _NotificationBannerState createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> {
  late String seekerName;
  @override
  void initState() {
    super.initState();
    getSeekerName();
  }

  void getSeekerName() async {
    await seekerRef
        .doc(widget.orderDetails['seekerPhoneNo'])
        .get()
        .then((value) {
      seekerName = value.get('firstName') + value.get('lastName');
    });
  }

  @override
  Widget build(BuildContext context) {
    var orders = jsonDecode(widget.orderDetails['seekerCart'].toString());

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Order Received',
                style: TextStyle(fontSize: 30.0, color: primaryGreen),
              ),
              height20,
              Text(widget.orderDetails['seekerPhoneNo']),
              height20,
              Expanded(
                child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(orders[index]['product_name'].toString()),
                        trailing: Text(
                          orders[index]['quantity'].toString(),
                          style: TextStyle(color: primaryGreen, fontSize: 15),
                        ),
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///order reject button
                  ElevatedButton(
                    onPressed: () async {
                      await seekerRealtimeRef
                          .child(widget.orderDetails['seekerPhoneNo'])
                          .child(auth.currentUser!.phoneNumber.toString())
                          .update({
                        'orderStatus': false,
                      }).then((value) {
                        seekerRealtimeRef
                            .child(widget.orderDetails['seekerPhoneNo'])
                            .child(auth.currentUser!.phoneNumber.toString())
                            .child('orders')
                            .limitToLast(1)
                            .once()
                            .then((element) {
                          print(element.snapshot.children.last.key.toString());
                          seekerRealtimeRef
                              .child(widget.orderDetails['seekerPhoneNo'])
                              .child(auth.currentUser!.phoneNumber.toString())
                              .child('orders')
                              .child(
                                  element.snapshot.children.last.key.toString())
                              .remove();
                        });
                      });

                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.blue), // <-- Button color
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red; // <-- Splash color
                      }),
                    ),
                  ),
                  width20,

                  ///order accept button
                  ElevatedButton(
                    onPressed: () async {
                      String dt =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      await seekerRealtimeRef
                          .child(widget.orderDetails['seekerPhoneNo'])
                          .child(auth.currentUser!.phoneNumber.toString())
                          .update({
                        'orderStatus': true,
                      }).then((value) {
                        makerRealtimeRef
                            .child(auth.currentUser!.phoneNumber.toString())
                            .child(dt)
                            .update({
                          'id': dt,
                          'seekerName': seekerName,
                          'seekerPhoneNo': widget.orderDetails['seekerPhoneNo'],
                          'paymentStatus': false,
                        });
                      }).whenComplete(() {
                        print('when complete');
                        print(dt);
                        var temp = makerRealtimeRef.child(
                            auth.currentUser!.phoneNumber.toString() +
                                "/" +
                                dt +
                                "/seekerItems");
                        for (int i = 0; i < orders.length; i++) {
                          temp
                              .child(orders[i]['product_name'].toString())
                              .update({
                            'dishName': orders[i]['product_name'],
                            'quantity': orders[i]['quantity'],
                          });
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.check),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.blue), // <-- Button color
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green; // <-- Splash color
                      }),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
