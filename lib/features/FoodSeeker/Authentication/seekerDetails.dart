import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Screen for [Food seeker] Necessary details
class SeekerDetails extends StatefulWidget {
  const SeekerDetails({Key? key}) : super(key: key);

  @override
  _SeekerDetailsState createState() => _SeekerDetailsState();
}

class _SeekerDetailsState extends State<SeekerDetails> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Please enter your necessary details'),

              /// [Input fields for name]
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'First name *',
                ),
                cursorColor: primaryGreen,
              ),
              height10,
              TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'Last name',
                ),
                cursorColor: primaryGreen,
              ),
              height30,

              /// [Mobile number field]
              InternationalPhoneNumberInput(
                onInputChanged: (value) {},
                inputBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                keyboardType: TextInputType.phone,
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                  showFlags: true,
                  setSelectorButtonAsPrefixIcon: false,
                ),
              ),
              height10,

              /// Clickable text => [Update]
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ClickText(onTap: () {}, text: 'UPDATE')],
              ),
              height10,

              /// [Email text field]
              TextFormField(
                onChanged: (value) {},
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
                        borderSide: BorderSide(color: grey))),
                keyboardType: TextInputType.number,
                cursorColor: primaryGreen,
              ),
              height10,
              ListTile(
                onTap: () {},
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                    text: 'Continue',
                    onpressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, searchFoodRoute, (route) => false);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
