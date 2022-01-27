import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String intialRoute = '/';

/// Routes for [Food Seeker]
const String foodSeekerRoute = '/SeekerLogin';
const String seekerDetailRoute = '/SeekerDetails';
const String searchFoodRoute = '/SearchFood';
const String availableFoodMakerRoute = '/AvailableFoodMaker';
const String availableItemRoute = '/AvailableItem';
const String userCartRoute = '/UserCart';
const String userDetailRoute = '/UserDetails';

/// Routes for [Food Maker]
const String foodMakerRoute = '/MakerLogin';
const String makerDetailRoute = '/MakerDetails';
const String restaurantContactRoute = '/RestaurantContact';
const String restaurantOwnerRoute = '/OwnerDetails';
const String makerRecipesRoute = '/MakerRecipe';

/// Routes for [Common Screen]
const String otpRoute = '/OTPVerification';

CollectionReference makerRef =
    FirebaseFirestore.instance.collection('foodMaker');

FirebaseAuth auth = FirebaseAuth.instance;

/// Google Map API Key
const String googleMapAPI = "AIzaSyArajhZ05FjwR23zouneFC-6q-ZB5zaV10";
