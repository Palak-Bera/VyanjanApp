import 'package:flutter/material.dart';
import 'package:food_app/features/CommonScreens/otp_verification.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerLogin.dart';
import 'package:food_app/features/FoodMaker/Authentication/ownerDetails.dart';
import 'package:food_app/features/FoodMaker/Authentication/restaurantContact.dart';
import 'package:food_app/features/FoodMaker/Authentication/restaurantDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerLogin.dart';
import 'package:food_app/features/FoodSeeker/Home/availableFoodMaker.dart';
import 'package:food_app/features/FoodSeeker/Home/availableItem.dart';
import 'package:food_app/features/FoodSeeker/Home/searchFood.dart';
import 'package:food_app/features/FoodSeeker/Home/userCart.dart';
import 'package:food_app/features/FoodSeeker/Home/userDetails.dart';
import 'package:food_app/features/InitialScreens/roleSelector.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/routes/routes.dart';
import 'features/InitialScreens/splashscreen.dart';

void main() {
  runApp(App());
}

/// Routing between pages is not yet applied as it needs to be managed
/// by proper State Management Logic according to functionality.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
       home:UserDetails(),
      
    );
  }
}
