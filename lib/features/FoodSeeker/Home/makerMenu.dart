import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

//typedef MyCart = void Function(FlutterCart);

/// Screen for [Available items] details for particular restaurent
class MakerMenu extends StatefulWidget {
  final String makerName;
  final String makerAddress;
  final String makerPhoneNo;
  MakerMenu(
      {Key? key,
      required this.makerName,
      required this.makerAddress,
      required this.makerPhoneNo})
      : super(key: key);

  @override
  _MakerMenuState createState() => _MakerMenuState();
}

class _MakerMenuState extends State<MakerMenu> {
  // bool addCounter = true;
  // String selectsize = "medium";
  // bool extracheese = false;
  // int cartIteam = 1;

  List makerMenuList = [];
  int quantity = 0, index = -1;

  bool _loading = true;

  // late List<bool> flag;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < cart.cartItem.length; i++) {
      print(i);
      print(cart.cartItem[i].productName);
      print(cart.cartItem[i].quantity);
    }

    makerRef.doc(widget.makerPhoneNo).collection('menu').get().then((value) => {
          value.docs.forEach((element) {
            index = cart.cartItem
                .indexWhere((e) => e.productName == element.get('name'));
            print('index' + index.toString());
            setState(() {
              _loading = false;
              makerMenuList.add({
                'dishName': element.get('name'),
                'description': element.get('description'),
                'price': element.get('price'),
                'quantity': index == -1 ? 0 : cart.cartItem[index].quantity,
              });
            });
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backwardsCompatibility: true,
        iconTheme: IconThemeData(color: primaryGreen),
        elevation: 0.0,
        backgroundColor: white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.makerName,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "Pizza, FastFood",
                            fontSize: 16,
                            color: grey,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: CustomText(
                              text: widget.makerAddress,
                              softwrap: true,
                              fontSize: 16,
                              color: grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                height20,
                // Padding(
                //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                //   child: Container(
                //     height: 30.0,
                //     child: ListView(
                //       scrollDirection: Axis.horizontal,
                //       children: [
                //         Tag(
                //           text: 'New Arrival',
                //           onTap: () {},
                //         ),
                //         Tag(
                //           text: 'Offers',
                //           onTap: () {},
                //         ),
                //         Tag(
                //           text: 'Fast Delivery',
                //           onTap: () {},
                //         ),
                //         Tag(
                //           text: 'More',
                //           onTap: () {},
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // height20,
                // Container(
                //   width: double.infinity,
                //   height: 30.0,
                //   color: Colors.grey[200],
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: [
                //       VarietyTag(text: "Pizza", onTap: () {}),
                //       VarietyTag(text: "Sandwich", onTap: () {}),
                //       VarietyTag(text: "Burger", onTap: () {}),
                //       VarietyTag(text: "Hot Dogs", onTap: () {}),
                //       VarietyTag(text: "Garlic Bread", onTap: () {})
                //     ],
                //   ),
                // ),
                // height20,

                /// [Search option for Food items]
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, right: 20),
                //   child: TextFormField(
                //     onChanged: (value) {},
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(
                //         Icons.search,
                //         color: primaryGreen,
                //       ),
                //       hintText: 'Search within the menu',
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10.0),
                //         borderSide: BorderSide(color: grey),
                //       ),
                //     ),
                //     keyboardType: TextInputType.text,
                //     cursorColor: primaryGreen,
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ListView.builder(
                      itemBuilder: _buildAvailableItemCard,
                      itemCount: makerMenuList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // physics: ClampingScrollPhysics(),
                    ),
                  ),
                )
              ],
            ),
            cart.getTotalAmount() > 0
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: primaryGreen,
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, seekerCartRoute)
                              .then((value) {
                            setState(() {});
                          });
                        },
                        title: Text(
                          getItemCount().toString() + ' items',
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '₹ ' + cart.getTotalAmount().toString(),
                          style: TextStyle(color: white),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: white,
                          size: 35.0,
                        ),
                      ),
                    ),
                  )
                : Container(),
            _loading
                ? Positioned(
                    right: 1,
                    left: 1,
                    top: 1,
                    bottom: 1,
                    child: Align(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // Widget alertDialog(String cartMakerItems, String thisMaker) {
  //   return AlertDialog();
  // }

  Widget _buildAvailableItemCard(BuildContext context, int index) {
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
            /// [item name +  description]
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.77,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// [item name]
                    Text(
                      makerMenuList[index]['dishName'],
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),

                    /// [item category]
                    Container(
                      child: CustomText(
                        text: makerMenuList[index]['description'],
                        fontSize: 15,
                        color: grey,
                        softwrap: true,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// [item price]
                        CustomText(
                          text: '₹ ' + makerMenuList[index]['price'],
                          fontSize: 15,
                        ),

                        /// [ADD Button]
                        Container(
                          child: makerMenuList[index]['quantity'] == 0
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: primaryGreen)),
                                  child: CustomText(
                                    text: "ADD",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: primaryGreen,
                                  ),
                                  onPressed: () {
                                    //showsheet();
                                    if (cart.cartItem.isEmpty) {
                                      preferences.setString(
                                          'cartMakerItems', widget.makerName);
                                      cart.addToCart(
                                          productId: index,
                                          quantity: 1,
                                          productName: makerMenuList[index]
                                              ['dishName'],
                                          unitPrice: int.parse(
                                              makerMenuList[index]['price']));
                                      setState(() {
                                        makerMenuList[index]['quantity'] = 1;
                                      });
                                    } else {
                                      if (preferences
                                              .getString('cartMakerItems') !=
                                          widget.makerName) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  children: [
                                                    Icon(Icons.location_on),
                                                    Text(
                                                      'Replace cart items?',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                content: Text(
                                                    'Your cart contains dishes from ${preferences.getString('cartMakerItems')}. Do you want to discard the selection and add dishes from ${widget.makerName}'),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                primaryGreen),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        makerMenuList[index]
                                                            ['quantity'] = 0;
                                                      });
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                primaryGreen),
                                                    onPressed: () {
                                                      cart.cartItem.clear();

                                                      for (int i = 0;
                                                          i <
                                                              makerMenuList
                                                                  .length;
                                                          i++) {
                                                        setState(() {
                                                          preferences.setString(
                                                              'cartMakerItems',
                                                              widget.makerName);
                                                          makerMenuList[i]
                                                              ['quantity'] = 0;
                                                        });
                                                      }

                                                      cart.addToCart(
                                                          productId: index,
                                                          quantity: 1,
                                                          productName:
                                                              makerMenuList[
                                                                      index]
                                                                  ['dishName'],
                                                          unitPrice: int.parse(
                                                              makerMenuList[
                                                                      index]
                                                                  ['price']));

                                                      setState(() {
                                                        makerMenuList[index]
                                                            ['quantity'] = 1;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Yes'),
                                                  )
                                                ],
                                              );
                                            });
                                      } else {
                                        cart.addToCart(
                                            productId: index,
                                            quantity: 1,
                                            productName: makerMenuList[index]
                                                ['dishName'],
                                            unitPrice: int.parse(
                                                makerMenuList[index]['price']));
                                      }
                                      setState(() {
                                        makerMenuList[index]['quantity'] = 1;
                                      });
                                    }
                                  })
                              : Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: primaryGreen),
                                  ),
                                  child: CustomNumberPicker(
                                    initialValue: int.parse(makerMenuList[index]
                                            ['quantity']
                                        .toString()),
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
                                      cart.addToCart(
                                          productId: index,
                                          unitPrice: int.parse(
                                              makerMenuList[index]['price']),
                                          productName: makerMenuList[index]
                                              ['dishName'],
                                          quantity:
                                              int.parse(value.toString()));
                                      setState(() {
                                        makerMenuList[index]['quantity'] =
                                            value;
                                      });

                                      // print(cart.cartItem[index].productName
                                      //         .toString() +
                                      //     ' ' +
                                      //     cart.cartItem[index].quantity.toString());

                                      print(value.toString());
                                    },
                                  ),
                                ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            // /// [rupees + add button]
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Container(
            //     child: Column(
            //       children: [],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
