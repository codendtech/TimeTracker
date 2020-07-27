import 'package:TimeTracker/model/job_model.dart';
import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:TimeTracker/widgets/platform_exception_alert_dialog.dart';

class JobsPage extends StatelessWidget {
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

  Future<void> _createJob(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    try {
      await database.createJob(
        JobModel(name: 'Marketing', ratePerHour: 100),
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final db = Provider.of<Database>(context);
    return Builder(builder: (context) {
      return StreamBuilder<List<JobModel>>(
        stream: db.jobStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobsList = snapshot.data;
            final job = jobsList.map((e) => Text(e.name)).toList();
            return ListView(
              children: job,
            );
          }
          return Center(
            child: Text('No Jobs found!'),
          );
        },
      );
    });
  }
}
