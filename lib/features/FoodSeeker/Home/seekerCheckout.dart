import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:crypto/crypto.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/features/FoodMaker/Home/notificationBanner.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/customWidgets.dart';

class SeekerCheckout extends StatefulWidget {
  final String deliveryMode;
  const SeekerCheckout({Key? key, required this.deliveryMode})
      : super(key: key);

  @override
  _SeekerCheckoutState createState() => _SeekerCheckoutState();
}

class _SeekerCheckoutState extends State<SeekerCheckout> {
  TextEditingController _addressController = TextEditingController();
  CountDownController _countDownController = CountDownController();
  List<Widget> _stepWidgets = [Text('a'), Text('b'), Text('c')];

  late String makerContact;
  late String makerAddress;
  String paymentMode = "";

  int currentStep = 0;

  late Razorpay razorpay;
  late var result;
  late var makerAccDetails;

  late String token;

  @override
  void initState() {
    super.initState();

    getAddress();
    getMakerDetails();
    print('paymentMode: ' + paymentMode);

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onPaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
    print('cleared');
  }

  getMakerDetails() async {
    await makerRef
        .where('name', isEqualTo: preferences.getString('cartMakerItems'))
        .snapshots()
        .forEach((element) {
      element.docs.forEach((element) {
        setState(() {
          makerContact = element.get('phoneNo');
          makerAccDetails = element.get('accountDetails');
          token = element.get('deviceToken');
          makerAddress = element.get('address');
        });
      });
      checkOrderStatus();
    });
  }

  Future<void> onPaymentSuccess(PaymentSuccessResponse response) async {
    await vendorPayout();

    makerRealtimeRef.child(makerContact).limitToLast(1).once().then((value) {
      String orderID = value.snapshot.children.last.key.toString();
      print(value.snapshot.children.last.key.toString());
      makerRealtimeRef.child(makerContact).child(orderID).update({
        'paymentStatus': true,
        'deliveryMode': widget.deliveryMode,
        'paymentMode': paymentMode,
      });
    });
    Fluttertoast.showToast(msg: 'Success').then((value) {
      cart.cartItem.clear();
      // Navigator.popUntil(context, ModalRoute.withName(seekerHomeRoute));
      Navigator.pushNamedAndRemoveUntil(
          context, seekerHomeRoute, (route) => false);
    });
  }

  void onPaymentError() {
    Fluttertoast.showToast(msg: 'Error').then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, seekerHomeRoute, (route) => false);
    });
  }

  void onExternalWallet() {
    Fluttertoast.showToast(msg: 'External Wallet');
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  razorpayCreateOrder() async {
    String receipt_id = generateMd5(auth.currentUser!.uid +
        auth.currentUser!.phoneNumber.toString() +
        DateTime.now().toString());

    var apiKey = 'rzp_test_QsDMPb9jLx9EbE';
    var secret = 'mZk44Ei1HtdmkqE3KxlMC5zz';
    var authn = 'Basic ' + base64Encode(utf8.encode('$apiKey:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data = {
      "amount": widget.deliveryMode == "Doorstep Delivery"
          ? ((cart.getTotalAmount() * 100) + 50 * 100)
          : cart.getTotalAmount() * 100,
      "currency": "INR",
      "receipt": receipt_id
    };

    var url = Uri.parse('https://api.razorpay.com/v1/orders');
    var res = await http.post(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode != 200) {
      Fluttertoast.showToast(
          msg: 'Some Error occurred while initiating payment');
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    } else {
      result = jsonDecode(res.body);
      openCheckout(result['id']);
    }
    print(result['id']);
  }

  Future<void> vendorPayout() async {
    double amt = widget.deliveryMode == "Doorstep Delivery"
        ? ((cart.getTotalAmount() * 100) + 50 * 100)
        : cart.getTotalAmount() * 100;
    print('Payout amt: ' + amt.toString());
    print('Payout amt: ' + (amt * 0.8).toString());

    var apiKey = 'rzp_test_QsDMPb9jLx9EbE';
    var secret = 'mZk44Ei1HtdmkqE3KxlMC5zz';
    var authn = 'Basic ' + base64Encode(utf8.encode('$apiKey:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data = {
      "account_number": "2323230076571783",
      "fund_account_id": makerAccDetails['fundAcc_id'],
      "amount": (amt * 0.8).toInt(),
      "currency": "INR",
      "mode": "IMPS",
      "purpose": "payout",
      "queue_if_low_balance": true
    };

    var url = Uri.parse('https://api.razorpay.com/v1/payouts');
    var res = await http.post(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode != 200) {
      Fluttertoast.showToast(
          msg: 'Some Error occurred while initiating payment');

      print(res.body);
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    } else
      print('success');
  }

  void openCheckout(String order_id) {
    print((cart.getTotalAmount() * 100).runtimeType);
    var options = {
      "key": "rzp_test_QsDMPb9jLx9EbE",
      'order_id': order_id,
      "amount": cart.getTotalAmount() * 100,
      "name": "Vyanjan",
      "description": "demo description",
      "prefill": {"contact": auth.currentUser!.phoneNumber},
      "external": {
        "wallets": ["paytm", "gpay", "phonepe"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAddress() async {
    await seekerRef
        .doc(auth.currentUser!.phoneNumber)
        .snapshots()
        .forEach((element) {
      setState(() {
        _addressController.text = element.get('address');
      });
    });
  }

  notifyMaker() async {
    print("Inside Notify Maker");
    try {
      var header = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAvT050EY:APA91bHVgeUHk_y68wsDJdEgnmtEgoSnlfoPKvm1jCXyxrBG0EHvgQzRlv-Yud7DzT2RfcOBeymYGidE_bPGzMmQe0uAQ-5OaP9ojp_iE6oDk-XlIBAbeJOCjZs7pkLIVKb8orv7YQUh'
      };
      Map<dynamic, dynamic> notificationBody = {
        'seekerPhoneNo': auth.currentUser!.phoneNumber,
        'seekerCart': cart.cartItem
      };
      var body = {
        'notification': {
          'body': jsonEncode(notificationBody),
          'title': 'order received',
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      };

      await http
          .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: header, body: jsonEncode(body))
          .then((value) {
        print(value.body);
        print(value.statusCode);
      });
    } catch (e) {
      print(e);
    }
  }

  generateOrder() async {
    String dt = DateTime.now().millisecondsSinceEpoch.toString();
    await seekerRealtimeRef
        .child(auth.currentUser!.phoneNumber.toString())
        .child(makerContact)
        .update({
      'makerName': preferences.getString('cartMakerItems'),
      'orderStatus': 'NA',
    }).then((value) async {
      var temp = seekerRealtimeRef.child(
          auth.currentUser!.phoneNumber.toString() +
              "/" +
              makerContact +
              "/orders/" +
              dt);

      cart.cartItem.forEach((element) {
        temp.child(element.productName.toString()).update({
          'dishName': element.productName.toString(),
          'quantity': element.quantity.toString(),
          'price': element.subTotal.toString(),
        });
      });
    });
  }

  checkOrderStatus() {
    seekerRealtimeRef
        .child(auth.currentUser!.phoneNumber.toString())
        .onChildChanged
        .listen((event) {
      event.snapshot.children.forEach((element) {
        if (element.key == 'orderStatus') {
          print(element.value);
          if (element.value == true) {
            setState(() {
              currentStep++;
            });
          } else if (element.value == false) {
            Fluttertoast.showToast(
                    msg: 'Your Order was Rejected by the Food Maker')
                .then((value) {
              Navigator.of(context).pop();
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _stepWidgets[0] = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.deliveryMode == "Takeaway" ? 'Pick up from' : 'Delivering to',
          style: TextStyle(
            color: primaryGreen,
          ),
        ),
        height10,
        widget.deliveryMode == "Takeaway"
            ? TextFormField(
                initialValue: makerAddress,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen),
                  ),
                  focusColor: primaryGreen,
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(),
                  ),
                ),
              )
            : TextField(
                controller: _addressController,
                cursorColor: primaryGreen,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen),
                  ),
                  focusColor: primaryGreen,
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(),
                  ),
                ),
              ),
        height20,
      ],
    );

    _stepWidgets[1] = CircularCountDownTimer(
      duration: 120,
      controller: _countDownController,
      width: 100,
      height: 150,
      ringColor: Colors.grey,
      ringGradient: null,
      fillColor: Colors.greenAccent,
      fillGradient: null,
      backgroundColor: primaryGreen,
      backgroundGradient: null,
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: TextStyle(
          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.MM_SS,
      isReverse: true,
      isReverseAnimation: false,
      isTimerTextShown: true,
      autoStart: false,
      onStart: () {
        notifyMaker();
        generateOrder();
        print('Countdown Started');
      },
      onComplete: () {
        print('Countdown Ended');
      },
    );

    _stepWidgets[2] = Column(
      children: [
        Row(
          children: [
            Radio(
              value: "Cash on Delivery",
              groupValue: paymentMode,
              onChanged: (value) {
                paymentMode = value.toString();
                setState(() {});
              },
              activeColor: primaryGreen,
            ),
            CustomText(text: "Cash on Delivery"),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: new Container(
                margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              "OR",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: primaryGreen),
            ),
            Expanded(
              child: new Container(
                margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: "Online Mode",
              groupValue: paymentMode,
              onChanged: (value) {
                paymentMode = value.toString();
                setState(() {});
              },
              activeColor: primaryGreen,
            ),
            CustomText(text: "Online Mode"),
          ],
        ),
        // Container(
        //   child: MaterialButton(
        //     textColor: white,
        //     color: paymentMode == "Cash on Delivery"
        //         ? Colors.grey[400]
        //         : primaryGreen,
        //     onPressed: () {
        //       if (paymentMode == "Cash on Delivery") {
        //         return null;
        //       } else {
        //         paymentMode = "";
        //         razorpayCreateOrder();
        //       }
        //     },
        //     child: Text('Pay ₹ ' + cart.getTotalAmount().toString()),
        //   ),
        // ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Confirmation',
          style: TextStyle(color: primaryGreen),
        ),
        backwardsCompatibility: true,
        iconTheme: IconThemeData(color: primaryGreen),
        elevation: 0.0,
        backgroundColor: white,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return _buildStepper(StepperType.vertical, _stepWidgets);
          },
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type, List<Widget> _stepWidgets) {
    final canCancel = currentStep < 2;
    final canContinue = paymentMode == "" ? currentStep < 2 : currentStep < 3;

    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: currentStep == 0
          ? () {
              Navigator.of(context).pop();
            }
          : canCancel
              ? () => setState(() => --currentStep)
              : null,
      onStepContinue: currentStep == 0
          ? () {
              seekerRef
                  .doc(auth.currentUser!.phoneNumber)
                  .update({'address': _addressController.value.text});
              _countDownController.start();
              setState(() => ++currentStep);
            }
          : canContinue
              ? () {
                  if (currentStep == 2) {
                    if (paymentMode == "Online Mode") {
                      razorpayCreateOrder();
                    } else {
                      Fluttertoast.showToast(msg: 'Order Placed Successfully')
                          .then((value) {
                        cart.cartItem.clear();
                        Navigator.pushNamedAndRemoveUntil(
                            context, seekerHomeRoute, (route) => false);
                      });
                    }
                  } else {
                    setState(() => ++currentStep);
                  }
                }
              : null,
      steps: [
        for (var i = 0; i < _stepWidgets.length; i++)
          _buildStep(
            title: Text(
              'Step ${i + 1}',
              style: TextStyle(color: primaryGreen),
            ),
            body: _stepWidgets[i],
            isActive: i == currentStep,
          ),
      ],
    );
  }

  Step _buildStep({
    required Widget title,
    required Widget body,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      state: StepState.disabled,
      isActive: isActive,
      content: LimitedBox(
        // maxWidth: 300,
        // maxHeight: 300,
        child: body,
      ),
    );
  }

  navigate() {
    Navigator.pushNamed(context, notificationBannerRoute);
  }
}
