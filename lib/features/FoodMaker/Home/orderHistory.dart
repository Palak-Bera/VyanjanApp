import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Home/makerRecipe.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

/// [Order History page] for selected items by users
class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Uppar content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  height10,

                  /// [Your Orders title]
                  Row(
                    children: [
                      CustomText(
                        text: "Your Orders",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: primaryGreen,
                        size: 30,
                      )
                    ],
                  ),
                  Divider(
                    color: grey,
                  ),

                  /// [orders]
                  StreamBuilder(
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading");
                      } else {
                        return ListView(
                          shrinkWrap: true,
                          children:
                              snapshot.data!.snapshot.children.map((document) {
                            var temp = jsonEncode(document.value);
                            var order = jsonDecode(temp);

                            Map<String, dynamic> items = order['seekerItems'];

                            items.forEach((key, value) {
                              print(value);
                            });

                            // return ListTile(
                            //   title: CustomText(
                            //     text: order['seekerName'],
                            //   ),
                            //   subtitle: CustomText(
                            //     text: order['seekerPhoneNo'],
                            //     color: grey,
                            //   ),
                            // );

                            return ExpansionTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  order['paymentStatus']
                                      ? CustomText(
                                          text: 'Payment Completed',
                                          color: Colors.green,
                                          fontSize: 9.0,
                                        )
                                      : CustomText(
                                          text: 'Payment Pending',
                                          color: Colors.red,
                                          fontSize: 9.0,
                                        ),
                                  CustomText(
                                    text: order['seekerName'],
                                  ),
                                ],
                              ),
                              subtitle: CustomText(
                                text: order['seekerPhoneNo'],
                                color: grey,
                                fontSize: 12.0,
                              ),
                              children: items.values.map((value) {
                                return ListTile(
                                  title: Text(
                                    value['dishName'],
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                  subtitle: Text(
                                    'Quantity: ' + value['quantity'].toString(),
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        );
                      }
                    },
                    stream: makerRealtimeRef
                        .child(auth.currentUser!.phoneNumber.toString())
                        .orderByChild('id')
                        .onValue,
                  ),
                  height30,

                  // /// [Completed Orders title]
                  // Row(
                  //   children: [
                  //     CustomText(
                  //       text: "Completed Orders",
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //     // Icon(Icons.de)
                  //   ],
                  // ),
                  // Divider(
                  //   color: grey,
                  // ),
                  //
                  // /// [Completed orders]
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 13,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 2,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //     child: CustomButton(
      //       text: "Proceed for Further",
      //       onpressed: () {},
      //     ),
      //   ),
      // ),
    );
  }
}
