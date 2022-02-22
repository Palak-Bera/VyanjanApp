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

  late String makerEmail = 'xyz@gmail.com', makerContact;

  int currentStep = 0;

  late Razorpay razorpay;
  late var result;

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

  getMakerDetails() async {
    makerRef
        .where('name', isEqualTo: preferences.getString('cartMakerItems'))
        .snapshots()
        .forEach((element) {
      element.docs.forEach((element) {
        makerContact = element.get('phoneNo');
      });
    });
  }

  Future<void> onPaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: 'Success');

    // var data = {
    //   "name": preferences.getString('cartMakerItems'),
    //   'contact': makerContact,
    //   "email": makerEmail
    // };

    // var url = Uri.parse('https://vyanjan.000webhostapp.com/createContact.php');
    // var res = await http.post(url, body: data);
    // if (res.statusCode != 200) {
    //   Fluttertoast.showToast(
    //       msg: 'Some Error occurred while initiating payment');
    //   throw Exception('http.post error: statusCode= ${res.statusCode}');
    // }
    // print('result: ' + res.body.toString());
  }

  void onPaymentError() {
    Fluttertoast.showToast(msg: 'Error');
  }

  void onExternalWallet() {
    Fluttertoast.showToast(msg: 'External Wallet');
  }

  void openCheckout(String order_id) {
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
    final canContinue = currentStep < 3;

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
        // _buildStep(
        //   title: Text('Error'),
        //   state: StepState.error,
        // ),
        // _buildStep(
        //   title: Text('Disabled'),
        //   state: StepState.disabled,
        // )
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
