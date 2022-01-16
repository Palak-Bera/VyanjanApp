import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Screen for [Restaurant contact] details (Mobile numbers)
class RestaurantContact extends StatefulWidget {
  const RestaurantContact({Key? key}) : super(key: key);

  @override
  _RestaurantContactState createState() => _RestaurantContactState();
}

class _RestaurantContactState extends State<RestaurantContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppbar(
        onBackPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Contact number of restaurant',
              color: primaryBlack,
              fontSize: 20.0,
            ),
            CustomText(
              text: 'Your customers will call on this number for general enquiries',
              color: grey,
            ),
            height30,
            CustomText(
              text: 'Main contact number',
              color: grey,
            ),
            height10,
            InternationalPhoneNumberInput(
              onInputChanged: (value) {},
              inputBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              keyboardType: TextInputType.phone,
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
                showFlags: true,
                setSelectorButtonAsPrefixIcon: false,
              ),
            ),
            height30,
            CustomText(
              text: 'Alternative contact number',
              color: grey,
            ),
            height10,
            InternationalPhoneNumberInput(
              onInputChanged: (value) {},
              inputBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              keyboardType: TextInputType.phone,
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
                showFlags: true,
                setSelectorButtonAsPrefixIcon: false,
              ),
            ),

            /// [Continue Button]
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(text: 'Continue', onpressed: () {}),
                  ),
                  height20
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
