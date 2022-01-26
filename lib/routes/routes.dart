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

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intialRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case otpRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case foodSeekerRoute:
        return MaterialPageRoute(builder: (_) => SeekerLogin());

      case seekerDetailRoute:
        return MaterialPageRoute(builder: (_) => SeekerDetails());

      case searchFoodRoute:
        return MaterialPageRoute(builder: (_) => SearchFood());

      case availableFoodMakerRoute:
        return MaterialPageRoute(builder: (_) => AvailableFoodMaker());

      case availableItemRoute:
        return MaterialPageRoute(builder: (_) => AvailableItem());

      case userCartRoute:
        return MaterialPageRoute(builder: (_) => UserCart()); //left

      case userDetailRoute:
        return MaterialPageRoute(builder: (_) => UserDetails());

      case foodMakerRoute:
        return MaterialPageRoute(builder: (_) => MakerLogin());

      case makerDetailRoute:
        return MaterialPageRoute(builder: (_) => MakerDetails());

      case restaurantContactRoute:
        return MaterialPageRoute(builder: (_) => RestaurantContact());

      case restaurantOwnerRoute:
        return MaterialPageRoute(builder: (_) => OwnerDetails());

      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
