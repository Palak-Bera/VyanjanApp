import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String intialRoute = '/';

/// Routes for [Food Seeker]
const String foodSeekerLoginRoute = '/SeekerLogin';
const String foodSeekerRegisterRoute = '/SeekerRegister';
const String seekerDetailRoute = '/SeekerDetails';
const String seekerHomeRoute = '/SeekerHome';
const String availableFoodMakerRoute = '/AvailableFoodMaker';
const String makerMenuRoute = '/MakerMenu';
const String seekerCartRoute = '/SeekerCart';
const String seekerDashboardRoute = '/SeekerDashboard';

/// Routes for [Food Maker]
const String foodMakerRegisterRoute = '/MakerRegister';
const String foodMakerLoginRoute = '/MakerLogin';
const String makerDetailRoute = '/MakerDetails';
const String restaurantContactRoute = '/RestaurantContact';
const String restaurantOwnerRoute = '/OwnerDetails';
const String makerHomeRoute = '/MakerHome';
const String notificationBannerRoute = '/NotificationBanner';

bool isSeekerLoggedIn = false;

/// Routes for [Common Screen]
const String otpRoute = '/OTPVerification';
const String roleSelectorRoute = '/RoleSelector';

/// Firebase initializations
CollectionReference makerRef =
    FirebaseFirestore.instance.collection('foodMaker');
CollectionReference seekerRef =
    FirebaseFirestore.instance.collection('foodSeeker');

FirebaseAuth auth = FirebaseAuth.instance;

DatabaseReference makerRealtimeRef =
    FirebaseDatabase.instance.ref("makerOrders");
DatabaseReference seekerRealtimeRef =
    FirebaseDatabase.instance.ref("seekerOrders");

String role = '';

getItemCount() {
  int itemCount = 0;
  for (int i = 0; i < cart.cartItem.length; i++) {
    itemCount += cart.cartItem[i].quantity;
  }
  return itemCount;
}

initializeSharedPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

///cartMakerItems
///UserState
///status
var preferences;

/// Google Map API Key
const String googleMapAPI = "AIzaSyArajhZ05FjwR23zouneFC-6q-ZB5zaV10";
