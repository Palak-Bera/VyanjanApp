import 'package:flutter/material.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/itemCard.dart';
import 'package:food_app/fixtures/dummy_data.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

///  [Available Food maker] rendred when he/she searches particular food
class AvailableFoodMaker extends StatefulWidget {
  const AvailableFoodMaker({Key? key}) : super(key: key);

  @override
  _AvailableFoodMakerState createState() => _AvailableFoodMakerState();
}

class _AvailableFoodMakerState extends State<AvailableFoodMaker> {
  /// value which returned from [Search for food]
  String value = "Sandwich";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// [Search option for Food items]
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryGreen,
                  ),
                  hintText: 'Available Food Makers',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: grey),
                  ),
                ),
                keyboardType: TextInputType.text,
                cursorColor: primaryGreen,
              ),
              height20,

              /// Tag list for various [Filters]
              Container(
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
              height20,

              /// text for food maker delivering
              CustomText(
                text: "All the food maker delivering $value",
                fontSize: 16,
                softwrap: true,
                color: primaryBlack,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, availableItemRoute);
                  },
                  child: ListView.builder(
                    itemBuilder: _buildFoodMakerCard,
                    itemCount: makerList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    // physics: ClampingScrollPhysics(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodMakerCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              ClipRect(
                child: Image(
                  image: AssetImage(makerList[index]["imgpath"]),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: makerList[index]["name"],
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          makerList[index]["status"]
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: primaryGreen,
                                      size: 12,
                                    ),
                                    CustomText(
                                      text: " Available",
                                      color: primaryGreen,
                                      fontSize: 14,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: grey,
                                      size: 10,
                                    ),
                                    CustomText(
                                      text: " Not Available",
                                      color: grey,
                                      fontSize: 12,
                                    ),
                                  ],
                                )
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: makerList[index]["rating"].toString(),
                            color: primaryGreen,
                            fontSize: 15,
                          ),
                          Icon(
                            Icons.star,
                            color: primaryGreen,
                            size: 18,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
