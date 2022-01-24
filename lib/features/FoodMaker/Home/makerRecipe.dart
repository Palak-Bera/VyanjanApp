import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

/// Screen for [Recipe] details for food maker
class Recipe extends StatefulWidget {
  const Recipe({Key? key}) : super(key: key);


  @override
  _AvailableItemState createState() => _AvailableItemState();
}

class _AvailableItemState extends State<Recipe> {


 static const foodItems = [
    "item 1",
    "item 2",
    "item 3",
    "item 4 (Optional)",
    "item 5 (Optional)",
    "item 6 (Optional)"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppbar(
        onBackPressed: () {},
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
          height20,
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CustomText(
                text: "Food items",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          height20,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                      title: CustomText(
                        color: grey,
                    text: "${foodItems[index]}",
                  ));
                },
                itemCount: foodItems.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,

                // physics: ClampingScrollPhysics(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            text: "Add more food items",
            onpressed: () {},
          ),
        ),
      ),
    );
  }
}
