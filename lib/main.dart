import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerLogin.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerRegister.dart';
import 'package:food_app/features/FoodMaker/Authentication/makerDetails.dart';
import 'package:food_app/features/FoodMaker/Home/makerHome.dart';
import 'package:food_app/features/FoodMaker/Home/makerRecipe.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerDetails.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerLogin.dart';
import 'package:food_app/features/FoodSeeker/Authentication/seekerRegister.dart';
import 'package:food_app/features/FoodSeeker/Home/availableFoodMaker.dart';
import 'package:food_app/features/FoodSeeker/Home/makerMenu.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerCheckout.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerCart.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerDashboard.dart';
import 'package:food_app/features/InitialScreens/roleSelector.dart';
import 'package:food_app/features/InitialScreens/splashscreen.dart';
import 'package:food_app/routes/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: SplashScreen(),
      routes: {
        roleSelectorRoute: (context) => RoleSelector(),
        foodSeekerLoginRoute: (context) => SeekerLogin(),
        foodSeekerRegisterRoute: (context) => SeekerRegister(),
        seekerDetailRoute: (context) => SeekerDetails(),
        seekerHomeRoute: (context) => SeekerHome(),
        availableFoodMakerRoute: (context) => AvailableFoodMaker(),
        seekerDashboardRoute: (context) => SeekerDashboard(),
        seekerCartRoute: (context) => SeekerCart(),
        foodMakerLoginRoute: (context) => MakerLogin(),
        foodMakerRegisterRoute: (context) => MakerRegister(),
        makerDetailRoute: (context) => MakerDetails(),
        makerHomeRoute: (context) => MakerHome(),
        seekerCheckoutRoute: (context) => SeekerCheckout(),
      },
    );
  }
}
