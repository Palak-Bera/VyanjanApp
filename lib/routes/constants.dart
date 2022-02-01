import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String intialRoute = '/';

/// Routes for [Food Seeker]
const String foodSeekerLoginRoute = '/SeekerLogin';
const String foodSeekerRegisterRoute = '/SeekerRegister';
const String seekerDetailRoute = '/SeekerDetails';
const String seekerHomeRoute = '/SeekerHome';
const String availableFoodMakerRoute = '/AvailableFoodMaker';
const String availableItemRoute = '/AvailableItem';
const String seekerCartRoute = '/SeekerCart';
const String seekerDashboardRoute = '/SeekerDashboard';

/// Routes for [Food Maker]
const String foodMakerRegisterRoute = '/MakerRegister';
const String foodMakerLoginRoute = '/MakerLogin';
const String makerDetailRoute = '/MakerDetails';
const String restaurantContactRoute = '/RestaurantContact';
const String restaurantOwnerRoute = '/OwnerDetails';
const String makerHomeRoute = '/MakerHome';

/// Routes for [Common Screen]
const String otpRoute = '/OTPVerification';

/// Firebase initializations
CollectionReference makerRef =
    FirebaseFirestore.instance.collection('foodMaker');
CollectionReference seekerRef =
    FirebaseFirestore.instance.collection('foodSeeker');
FirebaseAuth auth = FirebaseAuth.instance;

String role = '';

initializeSharedPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

var preferences;

/// Google Map API Key
const String googleMapAPI = "AIzaSyArajhZ05FjwR23zouneFC-6q-ZB5zaV10";
