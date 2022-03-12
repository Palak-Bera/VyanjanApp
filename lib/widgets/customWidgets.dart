import 'package:flutter/material.dart';
import 'package:food_app/resources/colors.dart';

///Custom AppBar
class CustomAppbar extends AppBar {
  /// Function as an argument which will be executed when [leading back button] is pressed
  final Function() onBackPressed;

  CustomAppbar({required this.onBackPressed})
      : super(
          leading: backButton(() => onBackPressed),
          backgroundColor: white,
          elevation: 0.0,
        );
}

/// Clickable Text Widget
/// Custom text widget which can also be used as a Button with onClick events
class ClickText extends InkWell {
  final Function() onTap;
  final String text;

  ClickText({
    required this.onTap,
    required this.text,
  }) : super(
            onTap: onTap,
            child: CustomText(
              text: text,
              color: primaryGreen,
              fontWeight: FontWeight.bold,
            ));
}

/// Customized Text widget
class CustomText extends StatelessWidget {
  final String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  bool? softwrap;

  CustomText(
      {Key? key,
      required this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.softwrap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Text(
        this.text,
        softWrap: this.softwrap ?? false,
        style: TextStyle(
          color: this.color ?? primaryBlack,
          fontSize: this.fontSize ?? 15.0,
          fontWeight: this.fontWeight ?? FontWeight.normal,
        ),
      ),
    );
  }
}

/// Back button for AppBar
IconButton backButton(Function()? onpressed) => IconButton(
    onPressed: onpressed!,
    icon: Icon(
      Icons.arrow_back,
      color: primaryGreen,
    ));

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onpressed;
  CustomButton({Key? key, required this.text, required this.onpressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        color: primaryGreen,
        onPressed: this.onpressed,
        child: CustomText(
          text: this.text,
          fontWeight: FontWeight.bold,
          color: white,
        ));
  }
}
