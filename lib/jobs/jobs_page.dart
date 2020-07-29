import 'package:TimeTracker/jobs/add_jobs.dart';
import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/widgets/empty_content_widget.dart';
import 'package:TimeTracker/jobs/job_list_tile.dart';
import 'package:TimeTracker/model/job_model.dart';
import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
              return ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (context, index) => Divider(height: 0.5),
                  itemBuilder: (context, index) {
                    JobModel job = snapshot.data[index];
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      child: JobListTile(
                        job: job,
                        onTap: () {},
                      ),
                      actions: <Widget>[
                        IconSlideAction(
                            caption: 'Share',
                            icon: Icons.share,
                            color: Colors.green[900],
                            onTap: () {}),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          icon: Icons.edit,
                          color: Colors.blue,
                          onTap: () => AddJobsPage.show(context, job: job),
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          icon: Icons.delete,
                          color: Colors.red,
                          onTap: () => _deleteJob(context, job),
                        ),
                      ],
                    );
                  });
            } else {
              return EmptyScreen(
                title: 'Nothing Here.',
                message: 'Add a new item to get started.',
              );
            }
          } else {
            return EmptyScreen(
              title: 'Nothing Here.',
              message: 'Add a new item to get started.',
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

  Future<void> _deleteJob(BuildContext context, JobModel job) async {
    try {
      final db = Provider.of<Database>(context, listen: false);
      db.deleteJob(job);
    } on PlatformException catch (e) {
      PlatformAlertDialog(
        title: 'Operation Failed',
        content: e.toString(),
      ).show(context);
    }
  }
}
