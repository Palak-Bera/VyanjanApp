import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerBankDetails.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:location/location.dart';
import 'package:food_app/features/CommonScreens/googleMapScreen.dart' as map;
import 'package:libphonenumber/libphonenumber.dart' as libPhone;
import 'package:http/http.dart' as http;

/// Screen for taking [Restaurant details]

class MakerDetails extends StatefulWidget {
  @override
  _MakerDetailsState createState() => _MakerDetailsState();

  final PhoneNumber number;
  MakerDetails({required this.number});
}

class _MakerDetailsState extends State<MakerDetails> {
  String makerFinalAddress = '';
  String makerCity = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  String _alternatePhoneNo = '';
  bool? isValid;
  late PhoneNumber number;
  @override
  void initState() {
    super.initState();

    print(widget.number.dialCode);
    print(widget.number.isoCode);
    setState(() {
      number = PhoneNumber(
          dialCode: widget.number.dialCode, isoCode: widget.number.isoCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backwardsCompatibility: true,
        elevation: 0.0,
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
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
                  validator: (value) {
                    if (value!.isEmpty || value == null)
                      return 'Please Enter your Name';
                    else
                      return null;
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Food Maker name *',
                  ),
                  cursorColor: primaryGreen,
                ),
                height20,

                CustomText(
                  text: 'Alternative contact number',
                ),
                height10,
                InternationalPhoneNumberInput(
                  textFieldController: _phoneNoController,
                  initialValue: number,
                  validator: (value) {
                    if (_phoneNoController.value.text.isEmpty) {
                      return null;
                    } else {
                      if (!isValid!) {
                        return 'Invalid Phone Number';
                      } else {
                        return null;
                      }
                    }
                  },
                  maxLength: 15,
                  ignoreBlank: true,
                  onInputChanged: (value) {
                    number = value;
                    _alternatePhoneNo = value.toString();
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
                  validator: (value) {
                    if (makerFinalAddress == '' &&
                        (value!.isEmpty || value == null))
                      return 'Please Enter your Building Name';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Floor/Building',
                  ),
                  cursorColor: primaryGreen,
                ),
                TextFormField(
                  controller: _landmarkController,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (makerFinalAddress == '' &&
                        (value!.isEmpty || value == null))
                      return 'Please Enter Landmark';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Landmark',
                  ),
                  cursorColor: primaryGreen,
                ),
                TextFormField(
                  controller: _cityController,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (makerFinalAddress == '' &&
                        (value!.isEmpty || value == null))
                      return 'Please Enter your City';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'City',
                  ),
                  cursorColor: primaryGreen,
                ),
                TextFormField(
                  controller: _stateController,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (makerFinalAddress == '' &&
                        (value!.isEmpty || value == null))
                      return 'Please Enter your State';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'State',
                  ),
                  cursorColor: primaryGreen,
                ),
                TextFormField(
                  controller: _pincodeController,
                  maxLength: 6,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (makerFinalAddress == '' &&
                        (value!.isEmpty || value == null))
                      return 'Please Enter your Pincode';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Pincode',
                  ),
                  keyboardType: TextInputType.number,
                  cursorColor: primaryGreen,
                ),
                height20,

                /// [Map location section]
                /// To intigrate Google maps for fetching location,
                /// You need to purchase API key from GCP
                /// Or You can also use any other Geolocation APIs available

                /// [Option to choose current location directly]
                /// For this you need to first enable the permissions on mobile for accessing location of device

                Row(
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: primaryGreen),
                    ),
                    Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                height20,

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
                  subtitle: Text(
                      makerFinalAddress == '' ? 'Address' : makerFinalAddress),
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
                      onpressed: () async {
                        if (_phoneNoController.value.text.isNotEmpty) {
                          isValid =
                              await libPhone.PhoneNumberUtil.isValidPhoneNumber(
                                  phoneNumber: _alternatePhoneNo,
                                  isoCode: number.isoCode!);
                        }

                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> _makerDetailsMap = {
                            'name': _nameController.value.text,
                            'phoneNo': auth.currentUser!.phoneNumber,
                            'alternatePhoneNo': _phoneNoController.value.text,
                            'address': makerFinalAddress == ''
                                ? _buildingController.value.text +
                                    ' ' +
                                    _landmarkController.value.text +
                                    ' ' +
                                    _cityController.value.text +
                                    ' ' +
                                    _stateController.value.text +
                                    ' ' +
                                    _pincodeController.value.text
                                : makerFinalAddress,
                            'city': makerFinalAddress == ''
                                ? _cityController.value.text
                                : makerCity,
                            'status': true
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MakerBankDetails(
                                makerDetailsMap: _makerDetailsMap,
                              ),
                            ),
                          );
                        }
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
          lat: _locationData.latitude!,
          long: _locationData.longitude!,
          callback: (value) {
            makerCity = value.first.locality;
            makerFinalAddress = value.first.addressLine!;
            setState(() {});
          },
        ),
      ),
    );
  }
}
