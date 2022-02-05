import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

/// [user cart page] for selected items by users
class SeekerCart extends StatefulWidget {
  const SeekerCart({Key? key}) : super(key: key);

  @override
  _SeekerCartState createState() => _SeekerCartState();
}

class _SeekerCartState extends State<SeekerCart> {
  String choosePref = "";

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
                              fontWeight: FontWeight.w500,
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

                        // Offers
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: primaryGreen,
                            ),
                            SizedBox(width: 2),
                            CustomText(text: "Offers"),
                          ],
                        )
                      ],
                    ),
                  ),
                  height20,

                  // Your Cart
                  Row(
                    children: [
                      CustomText(
                        text: "Your Cart",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
                  ListView.builder(
                    itemBuilder: _buildCartItems,
                    itemCount: cart.cartItem.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                  ),

                  /// [Choose Preference]
                  Row(
                    children: [
                      CustomText(
                        text: "Choose your preference",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      // Icon(Icons.de)
                    ],
                  ),
                  Divider(
                    color: grey,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "Takeaway",
                                groupValue: choosePref,
                                onChanged: (value) {
                                  choosePref = value.toString();
                                  setState(() {});
                                },
                                activeColor: primaryGreen,
                              ),
                              CustomText(text: "Takeaway"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Doorstep Delivery",
                                groupValue: choosePref,
                                onChanged: (value) {
                                  choosePref = value.toString();
                                  setState(() {});
                                },
                                activeColor: primaryGreen,
                              ),
                              CustomText(text: "Doorstep Delivery"),
                            ],
                          ),
                        ],
                      ),
                      CustomText(
                        text: "Rs. 50",
                        fontSize: 16,
                      )
                    ],
                  ),
                ],
              ),
            ),

            /// [Grand Total]
            Container(
              color: Colors.green[50],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Item Total "),
                        CustomText(text: "Rs. 110")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Delivey Charge"),
                        CustomText(text: "Rs. 50")
                      ],
                    ),
                    Divider(
                      color: grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Grand Total",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "Rs. 160",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ],
                ),
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
            text: "Proceed for Payment",
            onpressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, int index) {
    return ListTile(
      title: Text(
        cart.cartItem[index].productName.toString(),
      ),
    );
  }
}
