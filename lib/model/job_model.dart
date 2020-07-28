import 'package:flutter/foundation.dart';
import 'dart:core';

class JobModel {
  JobModel(
      {@required this.name, @required this.ratePerHour, @required this.id});
  final String id;
  final String name;
  final int ratePerHour;

  factory JobModel.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    final docID = documentID;
    final name = data['name'];
    final ratePerHour = data['ratePerHour'];
    return JobModel(name: name, ratePerHour: ratePerHour, id: docID);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
