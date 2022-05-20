import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_geocoder/geocoder.dart';

import 'package:food_app/fixtures/dummy_data.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

import 'package:location/location.dart';

import 'makerMenu.dart';

/// [Search Food Page] for [Food seeker] rendered when he/she is authenticated successfully
class SeekerHome extends StatefulWidget {
  const SeekerHome({Key? key}) : super(key: key);

  @override
  _SeekerHomeState createState() => _SeekerHomeState();
}

var cart = FlutterCart();

class _SeekerHomeState extends State<SeekerHome> {
  String _city = '';
  String _country = '';
  String _name = '';

  bool flag = true;

  List makerList = [];
  List<QueryDocumentSnapshot> availableMaker = [];
  late QuerySnapshot querySnapshot;
  bool isExecuted = false;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
    getName();
  }

  void getName() async {
    await seekerRef
        .doc(auth.currentUser!.phoneNumber)
        .snapshots()
        .forEach((element) {
      isSeekerLoggedIn = element.exists;
      setState(() {
        _name = element.get('firstName') + ' ' + element.get('lastName');
      });
    });
  }

  getLocalFoodMakers() async {
    await makerRef.get().then((documents) => {
          if (documents != null)
            {
              documents.docs.forEach(
                (element) {
                  if (_city == element.get('city')) {
                    if (element.get('status')) {
                      setState(() {
                        availableMaker.add(element);
                        makerList.add(element.get('name'));
                        _loading = false;
                      });
                    }
                  }
                },
              ),
            }
        });
  }

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    while (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          flag = false;
        });
      } else {
        setState(() {
          flag = true;
        });
      }
    } else {
      setState(() {
        flag = true;
      });
    }

    if (_permissionGranted == PermissionStatus.grantedLimited ||
        _permissionGranted == PermissionStatus.granted) {
      _locationData = await location.getLocation();
      final coordinates =
          new Coordinates(_locationData.latitude, _locationData.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      setState(() {
        print(address.first.toMap());
        var arr = address.first.addressLine!.split(',');
        _city = address.first.locality!;
        _country = arr[arr.length - 1];
        print(arr);
      });
      getLocalFoodMakers();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (makerList.isEmpty)
      setState(() {
        _loading = false;
      });
    return Scaffold(
      backgroundColor: white,
      body: !flag
          ? AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.location_on),
                  Text(
                    'Location Permission is off',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                  'Getting location permission will ensure hassle free delivery.'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: primaryGreen),
                  onPressed: () {
                    getLocation();
                  },
                  child: Text('Grant Permission'),
                )
              ],
            )
          : Stack(
              children: [
                SafeArea(
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
                                title: Text(_city),
                                subtitle: Text(
                                  _country,
                                  style: TextStyle(color: primaryGreen),
                                ),
                              ),
                            ),

                            /// [Username]

                            isSeekerLoggedIn
                                ? Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(_name),
                                            Text(
                                              'Food Seeker',
                                              style: TextStyle(
                                                  color: primaryGreen),
                                            ),
                                          ],
                                        ),
                                        width10,
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, seekerDashboardRoute);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: primaryGreen,
                                            child: Image.asset(
                                                'assets/food_icons/' +
                                                    (Random().nextInt(10) + 1)
                                                        .toString() +
                                                    '.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: primaryGreen,
                                    child: Image.asset('assets/food_icons/' +
                                        (Random().nextInt(10) + 1).toString() +
                                        '.png'),
                                  )
                          ],
                        ),

                        /// [Search option for Food items]
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                    context, availableFoodMakerRoute)
                                .then((value) {
                              setState(() {});
                            });
                          },
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: grey),
                          ),
                          leading: Icon(Icons.search, color: primaryGreen),
                          title: Text(
                            'Search food',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        height20,

                        /// Tag list for various [Filters]
                        // Container(
                        //   height: 30.0,
                        //   child: ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     children: [
                        //       Tag(
                        //         text: 'New Arrival',
                        //         onTap: () {},
                        //       ),
                        //       Tag(
                        //         text: 'Offers',
                        //         onTap: () {},
                        //       ),
                        //       Tag(
                        //         text: 'Fast Delivery',
                        //         onTap: () {},
                        //       ),
                        //       Tag(
                        //         text: 'More',
                        //         onTap: () {},
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // height20,

                        /// Food-Category Grid rendered [by Default]
                        Expanded(
                          child: makerList.isEmpty
                              ? Center(
                                  child: Text('No Food Makers Available'),
                                )
                              : GridView.builder(
                                  itemCount: makerList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 0.8),
                                  itemBuilder: (ctx, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print(availableMaker[index]
                                            .get('phoneNo'));

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MakerMenu(
                                              makerName: availableMaker[index]
                                                  .get('name'),
                                              makerAddress:
                                                  availableMaker[index]
                                                      .get('address'),
                                              makerPhoneNo:
                                                  availableMaker[index]
                                                      .get('phoneNo'),
                                            ),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              minRadius: 40.0,
                                              backgroundImage: AssetImage(
                                                categoryList.elementAt(
                                                    index)['imgpath']!,
                                              ),
                                            ),
                                            height10,
                                            CustomText(
                                              text: makerList.elementAt(index),
                                            ),
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
                              size: 35.0,
                              color: white,
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
    );
  }
}
