import 'package:TimeTracker/model/job_model.dart';
import 'package:TimeTracker/services/api_path.dart';
import 'package:TimeTracker/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class Database {
  Future<void> createJob(JobModel job);
  Stream<List<JobModel>> jobStream();
}

class FireStoreDatabase extends Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _fireStoreService = FireStoreService.instance;

  @override
  Future<void> createJob(JobModel job) async => await _fireStoreService.setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  @override
  Stream<List<JobModel>> jobStream() => _fireStoreService.collectionStream(
      path: APIPath.jobsPath(uid), builder: (data) => JobModel.fromMap(data));
}
