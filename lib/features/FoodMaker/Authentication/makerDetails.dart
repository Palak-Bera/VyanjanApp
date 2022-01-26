import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:location/location.dart';
import 'package:food_app/features/CommonScreens/googleMapScreen.dart' as map;

/// Screen for taking [Restaurant details]
class MakerDetails extends StatefulWidget {
  const MakerDetails({Key? key}) : super(key: key);

  @override
  _MakerDetailsState createState() => _MakerDetailsState();
}

class _MakerDetailsState extends State<MakerDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  String alternatePhoneNo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppbar(
        onBackPressed: () {},
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Food Maker Details',
                  color: primaryBlack,
                  fontSize: 20.0,
                ),
                CustomText(
                  text: 'Name, address and location',
                  color: grey,
                ),

                /// [Name input field]
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Food Maker name *',
                  ),
                  cursorColor: primaryGreen,
                ),
                height20,

                CustomText(
                  text: 'Alternative contact number *',
                ),
                height10,
                InternationalPhoneNumberInput(
                  textFieldController: _phoneNoController,
                  maxLength: 12,
                  ignoreBlank: true,
                  onInputChanged: (value) {
                    alternatePhoneNo = value.toString();
                  },
                  inputBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  keyboardType: TextInputType.phone,
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                    showFlags: true,
                    leadingPadding: 15.0,
                    setSelectorButtonAsPrefixIcon: true,
                  ),
                ),
                height20,

                CustomText(
                  text: 'Complete Address *',
                ),
                height10,

                /// [Address section]
                TextFormField(
                  controller: _buildingController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Floor/Building',
                  ),
                  cursorColor: primaryGreen,
                ),
                TextFormField(
                  controller: _landmarkController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Landmark',
                  ),
                  cursorColor: primaryGreen,
                ),
                TextFormField(
                  controller: _pincodeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Pincode',
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: primaryGreen,
                ),
                height40,

                /// [Map location section]
                /// To intigrate Google maps for fetching location,
                /// You need to purchase API key from GCP
                /// Or You can also use any other Geolocation APIs available
                CustomText(
                  text: 'Select a location *',
                ),
                height10,
                TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: primaryGreen,
                    ),
                    hintText: 'Select location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: primaryGreen,
                ),
                height10,

                /// [Option to choose current location directly]
                /// For this you need to first enable the permissions on mobile for accessing location of device
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
                  subtitle: Text('Restaurant name, Address'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: primaryGreen,
                  ),
                ),
                height20,

                /// [Continue button]
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomButton(
                      text: 'Continue',
                      onpressed: () {
                        makerRef.doc(auth.currentUser!.phoneNumber).update({
                          'name': _nameController.value.text,
                          'alternatePhoneNo': alternatePhoneNo,
                          'floor/building': _buildingController.value.text,
                          'landmark': _landmarkController.value.text,
                          'pincode': _pincodeController.value.text,
                        }).then((value) => {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, makerDetailRoute, (route) => false)
                            });
                      }),
                ),
                height20,
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
              _locationData.latitude!, _locationData.longitude!),
        ));
  }
}
