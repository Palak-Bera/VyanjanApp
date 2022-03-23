import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/customWidgets.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:http/http.dart' as http;

class MakerBankDetails extends StatefulWidget {
  Map<String, dynamic> makerDetailsMap;
  MakerBankDetails({Key? key, required this.makerDetailsMap}) : super(key: key);
  @override
  _MakerBankDetailsState createState() => _MakerBankDetailsState();
}

class _MakerBankDetailsState extends State<MakerBankDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _accNameController = TextEditingController();
  TextEditingController _accNumberController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();

  bool isIFSCValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backwardsCompatibility: true,
        title: Text(
          'Recipient Bank Details',
          style: TextStyle(color: primaryGreen),
        ),
        iconTheme: IconThemeData(color: primaryGreen),
        elevation: 0.0,
        backgroundColor: white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _accNameController,
                validator: (value) {
                  if (value!.isEmpty || value == null)
                    return 'Please Enter your Name';
                  else
                    return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Recipient Name *',
                ),
                cursorColor: primaryGreen,
              ),
              height20,
              TextFormField(
                controller: _accNumberController,
                validator: (value) {
                  if (value!.isEmpty || value == null || value.length < 14)
                    return 'Please Enter your Account Number';
                  else
                    return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Account Number *',
                ),
                cursorColor: primaryGreen,
              ),
              height20,
              TextFormField(
                controller: _ifscController,
                maxLength: 11,
                validator: (value) {
                  if (value!.isEmpty || value == null || value.length < 11)
                    return 'Please Enter valid IFSC Code';
                  else
                    return null;
                },
                onChanged: (value) {
                  if (!_formKey.currentState!.validate()) {
                    setState(() {
                      isIFSCValid = false;
                    });
                  }
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'IFSC Code *',
                  counterText: '',
                  suffix: isIFSCValid
                      ? Icon(
                          Icons.check_circle,
                          color: primaryGreen,
                        )
                      : GestureDetector(
                          onTap: () async {
                            var url = Uri.parse('https://ifsc.razorpay.com/' +
                                _ifscController.value.text);
                            var res = await http.get(url);
                            if (res.statusCode == 200) {
                              var response = jsonDecode(res.body);
                              setState(() {
                                isIFSCValid = true;
                              });
                              print(response);
                            } else {
                              print('error');
                              //_formKey.currentState!.validate();
                            }
                          },
                          child: Text(
                            'Search for IFSC',
                            style: TextStyle(color: primaryGreen),
                          ),
                        ),
                ),
                cursorColor: primaryGreen,
              ),
              height40,
              Container(
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                    text: 'Continue',
                    onpressed: () {
                      if (_formKey.currentState!.validate()) {
                        makerRef
                            .doc(auth.currentUser!.phoneNumber)
                            .set(widget.makerDetailsMap)
                            .then((value) async {
                          await createMakerContact(
                              widget.makerDetailsMap['name']);

                          getDeviceToken();

                          preferences.setString('UserState', 'Maker');
                          preferences.setBool('status', false);
                          Navigator.pushNamedAndRemoveUntil(
                              context, makerHomeRoute, (route) => false);
                        });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      makerRef
          .doc(auth.currentUser!.phoneNumber)
          .update({'deviceToken': value});
    });
  }

  createMakerContact(String makerName) async {
    var apiKey = 'rzp_test_QsDMPb9jLx9EbE';
    var secret = 'mZk44Ei1HtdmkqE3KxlMC5zz';
    var authn = 'Basic ' + base64Encode(utf8.encode('$apiKey:$secret'));

    var data = {
      "name": makerName,
      'contact': auth.currentUser!.phoneNumber,
      "email": ''
    };

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var url = Uri.parse('https://api.razorpay.com/v1/contacts');
    var res = await http.post(url, headers: headers, body: jsonEncode(data));
    var response = jsonDecode(res.body);
    if (res.statusCode.toString()[0] == '2') {
      print(res.statusCode);
      print(response['id']);
      await createMakerFundAccount(response['id']);
    } else {
      print('error');
      print(res.body);
    }
  }

  createMakerFundAccount(String contact_id) async {
    print('inside createMakerFundAccount');
    var apiKey = 'rzp_test_QsDMPb9jLx9EbE';
    var secret = 'mZk44Ei1HtdmkqE3KxlMC5zz';
    var authn = 'Basic ' + base64Encode(utf8.encode('$apiKey:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data = {
      "contact_id": contact_id,
      'account_type': 'bank_account',
      "bank_account": {
        'name': _accNameController.value.text,
        'ifsc': _ifscController.value.text,
        'account_number': _accNumberController.value.text
      }
    };

    var url = Uri.parse('https://api.razorpay.com/v1/fund_accounts/');
    var res = await http.post(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode.toString()[0] == '2') {
      print(res.statusCode);
      print(res.statusCode.toString()[0]);
      var response = jsonDecode(res.body);
      print(response['id']);
      makerRef.doc(auth.currentUser!.phoneNumber).update({
        'accountDetails': {
          'contact_id': contact_id,
          'fundAcc_id': response['id']
        }
      });
    } else {
      print(res.statusCode);
      print(res.statusCode.toString()[0]);
      print(res.body);
      var response = jsonDecode(res.body);
      print(response['id']);
      makerRef.doc(auth.currentUser!.phoneNumber).update({
        'accountDetails': {
          'contact_id': contact_id,
          'fundAcc_id': response['id']
        }
      });
    }
  }
}
