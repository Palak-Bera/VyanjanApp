import 'package:flutter/material.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/itemCard.dart';
import 'package:food_app/fixtures/dummy_data.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

/// [Search Food Page] for [Food seeker] rendred when he/she is authenticated successfully
class SearchFood extends StatefulWidget {
  const SearchFood({Key? key}) : super(key: key);

  @override
  _SearchFoodState createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  /// [City and Country text]
                  Icon(
                    Icons.location_on,
                    color: primaryGreen,
                    size: 30,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Anand'),
                      subtitle: Text(
                        'India',
                        style: TextStyle(color: primaryGreen),
                      ),
                    ),
                  ),

                  /// [Username]
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Robert'),
                            Text(
                              'Food Seeker',
                              style: TextStyle(color: primaryGreen),
                            ),
                          ],
                        ),
                        width10,
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, userDetailRoute);
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/person.jpeg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// [Search option for Food items]
              TextFormField(
                onChanged: (value) {},
                onFieldSubmitted: (value) {
                  Navigator.pushNamed(context, availableFoodMakerRoute);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: primaryGreen,
                    ),
                    hintText: 'Search food',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: grey))),
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

              /// Food-Category Grid rendered [by Default]
              Expanded(
                child: GridView.builder(
                  itemCount: categoryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.8),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: [
                            CircleAvatar(
                              minRadius: 40.0,
                              backgroundImage: AssetImage(
                                categoryList.elementAt(index)['imgpath']!,
                              ),
                            ),
                            height10,
                            CustomText(
                                text: categoryList.elementAt(index)['name']!),
                            height10,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Below List widget should be rendered [when something is searched]
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: makerList.length,
              //     itemBuilder: (ctx, index) {
              //       return Container(
              //         margin: EdgeInsets.only(top: 10.0),
              //         width: screenWidth,
              //         decoration: BoxDecoration(
              //             // border: Border.all(width: 1.0, color: white),
              //             borderRadius: BorderRadius.circular(10.0),
              //             color: white,
              //             boxShadow: [BoxShadow(color: grey, blurRadius: 2.0)]),
              //         child: Column(
              //           children: [
              //             Image.asset(makerList.elementAt(index)['imgpath']!),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       CustomText(
              //                         text: makerList.elementAt(index)['name']!,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                       makerList.elementAt(index)['status']
              //                           ? CustomText(
              //                               text: 'Available',
              //                               color: primaryGreen,
              //                               fontSize: 12.0,
              //                             )
              //                           : CustomText(
              //                               text: 'Not available',
              //                               color: grey,
              //                               fontSize: 12.0,
              //                             ),
              //                     ],
              //                   ),
              //                   Row(
              //                     children: [
              //                       CustomText(
              //                         text: makerList.elementAt(index)['rating'].toString(),
              //                         fontWeight: FontWeight.bold,
              //                         color: primaryGreen,
              //                       ),
              //                       Icon(
              //                         Icons.star,
              //                         color: primaryGreen,
              //                         size: 15.0,
              //                       )
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
