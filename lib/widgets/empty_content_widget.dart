import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  EmptyScreen({
    @required this.title,
    @required this.message,
  });
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 32.0, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0),
        Text(
          message,
          style: TextStyle(fontSize: 16.0, color: Colors.black87),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
