import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';

class Tag extends StatefulWidget {
  final String text;
  final Function() onTap;
  const Tag({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        widget.onTap();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.0),
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: isTapped ? primaryGreen : primaryBlack),
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          '${widget.text}',
          style: TextStyle(color: primaryBlack),
        ),
      ),
    );
  }
}

