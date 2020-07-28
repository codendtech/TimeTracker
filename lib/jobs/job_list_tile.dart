import 'package:TimeTracker/model/job_model.dart';
import 'package:flutter/material.dart';

class JobListTile extends StatelessWidget {
  JobListTile({@required this.job, this.onTap});
  final JobModel job;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        job.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
