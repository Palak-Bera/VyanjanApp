import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';
import 'package:food_app/widgets/dividers.dart';
import 'package:http/http.dart' as http;

class MakerBankDetails extends StatefulWidget {
  const MakerBankDetails({Key? key}) : super(key: key);
  @override
  _MakerBankDetailsState createState() => _MakerBankDetailsState();
}

class _MakerBankDetailsState extends State<MakerBankDetails> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _accNameController = TextEditingController();
    TextEditingController _accNumberController = TextEditingController();
    TextEditingController _ifscController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        iconTheme: IconThemeData(color: primaryGreen),
        elevation: 0.0,
        backgroundColor: white,
      ),
      body: Form(
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
            ListTile(
              title: TextFormField(
                controller: _accNameController,
                validator: (value) {
                  if (value!.isEmpty || value == null)
                    return 'IFSC Code';
                  else
                    return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Food Maker name *',
                ),
                cursorColor: primaryGreen,
              ),
              trailing: ElevatedButton(
                child: Text('Search for IFSC'),
                onPressed: () async {
                  Uri url = Uri.parse('https://ifsc.razorpay.com/KARB0000001');
                  http.Response res = await http.get(url);

                  if (res.statusCode != 200) {}
                },
              ),
            ),
            height20,
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
                hintText: 'Food Maker name *',
              ),
              cursorColor: primaryGreen,
            ),
            height20,
          ],
        ),
      ),
    );
  }
}
