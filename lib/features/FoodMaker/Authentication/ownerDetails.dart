import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Screen to take [details of Restaurant owner]
class OwnerDetails extends StatefulWidget {
  const OwnerDetails({Key? key}) : super(key: key);

  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
 int _radioSelected = 0;
  bool checkSelcted = false;
  bool _value = false;

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
              text: 'Restaurant Owner Details',
              color: primaryBlack,
              fontSize: 20.0,
            ),
            CustomText(
              text: 'These will be used to share revenue related communications',
              color: grey,
              softwrap: true,
            ),
            height20,
            /// [Owner name] text field
            TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'Restaurant owner full name *',
              ),
              cursorColor: primaryGreen,
            ),
            /// [Owner email] text field
            TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(
                  hintText: 'Email',
                  suffix: InkWell(
                    onTap: () {},
                    child: Text(
                      'VERIFY',
                      style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                    ),
                  )),
              cursorColor: primaryGreen,
            ),
            height40,
            /// [Phone number input field]
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
      
            /// [Radio button] for [Same phone number]
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(value: 1, groupValue: _radioSelected, onChanged: (value) {
                   setState(() {
                        if (!_value) {
                          print("Value : false");
                          print(_radioSelected);
                          _radioSelected = 1;
                          _value = true;
                        } else {
                          print("Value : true");
                          print(_radioSelected);
                          _radioSelected = 0;
                          _value = false;
                        }
                      });
                   
                }),
                CustomText(text: 'Same as restaurant contact number', softwrap: true, fontSize: 14,)
              ],
            ),
      
            /// [Checkbox] for recieving [Notifications]
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: checkSelcted,
                      onChanged: (value) {
                         setState(() {
                          if (checkSelcted)
                            checkSelcted = false;
                          else
                            checkSelcted = true;
                        });
                      },
                      activeColor: primaryGreen,
                      checkColor: white,
                    ),
                    CustomText(
                      text: 'Yes, I would like to receive important\nupdates and notifications',
                      color: grey,
                      fontSize: 12.0,
                    )
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(text: 'Register', onpressed: () {})),
                height20
              ],
            )),
          ],
        ),
      ),
    );
  }
}
