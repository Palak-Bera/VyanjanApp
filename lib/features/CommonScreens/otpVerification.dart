import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerDetails.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// You need to pass the mobile number as [phoneNumber] and
/// a function which will be called after entring OTP as [onSubmit]

class OTPVerification extends StatefulWidget {
  final PhoneNumber phoneNumber;
  final bool isUser;
  OTPVerification(this.phoneNumber, this.isUser);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final FocusNode _otpFocusNode = FocusNode();
  late String _verificationCode;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppbar(
        onBackPressed: () {},
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'We have sent',
                    fontSize: 20.0,
                    softwrap: true,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        CustomText(
                          text: 'you an ',
                          fontSize: 20.0,
                          softwrap: true,
                        ),
                        CustomText(
                          text: 'OTP',
                          fontSize: 20.0,
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                          softwrap: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Enter the 6 digit OTP sent on ',
                          softwrap: true,
                        ),
                        CustomText(
                          text: '${widget.phoneNumber.phoneNumber}',
                          color: primaryGreen,
                          softwrap: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 30.0, bottom: 20.0),
                    child: PinCodeTextField(
                      autoFocus: true,
                      enablePinAutofill: true,
                      focusNode: _otpFocusNode,
                      appContext: context,
                      obscureText: false,
                      pastedTextStyle: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1.0,
                        borderRadius: BorderRadius.circular(10.0),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: white,
                        inactiveColor: Colors.grey,
                        activeColor: primaryGreen,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      keyboardType: TextInputType.number,
                      cursorColor: primaryGreen,
                      length: 6,
                      onCompleted: (otp) async {
                        try {
                          print("1");
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: _verificationCode,
                                      smsCode: otp))
                              .then((value) async {
                            if (value.user != null) {
                              setState(() {
                                _loading = true;
                              });

                              switch (role) {
                                case 'Maker':
                                  {
                                    if (widget.isUser) {
                                      preferences.setString(
                                          'UserState', 'Maker');
                                      bool status = false;
                                      makerRef
                                          .doc(auth.currentUser!.phoneNumber)
                                          .get()
                                          .then((value) => {
                                                status = value.get('status'),
                                                print('status: ' +
                                                    status.toString()),
                                                preferences.setBool(
                                                    'status', status),
                                                getDeviceToken()
                                              })
                                          .whenComplete(() => {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        makerHomeRoute,
                                                        (route) => false)
                                              });
                                    } else {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MakerDetails(
                                                number: widget.phoneNumber),
                                          ),
                                          (route) => false);
                                    }
                                    break;
                                  }
                                case 'Seeker':
                                  {
                                    if (widget.isUser) {
                                      preferences.setString(
                                          'UserState', 'Seeker');
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          seekerHomeRoute, (route) => false);
                                    } else {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          seekerDetailRoute, (route) => false);
                                    }
                                    break;
                                  }
                              }
                            }
                          });
                        } catch (e) {
                          FocusScope.of(context).unfocus();
                          Fluttertoast.showToast(
                              msg: "Invalid OTP",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 18.0);
                        }
                      },
                      onChanged: (val) {},
                    ),
                  ),
                  // OutlinedButton(
                  //     onPressed: () {}, child: CustomText(text: 'Resend')),
                  // // OutlinedButton(onPressed: () {}, child: CustomText(text: 'Try other methods')),
                  // height10,
                  // CustomButton(
                  //   text: 'Submit',
                  //   onpressed: () {},
                  // )
                ],
              ),
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
    );
  }

  getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      makerRef
          .doc(auth.currentUser!.phoneNumber)
          .update({'deviceToken': value});
    });
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("2");
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            switch (role) {
              case 'Maker':
                {
                  if (widget.isUser) {
                    preferences.setString('UserState', 'Maker');
                    bool status = false;
                    makerRef
                        .doc(auth.currentUser!.phoneNumber)
                        .get()
                        .then((value) => {
                              status = value.get('status'),
                              print('status: ' + status.toString()),
                              preferences.setBool('status', status),
                              getDeviceToken()
                            })
                        .whenComplete(() => {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, makerHomeRoute, (route) => false)
                            });
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MakerDetails(number: widget.phoneNumber),
                        ),
                        (route) => false);
                  }
                  break;
                }
              case 'Seeker':
                {
                  if (widget.isUser) {
                    preferences.setString('UserState', 'Seeker');
                    Navigator.pushNamedAndRemoveUntil(
                        context, seekerHomeRoute, (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, seekerDetailRoute, (route) => false);
                  }
                  break;
                }
            }
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (verificationID, resendToken) {
        setState(() {
          _loading = false;
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 120),
    );
  }
}
