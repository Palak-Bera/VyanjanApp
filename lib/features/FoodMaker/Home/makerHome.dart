import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/features/FoodMaker/Home/makerRecipe.dart';
import 'package:food_app/features/FoodMaker/Home/orderHistory.dart';
import 'package:food_app/features/FoodSeeker/Home/makerMenu.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';

class MakerHome extends StatefulWidget {
  @override
  _MakerHomeState createState() => _MakerHomeState();
}

class _MakerHomeState extends State<MakerHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: primaryGreen,
          backgroundColor: white,
          title: Center(child: Text('Maker Home')),
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut();
                  preferences.setString('UserState', '');
                  Navigator.pushNamedAndRemoveUntil(
                      context, roleSelectorRoute, (route) => false);
                },
                icon: Icon(Icons.logout))
          ],
          bottom: TabBar(
            indicatorColor: primaryGreen,
            tabs: [
              Tab(
                child: Text(
                  'My Recipes',
                  style: TextStyle(
                    color: primaryBlack,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    color: primaryBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MakerRecipe(),
            OrderHistory(),
          ],
        ),
      ),
    );
  }
}
