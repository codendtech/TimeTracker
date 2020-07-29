import 'package:flutter/foundation.dart';

class EntryModel {
  EntryModel({
    @required this.id,
    @required this.jobId,
    @required this.start,
    @required this.end,
    this.comment,
  });
  final String id;
  final String jobId;
  final DateTime start;
  final DateTime end;
  final String comment;

  factory EntryModel.fromMap(Map<String, dynamic> value, String id) {
    final int startMilliSecond = value['start'];
    final int endMillisecond = value['end'];
    return EntryModel(
      id: id,
      jobId: value['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliSecond),
      end: DateTime.fromMillisecondsSinceEpoch(endMillisecond),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;
}
