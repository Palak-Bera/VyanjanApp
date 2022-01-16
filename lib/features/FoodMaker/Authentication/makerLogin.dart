import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Login Page for [Food Maker]
class MakerLogin extends StatefulWidget {
  MakerLogin({Key? key}) : super(key: key);

  @override
  _MakerLoginState createState() => _MakerLoginState();
}

class _MakerLoginState extends State<MakerLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// Introductory image in the beginning
              Container(
                child: Image.asset('assets/images/f9.png'),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Register as Food Maker',
                      fontSize: 18.0,
                    ),
                    height10,

                    /// [Phone number input field]
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
                    height20,

                    /// [Register Now Button]
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child:
                          CustomButton(text: 'Register Now', onpressed: () {}),
                    ),
                    height10,
                    Row(
                      children: [
                        CustomText(text: 'Already registered?  '),

                        /// [Login text link]
                        InkWell(
                          onTap: () {},
                          child: CustomText(
                            text: 'Login Now',
                            color: primaryGreen,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomText(text: 'or'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    height20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// [Email button]
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey)),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.email_outlined))),
                        width20,

                        /// [More button]
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey)),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_horiz))),
                      ],
                    ),
                  ],
                ),
              ),
              height10,
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    text: 'By continuining, you agree to our',
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  CustomText(
                    text: 'Terms of Serivce  Privacy Policy  Content Policy',
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
