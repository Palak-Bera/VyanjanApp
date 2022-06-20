import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/itemCard.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:location/location.dart';
import 'package:food_app/features/CommonScreens/googleMapScreen.dart' as map;

/// Page for [user details]
class SeekerDashboard extends StatefulWidget {
  const SeekerDashboard({Key? key}) : super(key: key);

  @override
  _SeekerDashboardState createState() => _SeekerDashboardState();
}

class _SeekerDashboardState extends State<SeekerDashboard> {
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String _firstName = '';
  String _lastName = '';
  String _city = '';
  String _address = '';
  String _phoneNo = '';
  String _email = '';
  String _country = '';

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    await seekerRef
        .doc(auth.currentUser!.phoneNumber)
        .snapshots()
        .forEach((element) {
      setState(() {
        _firstName = element.get('firstName');
        _lastName = element.get('lastName');
        _address = element.get('address');
        _city = element.get('city');
        _phoneNo = element.get('phoneNo');
        _email = element.get('email');
        _addressController.text = _address;
        _phoneNoController.text = _phoneNo;
        _emailController.text = _email;
        _country = _address.split(',').last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backwardsCompatibility: true,
          iconTheme: IconThemeData(color: primaryGreen),
          elevation: 0.0,
          backgroundColor: white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: _firstName + ' ' + _lastName,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: _phoneNo,
                          fontSize: 15,
                        ),
                        CustomText(
                          text: "Food Seeker",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryGreen,
                        ),
                        CustomText(text: "Your Address Details", fontSize: 15),
                      ],
                    ),
                  ],
                ),

                // Location and chnage
                height10,
                ListTile(
                  leading: Icon(
                    Icons.location_on_sharp,
                    color: primaryGreen,
                    size: 35,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  title: CustomText(
                    text: _city,
                    fontSize: 18,
                  ),
                  subtitle: CustomText(
                    text: _country,
                    color: primaryGreen,
                    fontSize: 15,
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      Location _location = new Location();
                      var _locationData = await _location.getLocation();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => map.GoogleMapScreen(
                            lat: _locationData.latitude!,
                            long: _locationData.longitude!,
                            callback: (value) {
                              setState(() {
                                _addressController.text =
                                    value.first.addressLine!;
                                _city = value.first.locality;
                                _country =
                                    _addressController.text.split(',').last;
                                print('CITY: ' + _city);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: CustomText(
                      text: "CHANGE",
                      color: primaryGreen,
                      fontSize: 16,
                    ),
                  ),
                  horizontalTitleGap: 0,
                ),

                height10,
                // Complete address
                CustomText(
                  text: "Delivery Address*",
                  fontSize: 15,
                ),
                TextField(
                  controller: _addressController,
                  cursorColor: primaryGreen,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryGreen),
                    ),
                    focusColor: primaryGreen,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                  ),
                ),
                height20,

                // email address
                TextFormField(
                  controller: _emailController,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    label: Text('Email Address'),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryGreen),
                    ),
                  ),
                  cursorColor: primaryGreen,
                  keyboardType: TextInputType.emailAddress,
                ),
                height20,

                ElevatedButton(
                  onPressed: () {
                    auth.signOut().then((value) => {
                          print(auth.currentUser.toString()),
                          isSeekerLoggedIn = false,
                          preferences.setString('UserState', ''),
                          cart.deleteAllCart(),
                          Navigator.pushNamedAndRemoveUntil(
                              context, roleSelectorRoute, (route) => false)
                        });
                  },
                  child: Text('Logout'),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomButton(
              text: "Save Changes",
              onpressed: () {
                seekerRef.doc(auth.currentUser!.phoneNumber).update({
                  'address': _addressController.value.text,
                  'city': _city,
                  'email': _emailController.value.text
                }).then((value) => {
                      Fluttertoast.showToast(msg: 'Changes Saved'),
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
