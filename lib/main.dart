import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:TimeTracker/services/authentication.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryTextTheme: TextTheme(
            headline6: TextStyle(fontFamily: 'ProductSans', fontSize: 24.0),
          ),
          textTheme: TextTheme(
            button: TextStyle(
                fontFamily: 'ProductSans', fontWeight: FontWeight.normal),
            bodyText2: TextStyle(fontFamily: 'ProductSans'),
            bodyText1: TextStyle(fontFamily: 'ProductSans'),
            subtitle1: TextStyle(fontFamily: 'ProductSans'),
            subtitle2: TextStyle(fontFamily: 'ProductSans'),
            caption: TextStyle(fontFamily: 'ProductSans'),
            headline1: TextStyle(fontFamily: 'ProductSans', fontSize: 24.0),
            headline6: TextStyle(fontFamily: 'ProductSans', fontSize: 24.0),
          ),
        ),
        home: LandingPage(),
      ),
    );
  }
}
