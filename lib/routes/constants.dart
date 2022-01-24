import 'package:cloud_firestore/cloud_firestore.dart';

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
const String restaurantDetailRoute = '/RestaurantDetails';
const String restaurantContactRoute = '/RestaurantContact';
const String restaurantOwnerRoute = '/OwnerDetails';

/// Routes for [Common Screen]
const String otpRoute = '/OTPVerification';

CollectionReference makerRef =
    FirebaseFirestore.instance.collection('foodMaker');
