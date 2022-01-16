import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';

class VarietyTag extends StatefulWidget {
  final String text;
  final Function() onTap;
  const VarietyTag({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  _VarietyTagState createState() => _VarietyTagState();
}

class _VarietyTagState extends State<VarietyTag> {
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
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          margin: EdgeInsets.only(right: 8.0),
          // padding:
          //     EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isTapped ? primaryGreen : Colors.transparent),),
              ),
          child: Text(
            '${widget.text}',
            style: TextStyle(color: primaryBlack),
          ),
        ),
      ),
    );
  }
}
