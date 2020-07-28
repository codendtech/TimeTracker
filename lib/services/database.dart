import 'package:TimeTracker/model/job_model.dart';
import 'package:TimeTracker/services/api_path.dart';
import 'package:TimeTracker/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

abstract class Database {
  Future<void> setJob(JobModel job);
  Stream<List<JobModel>> jobStream();
}

class FireStoreDatabase extends Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _fireStoreService = FireStoreService.instance;

  @override
  Future<void> setJob(JobModel job) async => await _fireStoreService.setData(
        path: APIPath.createJobPath(uid, job.id),
        data: job.toMap(),
      );

  @override
  Stream<List<JobModel>> jobStream() => _fireStoreService.collectionStream(
      path: APIPath.readJobsPath(uid),
      builder: (data, documentID) => JobModel.fromMap(data, documentID));
}
