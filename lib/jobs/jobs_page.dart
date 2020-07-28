import 'package:TimeTracker/jobs/add_jobs.dart';
import 'package:TimeTracker/jobs/job_list_tile.dart';
import 'package:TimeTracker/model/job_model.dart';
import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
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
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddJobsPage.show(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Builder(builder: (context) {
      return StreamBuilder<List<JobModel>>(
        stream: db.jobStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data.length != 0) {
              final jobsList = snapshot.data;
              final job = jobsList
                  .map(
                    (e) => JobListTile(
                      job: e,
                      onTap: () => AddJobsPage.show(context, job: e),
                    ),
                  )
                  .toList();
              return ListView(
                children: job,
              );
            } else {
              return Center(
                child: Text('No Jobs found!'),
              );
            }
          } else {
            return Center(
              child: Text('No Jobs found!'),
            );
          }
        },
      );
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    bool didRequested = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelButtonText: 'Cancel',
      defaultActionText: 'OK',
    ).show(context);

    if (didRequested == true) {
      _signOut(context);
    }
  }
}
