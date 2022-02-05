import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// You need to pass the mobile number as [phoneNumber] and
/// a function which will be called after entring OTP as [onSubmit]

class OTPVerification extends StatefulWidget {
  final String phoneNumber;
  final bool isUser;
  OTPVerification(this.phoneNumber, this.isUser);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final FocusNode _otpFocusNode = FocusNode();
  late String _verificationCode;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'We have sent',
              fontSize: 20.0,
            ),
            Row(
              children: [
                CustomText(
                  text: 'you an ',
                  fontSize: 20.0,
                ),
                CustomText(
                  text: 'OTP',
                  fontSize: 20.0,
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            Row(
              children: [
                CustomText(text: 'Enter the 6 digit OTP sent on '),
                CustomText(
                  text: '${widget.phoneNumber}',
                  color: primaryGreen,
                ),
              ],
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
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: otp))
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
                                          preferences.setBool('status', status)
                                        })
                                    .whenComplete(() => {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              makerHomeRoute,
                                              (route) => false)
                                        });
                              } else {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    makerDetailRoute, (route) => false);
                                // makerRef.doc(widget.phoneNumber).set({
                                //   'phoneNo': widget.phoneNumber,
                                // }).then((value) => {
                                //       preferences.setString(
                                //           'UserState', 'MakerDetail'),
                                //       Navigator.pushNamedAndRemoveUntil(context,
                                //           makerDetailRoute, (route) => false)
                                //     });
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
            OutlinedButton(onPressed: () {}, child: CustomText(text: 'Resend')),
            // OutlinedButton(onPressed: () {}, child: CustomText(text: 'Try other methods')),
            height10,
            CustomButton(
              text: 'Submit',
              onpressed: () {},
            )
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("2");
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, makerDetailRoute, (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (verificationID, resendToken) {
        setState(() {
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
