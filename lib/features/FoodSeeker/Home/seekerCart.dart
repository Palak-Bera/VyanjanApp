import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
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

  Future<bool> _onWillPop() async {
    Navigator.pushNamedAndRemoveUntil(
        context, seekerHomeRoute, (route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backwardsCompatibility: true,
          iconTheme: IconThemeData(color: primaryGreen),
          elevation: 0.0,
          backgroundColor: white,
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
                                text: preferences.getString('cartMakerItems'),
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
                    height20,

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
                          text: "₹ 50",
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
                          CustomText(text: getItemCount().toString())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "Delivery Charges"),
                          CustomText(text: "₹ 50")
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
                            text:
                                '₹ ' + (cart.getTotalAmount() + 50).toString(),
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
              text:
                  auth.currentUser != null ? "Continue" : "Sign In to Continue",
              onpressed: () {
                if (auth.currentUser != null) {
                  Navigator.pushNamed(context, seekerCheckoutRoute);
                } else {
                  Navigator.pushNamed(context, foodSeekerRegisterRoute);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black26, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// [item name]
                    Text(
                      cart.cartItem[index].productName.toString(),
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),

                    /// [item category]
                    CustomText(
                      text: cart.cartItem[index].subTotal.toString(),
                      fontSize: 15,
                      color: grey,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Container(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryGreen),
                    ),
                    child: CustomNumberPicker(
                      initialValue: cart.cartItem[index].quantity,
                      maxValue: 10,
                      minValue: 0,
                      step: 1,
                      shape: Border.all(color: white),
                      customAddButton: Icon(
                        Icons.add,
                        color: primaryGreen,
                      ),
                      customMinusButton: Icon(
                        Icons.remove,
                        color: primaryGreen,
                      ),
                      onValue: (value) {
                        setState(() {});
                        cart.addToCart(
                            productId: index,
                            unitPrice: cart.cartItem[index].unitPrice,
                            productName: cart.cartItem[index].productName,
                            quantity: int.parse(value.toString()));
                        if (cart.getTotalAmount() == 0) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, seekerHomeRoute, (route) => false);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
