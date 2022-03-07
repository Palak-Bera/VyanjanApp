import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
    var dbRef =
        makerRealtimeRef.child(auth.currentUser!.phoneNumber.toString());
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppbar(
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Uppar content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Eat It more Content
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Eat It More",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              text: "Pizza, Fast Food",
                              fontSize: 15,
                            ),
                            CustomText(
                              text: "Address of the restaurant will go here",
                              fontSize: 12,
                              color: grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height20,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Veg.Cheese Sandwich",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Rs. 110",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Medium",
                        fontSize: 15,
                        color: grey,
                      ),
                      Divider(color: grey,),
                      CustomText(
                        text: "Veg.Cheese Sandwich",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Rs. 110",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Medium",
                        fontSize: 15,
                        color: grey,
                      ),
                    ],
                  ),
                  height30,
                  /// [Completed Orders title]
                  Row(
                    children: [
                      CustomText(
                        text: "Completed Orders",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      // Icon(Icons.de)
                    ],
                  ),
                  Divider(
                    color: grey,
                  ),
               /// [Completed orders]
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Veg.Cheese Sandwich",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Rs. 110",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Medium",
                        fontSize: 15,
                        color: grey,
                      ),
                      Divider(
                        color: grey,
                      ),
                      CustomText(
                        text: "Veg.Cheese Sandwich",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Rs. 110",
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "Medium",
                        fontSize: 15,
                        color: grey,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 13,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            text: "Proceed for Further",
            onpressed: () {},
          ),
        ),
      ),
    );
  }
}
