import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/routes/routes.dart';

import '../../routes/constants.dart';
import '../../routes/constants.dart';

class RoleSelector extends StatefulWidget {
  RoleSelector({Key? key}) : super(key: key);

  @override
  _RoleSelectorState createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  String role = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,

        /// No need of [back button] in [Role Selector]
        // leading: backButton(() {
        //   Navigator.pop(context);
        // }),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: "Hello!",
                color: primaryBlack,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
            CustomText(
              text: "Welcome to Vyanjan",
              color: primaryBlack,
              fontSize: 20.0,
            ),
            Divider(),
            CustomText(
              text: "Please help us to know you better",
              color: Colors.grey,
              fontSize: 15.0,
            ),
            CustomText(
              text: 'Are you a',
              color: primaryBlack,
              fontSize: 20.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      /// route For [Food Seeker Login] page
                      //  Navigator.pushNamed(context, foodSeekerRoute);
                      setState(() {
                        role = 'Seeker';
                      });
                    },
                    child: CustomText(
                      text: 'Food Seeker',
                      color: primaryBlack,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: role == 'Seeker'
                              ? primaryGreen
                              : Colors.grey.shade400),
                    ),
                  ),
                  CustomText(
                    text: 'OR',
                    color: primaryBlack,
                    fontWeight: FontWeight.bold,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      /// route For [Food Maker Login] page
                      // Navigator.pushNamed(context, foodMakerRoute);
                      setState(() {
                        role = 'Maker';
                      });
                    },
                    child: CustomText(
                      text: 'Food Maker',
                      color: primaryBlack,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: role == 'Maker'
                              ? primaryGreen
                              : Colors.grey.shade400),
                    ),
                  )
                ],
              ),
            ),

            /// [Continue Button]
            MaterialButton(
              onPressed: () {
                if (role == 'Seeker')
                  Navigator.pushNamed(context, foodSeekerRoute);
                else if (role == 'Maker')
                  Navigator.pushNamed(context, foodMakerRoute);
              },
              color: primaryGreen,
              child: CustomText(
                text: 'Continue',
                color: white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
