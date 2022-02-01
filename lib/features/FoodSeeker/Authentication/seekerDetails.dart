import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:location/location.dart';
import 'package:food_app/features/CommonScreens/googleMapScreen.dart' as map;

/// Screen for [Food seeker] Necessary details

class SeekerDetails extends StatefulWidget {
  const SeekerDetails({Key? key}) : super(key: key);

  @override
  _SeekerDetailsState createState() => _SeekerDetailsState();
}

class _SeekerDetailsState extends State<SeekerDetails> {
  String seekerFinalAddress = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppbar(
        onBackPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: 'Please enter your necessary details'),

                /// [Input fields for name]
                TextFormField(
                  controller: _firstNameController,
                  validator: (value) {
                    if (value!.isEmpty || value == null)
                      return 'Please Enter your First Name';
                    else
                      return null;
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'First name *',
                  ),
                  cursorColor: primaryGreen,
                ),
                height10,
                TextFormField(
                  controller: _lastNameController,
                  validator: (value) {
                    if (value!.isEmpty || value == null)
                      return 'Please Enter your Last Name';
                    else
                      return null;
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Last name *',
                  ),
                  cursorColor: primaryGreen,
                ),
                height30,

                /// [Email text field]
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty || value == null)
                      return 'Please Enter your email';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Email',
                      suffix: InkWell(
                        onTap: () {},
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                              color: primaryGreen, fontWeight: FontWeight.bold),
                        ),
                      )),
                  cursorColor: primaryGreen,
                ),
                height40,

                /// [Map location section]
                /// To intigrate Google maps for fetching location,
                /// You need to purchase API key from GCP
                /// Or You can also use any other Geolocation APIs available
                ListTile(
                  onTap: () {
                    getLocation();
                  },
                  leading: Icon(
                    Icons.location_searching,
                    color: primaryGreen,
                  ),
                  title: Text(
                    'Use current location',
                    style: TextStyle(
                      color: primaryGreen,
                    ),
                  ),
                  subtitle: Text(seekerFinalAddress == ''
                      ? 'Address'
                      : seekerFinalAddress),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: primaryGreen,
                  ),
                ),
                height20,
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomButton(
                    text: 'Continue',
                    onpressed: () {
                      if (_formKey.currentState!.validate()) {
                        var seekerCity = seekerFinalAddress.split(',');
                        seekerRef.doc(auth.currentUser!.phoneNumber).set({
                          'firstName': _firstNameController.value.text,
                          'lastName': _lastNameController.value.text,
                          'phoneNo': auth.currentUser!.phoneNumber,
                          'email': _emailController.value.text,
                          'address': seekerFinalAddress,
                          'city': seekerCity[seekerCity.length - 3]
                        }).then((value) => {
                              preferences.setString('UserState', 'Seeker'),
                              Navigator.pushNamedAndRemoveUntil(
                                  context, seekerHomeRoute, (route) => false)
                            });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => map.GoogleMapScreen(
          lat: _locationData.latitude!,
          long: _locationData.longitude!,
          callback: (value) {
            seekerFinalAddress = value;
            setState(() {});
          },
        ),
      ),
    );
  }
}
