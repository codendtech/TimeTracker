import 'package:flutter/foundation.dart';
import 'dart:core';

class JobModel {
  JobModel({@required this.name, @required this.ratePerHour});
  final String name;
  final int ratePerHour;

  factory JobModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final name = data['name'];
    final ratePerHour = data['ratePerHour'];
    return JobModel(name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
