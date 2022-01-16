import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


/// You need to pass the mobile number as [phoneNumber] and
/// a function which will be called after entring OTP as [onSubmit]
 
class OTPVerification extends StatefulWidget {

  final Function() onSubmit;
  final String phoneNumber;

  OTPVerification({Key? key, required this.onSubmit, required this.phoneNumber}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
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
                CustomText(text: 'Enter the 4 digit OTP sent on '),
                CustomText(
                  text: '${widget.phoneNumber}',
                  color: primaryGreen,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 20.0),
              child: PinCodeTextField(
                appContext: context,
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
                keyboardType: TextInputType.number,
                cursorColor: primaryGreen,
                length: 4,
                onChanged: (val) {},
              ),
            ),
            Row(
              children: [
                OutlinedButton(onPressed: () {}, child: CustomText(text: 'Resend')),
                width10,
                OutlinedButton(onPressed: () {}, child: CustomText(text: 'Call me')),
              ],
            ),
            // OutlinedButton(onPressed: () {}, child: CustomText(text: 'Try other methods')),
            height10,
            CustomButton(text: 'Submit', 
            onpressed: widget.onSubmit,
            )
          ],
        ),
      ),
    );
  }
}
