import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/features/CommonScreens/otpVerification.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:libphonenumber/libphonenumber.dart' as libPhone;

/// login Page for [Food Seeker]
class SeekerLogin extends StatefulWidget {
  SeekerLogin({Key? key}) : super(key: key);

  @override
  _SeekerLoginState createState() => _SeekerLoginState();
}

class _SeekerLoginState extends State<SeekerLogin> {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _phoneNoKey = GlobalKey<FormState>();

  String phoneNo = '';
  bool isUser = false;

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    bool? isValid;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
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
                      text: 'Login as Food Seeker',
                      fontSize: 18.0,
                    ),
                    height10,

                    /// [Phone number input field]
                    Form(
                      key: _phoneNoKey,
                      child: InternationalPhoneNumberInput(
                        ignoreBlank: true,
                        textFieldController: phoneController,
                        maxLength: 15,
                        initialValue: number,
                        onInputChanged: (value) {
                          number = value;
                          phoneNo = value.toString();
                        },
                        validator: (phone) {
                          print(phoneController.value.text.replaceAll(' ', ''));
                          if (phoneController.value.text.isEmpty || !isValid!) {
                            return 'Invalid Phone Number';
                          } else {
                            return null;
                          }
                        },
                        inputBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        keyboardType: TextInputType.phone,
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          showFlags: true,
                          setSelectorButtonAsPrefixIcon: false,
                        ),
                      ),
                    ),
                    height20,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CustomButton(
                          text: 'Login Now',
                          onpressed: () async {
                            print(phoneNo);
                            isValid = await libPhone.PhoneNumberUtil
                                .isValidPhoneNumber(
                                    phoneNumber: phoneNo,
                                    isoCode: number.isoCode!);
                            print(isValid);
                            if (_phoneNoKey.currentState!.validate()) {
                              await seekerRef.get().then((docs) => {
                                    if (docs != null)
                                      {
                                        docs.docs.forEach((document) {
                                          if (phoneNo == document.id)
                                            isUser = true;
                                        }),
                                      }
                                  });
                              if (isUser) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OTPVerification(number, isUser),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'User not registered');
                              }
                            }
                          }),
                    ),
                    height10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'Not registered?  '),

                        /// [Login text link]
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomText(
                            text: 'Register Now',
                            color: primaryGreen,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    text: 'By continuing, you agree to our',
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  CustomText(
                    text: 'Terms of Service  Privacy Policy  Content Policy',
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
