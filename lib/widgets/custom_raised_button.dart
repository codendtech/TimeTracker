import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    @required this.text,
    this.backgroundColor,
    this.borderRadius,
    @required this.onPressed,
    this.fontSize,
    this.textColor,
    this.image,
    this.height,
    this.width,
    this.disabledColor,
  });

  final String text;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height, width;
  final Widget image;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: RaisedButton(
        color: backgroundColor,
        disabledColor: disabledColor,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            image != null
                ? image
                : Visibility(
                    visible: false,
                    child: Icon(Icons.send),
                    maintainSize: false,
                  ),
            Text(
              text,
              style: TextStyle(fontSize: fontSize, color: textColor),
            ),
            Visibility(
              visible: false,
              child: Icon(Icons.send),
              maintainSize: false,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(borderRadius == null
              ? Radius.circular(0.0)
              : Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
