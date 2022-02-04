import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';

/// Screen for [Recipe] details for food maker
class MakerRecipe extends StatefulWidget {
  const MakerRecipe({Key? key}) : super(key: key);

  @override
  _MakerRecipeState createState() => _MakerRecipeState();
}

class _MakerRecipeState extends State<MakerRecipe> {
  bool _available = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dishNameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _available = preferences.getBool('status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: 'Demo',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        Switch(
                          value: _available,
                          onChanged: (value) {
                            preferences.setBool('status', value);
                            setState(() {
                              _available = value;
                              makerRef
                                  .doc(auth.currentUser!.phoneNumber)
                                  .update({
                                'status': value,
                              });
                            });
                          },
                          activeColor: primaryGreen,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: _available ? primaryGreen : Colors.grey,
                          size: 15.0,
                        ),
                        Text(_available ? 'Available' : 'Not Available'),
                      ],
                    ),
                    CustomText(
                      text: "Pizza, FastFood",
                      fontSize: 16,
                      color: grey,
                    ),
                  ],
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: primaryGreen),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         CustomText(
                //           text: "4.5",
                //           color: white,
                //           fontSize: 18,
                //         ),
                //         Icon(
                //           Icons.star,
                //           color: white,
                //           size: 20,
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          height20,
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CustomText(
                text: "Food items",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          height20,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: StreamBuilder(
                stream: makerRef
                    .doc(auth.currentUser!.phoneNumber)
                    .collection('menu')
                    .snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((document) {
                        return ListTile(
                          title: CustomText(
                            text: document['name'],
                          ),
                          subtitle: CustomText(
                            text: document['description'],
                            color: grey,
                          ),
                          trailing: CustomText(
                            text: "₹ " + document['price'],
                            color: primaryGreen,
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: primaryGreen,
      ),
    );
  }

  void _showDialog(BuildContext context) {
    _descController.clear();
    _dishNameController.clear();
    _priceController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.food_bank_rounded,
                          color: primaryGreen,
                          size: 35.0,
                        ),
                        Text(
                          "Add your recipe",
                          style: TextStyle(
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        Icon(
                          Icons.food_bank_rounded,
                          color: primaryGreen,
                          size: 40.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _dishNameController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if ((value!.isEmpty || value == null))
                                return 'Please Enter Dish Name';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Dish Name",
                              labelStyle: TextStyle(color: primaryGreen),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreen)),
                              focusColor: primaryGreen,
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(),
                              ),
                            ),
                            cursorColor: primaryGreen,
                          ),
                          height20,
                          TextFormField(
                            controller: _descController,
                            textCapitalization: TextCapitalization.words,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Description (optional)',
                              labelStyle: TextStyle(color: primaryGreen),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreen)),
                              focusColor: primaryGreen,
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(),
                              ),
                            ),
                            cursorColor: primaryGreen,
                          ),
                          height20,
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if ((value!.isEmpty || value == null))
                                return 'Please Enter Landmark';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Price ₹',
                              labelStyle: TextStyle(color: primaryGreen),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreen)),
                              focusColor: primaryGreen,
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(),
                              ),
                            ),
                            cursorColor: primaryGreen,
                          ),
                          height20,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryGreen,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            makerRef
                                .doc(auth.currentUser!.phoneNumber)
                                .collection('menu')
                                .doc(_dishNameController.value.text)
                                .set({
                              'name': _dishNameController.value.text,
                              'description': _descController.value.text,
                              'price': _priceController.value.text,
                            }).then((value) => {
                                      Fluttertoast.showToast(msg: 'Dish Added'),
                                      Navigator.of(context).pop(),
                                    });
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
