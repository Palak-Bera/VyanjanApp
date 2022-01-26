import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerLogin.dart';
import 'package:food_app/features/FoodMaker/Authentication/ownerDetails.dart';
import 'package:food_app/features/FoodMaker/Authentication/restaurantContact.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerLogin.dart';
import 'package:food_app/features/FoodSeeker/Home/availableFoodMaker.dart';
import 'package:food_app/features/FoodSeeker/Home/availableItem.dart';
import 'package:food_app/features/FoodSeeker/Home/searchFood.dart';
import 'package:food_app/features/FoodSeeker/Home/userCart.dart';
import 'package:food_app/features/FoodSeeker/Home/userDetails.dart';
import 'package:food_app/features/InitialScreens/splashscreen.dart';
import 'package:food_app/routes/constants.dart';
import 'routes/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

/// Routing between pages is not yet applied as it needs to be managed
/// by proper State Management Logic according to functionality.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MakerDetails(),
      routes: {
        foodSeekerRoute: (context) => SeekerLogin(),
        seekerDetailRoute: (context) => SeekerDetails(),
        searchFoodRoute: (context) => SearchFood(),
        availableFoodMakerRoute: (context) => AvailableFoodMaker(),
        availableItemRoute: (context) => AvailableItem(),
        userDetailRoute: (context) => UserDetails(),
        userCartRoute: (context) => UserCart(),
        foodMakerRoute: (context) => MakerLogin(),
        makerDetailRoute: (context) => MakerDetails(),
      },
    );
  }
}
