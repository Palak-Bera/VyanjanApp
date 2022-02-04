import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerRegister.dart';
import 'package:food_app/features/FoodMaker/Authentication/ownerDetails.dart';
import 'package:food_app/features/FoodMaker/Authentication/restaurantContact.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerLogin.dart';
import 'package:food_app/features/FoodSeeker/Home/availableFoodMaker.dart';
import 'package:food_app/features/FoodSeeker/Home/makerMenu.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerCart.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerDashboard.dart';
import 'package:food_app/features/InitialScreens/splashscreen.dart';
import 'package:food_app/routes/constants.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intialRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case otpRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case foodSeekerLoginRoute:
        return MaterialPageRoute(builder: (_) => SeekerLogin());

      case seekerDetailRoute:
        return MaterialPageRoute(builder: (_) => SeekerDetails());

      case seekerHomeRoute:
        return MaterialPageRoute(builder: (_) => SeekerHome());

      case availableFoodMakerRoute:
        return MaterialPageRoute(builder: (_) => AvailableFoodMaker());

      case seekerCartRoute:
        return MaterialPageRoute(builder: (_) => SeekerCart()); //left

      case seekerDashboardRoute:
        return MaterialPageRoute(builder: (_) => SeekerDashboard());

      case foodMakerRegisterRoute:
        return MaterialPageRoute(builder: (_) => MakerRegister());

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
