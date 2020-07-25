import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/widgets/email_sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            shadowColor: Colors.grey,
            elevation: 5.0,
          ),
        ),
      ),
    );
  }
}
