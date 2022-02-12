import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodSeeker/Home/makerMenu.dart';
import 'package:food_app/features/FoodSeeker/Home/searchBar.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/itemCard.dart';
import 'package:food_app/fixtures/dummy_data.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

///  [Available Food maker] rendred when he/she searches particular food
class AvailableFoodMaker extends StatefulWidget {
  const AvailableFoodMaker({Key? key}) : super(key: key);

  @override
  _AvailableFoodMakerState createState() => _AvailableFoodMakerState();
}

class _AvailableFoodMakerState extends State<AvailableFoodMaker> {
  /// value which returned from [Search for food]
  //String value = "Sandwich";

  late QuerySnapshot querySnapshot;
  bool isExecuted = false;
  TextEditingController _searchController = TextEditingController();

  Widget searchedData() {
    return ListView.builder(
      itemCount: querySnapshot.docs.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MakerMenu(
                  makerName: querySnapshot.docs[index]['name'],
                  makerAddress: querySnapshot.docs[index]['address'],
                  makerPhoneNo: querySnapshot.docs[index]['phoneNo'],
                ),
              ),
            );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //     builder: (context) => MakerMenu(
            //   makerName:
            //   availableMaker[index].get('name'),
            //   makerAddress: availableMaker[index]
            //       .get('address'),
            //   makerPhoneNo: availableMaker[index]
            //       .get('phoneNo'),
            // )
            // )
          },
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                                text: querySnapshot.docs[index]['name'],
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: querySnapshot.docs[index]['status']
                                        ? primaryGreen
                                        : grey,
                                    size: 12,
                                  ),
                                  CustomText(
                                    text: querySnapshot.docs[index]['status']
                                        ? 'Available'
                                        : 'Not Available',
                                    color: querySnapshot.docs[index]['status']
                                        ? primaryGreen
                                        : grey,
                                    fontSize: 14,
                                  ),
                                ],
                              )
                              // : Row(
                              //     children: [
                              //       Icon(
                              //         Icons.circle,
                              //         color: grey,
                              //         size: 10,
                              //       ),
                              //       CustomText(
                              //         text: " Not Available",
                              //         color: grey,
                              //         fontSize: 12,
                              //       ),
                              //     ],
                              //   )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        toolbarHeight: 80.0,
        actions: [
          GetBuilder<SearchBar>(
            init: SearchBar(),
            builder: (val) {
              return Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: IconButton(
                    color: primaryGreen,
                    iconSize: 30.0,
                    onPressed: () {
                      val.queryData(_searchController.value.text).then((value) {
                        querySnapshot = value;
                        setState(() {
                          isExecuted = true;
                        });
                      });
                    },
                    icon: Icon(Icons.search)),
              );
            },
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: TextFormField(
            controller: _searchController,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {},
            onFieldSubmitted: (value) {
              SearchBar().queryData(_searchController.value.text).then((value) {
                querySnapshot = value;
                setState(() {
                  isExecuted = true;
                });
              });
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    isExecuted = false;
                  });
                },
                color: grey,
              ),
              prefixIcon: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                color: primaryGreen,
                onPressed: () {},
              ),
              hintText: 'Food Maker Name or dish',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: grey),
              ),
            ),
            keyboardType: TextInputType.text,
            cursorColor: primaryGreen,
          ),
        ),
      ),
      backgroundColor: white,
      body: isExecuted
          ? searchedData()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('dskj'),
              ),
            ),
    );
  }

  // Widget _buildFoodMakerCard(BuildContext context, int index) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 15),
  //     child: Card(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         child: Column(
  //           children: [
  //             ClipRect(
  //               child: Image(
  //                 image: AssetImage(makerList[index]["imgpath"]),
  //               ),
  //             ),
  //             Container(
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 13),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         CustomText(
  //                           text: makerList[index]["name"],
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 16,
  //                         ),
  //                         makerList[index]["status"]
  //                             ? Row(
  //                                 children: [
  //                                   Icon(
  //                                     Icons.circle,
  //                                     color: primaryGreen,
  //                                     size: 12,
  //                                   ),
  //                                   CustomText(
  //                                     text: " Available",
  //                                     color: primaryGreen,
  //                                     fontSize: 14,
  //                                   ),
  //                                 ],
  //                               )
  //                             : Row(
  //                                 children: [
  //                                   Icon(
  //                                     Icons.circle,
  //                                     color: grey,
  //                                     size: 10,
  //                                   ),
  //                                   CustomText(
  //                                     text: " Not Available",
  //                                     color: grey,
  //                                     fontSize: 12,
  //                                   ),
  //                                 ],
  //                               )
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         CustomText(
  //                           text: makerList[index]["rating"].toString(),
  //                           color: primaryGreen,
  //                           fontSize: 15,
  //                         ),
  //                         Icon(
  //                           Icons.star,
  //                           color: primaryGreen,
  //                           size: 18,
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ],
  //         )),
  //   );
  // }
}
//
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// /// [Search option for Food items]
// TextFormField(
//   onChanged: (value) {},
//   decoration: InputDecoration(
//     suffixIcon: IconButton(
//       icon: Icon(Icons.clear),
//       onPressed: () {},
//       color: grey,
//     ),
//     prefixIcon: IconButton(
//       icon: Icon(Icons.arrow_back_ios_outlined),
//       color: primaryGreen,
//       onPressed: () {},
//     ),
//     hintText: 'Food Maker Name or dish',
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10.0),
//       borderSide: BorderSide(color: grey),
//     ),
//   ),
//   keyboardType: TextInputType.text,
//   cursorColor: primaryGreen,
// ),
// height20,
//
// /// text for food maker delivering
// CustomText(
// text: "All the food maker delivering $value",
// fontSize: 16,
// softwrap: true,
// color: primaryBlack,
// ),
//
// Expanded(
// child: GestureDetector(
// onTap: () {
// Navigator.pushNamed(context, makerMenuRoute);
// },
// child: ListView.builder(
// itemBuilder: _buildFoodMakerCard,
// itemCount: makerList.length,
// shrinkWrap: true,
// scrollDirection: Axis.vertical,
// // physics: ClampingScrollPhysics(),
// ),
// ),
// )
// ],
// ),
