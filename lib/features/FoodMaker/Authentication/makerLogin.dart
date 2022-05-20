import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/features/CommonScreens/otpVerification.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:libphonenumber/libphonenumber.dart' as libPhone;

/// Register Page for [Food Maker]
class MakerLogin extends StatefulWidget {
  MakerLogin({Key? key}) : super(key: key);

  @override
  _MakerLoginState createState() => _MakerLoginState();
}

class _MakerLoginState extends State<MakerLogin> {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _phoneNoKey = GlobalKey<FormState>();
  String phoneNo = '';
  bool isUser = false;

  bool _loading = false;

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    bool? isValid;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Stack(
            children: [
              Column(
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
                          text: 'Login as Food Maker',
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
                              print(phoneController.value.text
                                  .replaceAll(' ', ''));
                              if (phoneController.value.text.isEmpty ||
                                  !isValid!) {
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

                        /// [Login Now Button]
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
                                  setState(() {
                                    _loading = true;
                                  });
                                  await makerRef.get().then((docs) => {
                                        if (docs != null)
                                          {
                                            docs.docs.forEach((document) {
                                              if (phoneNo == document.id)
                                                isUser = true;
                                            }),
                                          }
                                      });
                                  if (isUser) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OTPVerification(number, isUser),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: 'User not registered');
                                  }
                                }
                              }),
                        ),
                        height10,
                        Row(
                          children: [
                            CustomText(text: 'Not registered?  '),

                            /// [Register text link]
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
                                border: Border.all(color: Colors.grey),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.email_outlined),
                              ),
                            ),
                            width20,

                            /// [More button]
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_horiz),
                              ),
                            ),
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
                        text:
                            'Terms of Serivce  Privacy Policy  Content Policy',
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ],
                  )
                ],
              ),
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
        ),
      ),
    );
  }
}
