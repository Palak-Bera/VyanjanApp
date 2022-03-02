import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:crypto/crypto.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/features/FoodSeeker/Home/seekerHome.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/routes/constants.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class SeekerCheckout extends StatefulWidget {
  @override
  _SeekerCheckoutState createState() => _SeekerCheckoutState();
}

class _SeekerCheckoutState extends State<SeekerCheckout> {
  TextEditingController _addressController = TextEditingController();
  CountDownController _countDownController = CountDownController();
  List<Widget> _stepWidgets = [Text('a'), Text('b'), Text('c')];

  late String makerContact;

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
    makerRef
        .where('name', isEqualTo: preferences.getString('cartMakerItems'))
        .snapshots()
        .forEach((element) {
      element.docs.forEach((element) {
        makerContact = element.get('phoneNo');
        makerAccDetails = element.get('accountDetails');
        token = element.get('deviceToken');
      });
    });
  }

  Future<void> onPaymentSuccess(PaymentSuccessResponse response) async {
    await vendorPayout();
    Fluttertoast.showToast(msg: 'Success').then((value) {
      notifyMaker();
      cart.cartItem.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, seekerHomeRoute, (route) => false);
    });
  }

  void onPaymentError() {
    Fluttertoast.showToast(msg: 'Error');
  }

  void onExternalWallet() {
    Fluttertoast.showToast(msg: 'External Wallet');
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  createOrder() async {
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
      "amount": cart.getTotalAmount() * 100,
      "currency": "INR",
      "receipt": receipt_id
    };

    var url = Uri.parse('https://api.razorpay.com/v1/orders');
    var res = await http.post(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode != 200) {
      Fluttertoast.showToast(
          msg: 'Some Error occured while initiating payment');
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    } else {
      result = jsonDecode(res.body);
      openCheckout(result['id']);
    }
    print(result['id']);
  }

  Future<void> vendorPayout() async {
    double amt = cart.getTotalAmount() * 100;

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
      "amount": amt.toInt(),
      "currency": "INR",
      "mode": "IMPS",
      "purpose": "payout",
      "queue_if_low_balance": true
    };

    var url = Uri.parse('https://api.razorpay.com/v1/payouts');
    var res = await http.post(url, headers: headers, body: jsonEncode(data));
    if (res.statusCode != 200) {
      Fluttertoast.showToast(
          msg: 'Some Error occured while initiating payment');

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
            'key=AAAAvT050EY:APA91bETR20ptdC3RUQARePGzzAK7C2vA-E6zioVllqfrQXG-LaAAPF0r-tGB7DpyBnXQfbqyaUgP5ZnTMntC7AVRbKAZbEXyLneCgkQT6K6eVCDCjj7NUQTpngwUldx3V5zxRCD4Vag'
      };

      var body = {
        'notification': {'body': 'Test Body', 'title': 'order received'},
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

  @override
  Widget build(BuildContext context) {
    _stepWidgets[0] = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivering to',
          style: TextStyle(
            color: primaryGreen,
          ),
        ),
        height10,
        TextField(
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
        print('Countdown Started');
      },
      onComplete: () {
        print('Countdown Ended');
      },
    );

    _stepWidgets[2] = Container(
      child: ElevatedButton(
        onPressed: () {
          createOrder();
        },
        child: Text('Pay ₹ ' + cart.getTotalAmount().toString()),
      ),
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
    final canContinue = currentStep < 2;

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
              _countDownController.start();
              setState(() => ++currentStep);
            }
          : canContinue
              ? () => setState(() => ++currentStep)
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
      subtitle: Text('Subtitle'),
      state: StepState.disabled,
      isActive: isActive,
      content: LimitedBox(
        // maxWidth: 300,
        // maxHeight: 300,
        child: body,
      ),
    );
  }
}
