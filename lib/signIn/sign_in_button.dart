import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color backGroundColor,
    Color textColor,
    double fontSize,
    double borderRadius,
    double height,
    double width,
    Widget image,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
            text: text,
            fontSize: fontSize,
            textColor: textColor,
            backgroundColor: backGroundColor,
            borderRadius: borderRadius,
            height: height,
            width: width,
            image: image,
            onPressed: onPressed);
}
