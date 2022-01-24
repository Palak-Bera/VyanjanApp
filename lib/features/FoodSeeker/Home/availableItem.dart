import 'package:flutter/material.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/itemCard.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/varietyCard.dart';
import 'package:food_app/fixtures/dummy_data.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Screen for [Available items] details for particular restaurent
class AvailableItem extends StatefulWidget {
  const AvailableItem({Key? key}) : super(key: key);

  @override
  _AvailableItemState createState() => _AvailableItemState();
}

class _AvailableItemState extends State<AvailableItem> {
  bool addCounter = true;
  String selectsize = "medium";
  bool extracheese = false;
  int cartIteam = 1;
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
      body: Column(
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
                      text: "Eat it More",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      text: "Pizza, FastFood",
                      fontSize: 16,
                      color: grey,
                    ),
                    CustomText(
                      text: "Address of the restaurent",
                      fontSize: 16,
                      color: grey,
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryGreen),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        CustomText(
                          text: "4.5",
                          color: white,
                          fontSize: 18,
                        ),
                        Icon(
                          Icons.star,
                          color: white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
              height: 30.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Tag(
                    text: 'New Arrival',
                    onTap: () {},
                  ),
                  Tag(
                    text: 'Offers',
                    onTap: () {},
                  ),
                  Tag(
                    text: 'Fast Delivery',
                    onTap: () {},
                  ),
                  Tag(
                    text: 'More',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          height20,
          Container(
            width: double.infinity,
            height: 30.0,
            color: Colors.grey[200],
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                VarietyTag(text: "Pizza", onTap: () {}),
                VarietyTag(text: "Sandwich", onTap: () {}),
                VarietyTag(text: "Burger", onTap: () {}),
                VarietyTag(text: "Hot Dogs", onTap: () {}),
                VarietyTag(text: "Garlic Bread", onTap: () {})
              ],
            ),
          ),
          height20,

          /// [Search option for Food items]
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryGreen,
                  ),
                  hintText: 'Search within the menu',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: grey))),
              keyboardType: TextInputType.text,
              cursorColor: primaryGreen,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView.builder(
                itemBuilder: _buildAvailableItemCard,
                itemCount: makerList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                // physics: ClampingScrollPhysics(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvailableItemCard(BuildContext context, int index) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    /// [Bottom Modelsheet ] function
    void showsheet() {
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          isScrollControlled: true,
          builder: (context) {
            return Container(
              height: screenHeight / 1.25,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          makerList[index]["imgpath"],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Icon(
                                  Icons.close,
                                  color: grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    height20,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: makerList[index]["name"],
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          Divider(),
                          CustomText(
                            text: "Select Size",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: "Medium"),
                              Row(
                                children: [
                                  CustomText(text: "Rs. 110"),
                                  Radio(
                                    value: 'medium',
                                    groupValue: selectsize,
                                    onChanged: (val) {
                                      setState(() {
                                        selectsize = val.toString();
                                        print(selectsize);
                                      });
                                    },
                                    activeColor: primaryGreen,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: "Large"),
                              Row(
                                children: [
                                  CustomText(text: "Rs. 140"),
                                  Radio(
                                    value: 'large',
                                    groupValue: selectsize,
                                    onChanged: (val) {
                                      setState(() {
                                        selectsize = val.toString();
                                        print(selectsize);
                                      });
                                    },
                                    activeColor: primaryGreen,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          CustomText(
                            text: "Extra",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: "Cheese"),
                              Row(
                                children: [
                                  CustomText(text: "Rs. 45"),
                                  Checkbox(
                                    value: extracheese,
                                    checkColor: white,
                                    activeColor: primaryGreen,
                                    onChanged: (val) {
                                      extracheese == true
                                          ? extracheese = false
                                          : extracheese = true;
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  width: 1.0,
                                  color: primaryGreen,
                                  // style:
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        child: Icon(
                                          Icons.remove,
                                          color: primaryGreen,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            (cartIteam <= 1)
                                                ? cartIteam = 1
                                                : cartIteam--;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: "$cartIteam",
                                        color: primaryGreen,
                                        fontSize: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.add,
                                          color: primaryGreen,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            cartIteam++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth / 2,
                                child: CustomButton(
                                    text: "Add Item for Rs. 110",
                                    onpressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

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
                  padding: const EdgeInsets.only(left: 13, right: 13, top: 13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// [item name]
                      Text(
                        makerList[index]["name"],
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      /// [item category]
                      CustomText(
                        text: "In Sandwiches",
                        fontSize: 12,
                      ),

                      /// [item price]
                      CustomText(
                        text: "Rs. 100",
                        fontSize: 14,
                      ),

                      /// [ADD Button]
                      Container(
                        child: makerList[index]["add"]
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
                                  showsheet();
                                },
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: primaryGreen)),
                                child: Row(
                                  children: [
                                    Icon(Icons.remove),
                                    CustomText(
                                      text: "1",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: primaryGreen,
                                    ),
                                    Icon(Icons.add)
                                  ],
                                ),
                                onPressed: () {},
                              ),
                      )
                    ],
                  ),
                ),
              ),

              /// [item Image]

              Container(
                height: 150,
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage(makerList[index]["imgpath"]),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
