import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/features/FoodSeeker/Home/widgets/itemCard.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';


/// Page for [user details]
class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    bool checkSelcted = false;

    return Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppbar(
          onBackPressed: () {},
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Robert Frost",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: "Food Seeker",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryGreen,
                        ),
                        CustomText(text: "Your Address Details", fontSize: 15),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: primaryGreen,
                      radius: 45.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage:
                              AssetImage('assets/images/person.jpeg'),
                        ),
                      ),
                    ),
                  ],
                ),

                // Location and chnage
                height10,
                ListTile(
                  leading: Icon(
                    Icons.location_on_sharp,
                    color: primaryGreen,
                    size: 35,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  title: CustomText(
                    text: "Ahmedabad",
                    fontSize: 18,
                  ),
                  subtitle: CustomText(
                    text: "India",
                    color: primaryGreen,
                    fontSize: 15,
                  ),
                  trailing: CustomText(
                    text: "CHANGE",
                    color: primaryGreen,
                    fontSize: 18,
                  ),
                  horizontalTitleGap: 0,
                ),

                height10,
                // Complete address
                CustomText(
                  text: "Complete Address*",
                  fontSize: 15,
                ),

                TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'House No. / Flat No. / Floor / Bulding',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen)),
                  ),
                  cursorColor: primaryGreen,
                ),
                height10,
                TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Landmark (Optional)',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen)),
                  ),
                  cursorColor: primaryGreen,
                ),
                height10,
                TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'How to reach',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen)),
                  ),
                  cursorColor: primaryGreen,
                ),
                height10,

                // tag location
                CustomText(text: "tag this location for *"),
                height10,
                Container(
                  height: 30.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Tag(
                        text: 'Home',
                        onTap: () {},
                      ),
                      Tag(
                        text: 'Work',
                        onTap: () {},
                      ),
                      Tag(
                        text: 'Hotel',
                        onTap: () {},
                      ),
                      Tag(
                        text: 'Other',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                height20,
                // phone number field
                TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    suffix: CustomText(
                      text: 'VERIFY',
                      color: primaryGreen,
                      fontSize: 12.0,
                    ),
                    hintText: 'Phone Number',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen)),
                  ),
                  cursorColor: primaryGreen,
                  keyboardType: TextInputType.number,
                ),
                // email address
                TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    suffix: CustomText(
                      text: 'VERIFY',
                      color: primaryGreen,
                      fontSize: 12.0,
                    ),
                    hintText: 'Email Address',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen)),
                  ),
                  cursorColor: primaryGreen,
                  keyboardType: TextInputType.emailAddress,
                ),

                // Check Box
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: checkSelcted,
                      onChanged: (value) {
                        setState(() {
                          if(checkSelcted)
                            checkSelcted = false;
                          else
                            checkSelcted = true;
                        });
                      },
                      checkColor: white,
                      activeColor: primaryGreen,
                      // fillColor: ,
                    ),
                    Expanded(child: CustomText(text: "Save this details for your future orders", softwrap: true,))
                  ],
                ),
              ],
            ),
          ),
        ),


        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: CustomButton(text: "Proceed for Payment",onpressed: (){},),
          ),
        ),
        );
  }
}
