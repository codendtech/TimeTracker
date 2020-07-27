import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';

class FormSubmitButton extends CustomRaisedButton {
  final String text;
  final VoidCallback onPressed;
  final Color backGroundColor;
  final double borderRadius;
  final Color textColor;
  final double height;
  final double width;
  final double fontSize;
  final Color disabledColor;

  FormSubmitButton({
    @required this.text,
    @required this.onPressed,
    this.backGroundColor,
    this.borderRadius,
    this.textColor,
    this.height,
    this.width,
    this.fontSize,
    this.disabledColor,
  }) : super(
          text: text,
          backgroundColor: backGroundColor,
          borderRadius: borderRadius,
          textColor: textColor,
          height: height,
          width: width,
          onPressed: onPressed,
          fontSize: fontSize,
          disabledColor: disabledColor,
        );
}
