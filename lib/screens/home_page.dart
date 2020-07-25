import 'package:TimeTracker/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    bool didRequested = await PlatformDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelButtonText: 'Cancel',
      defaultActionText: 'OK',
    ).show(context);

    if (didRequested == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Builder(
      builder: (context) => Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 36.0, color: Colors.black87),
        ),
      ),
    );
  }
}
