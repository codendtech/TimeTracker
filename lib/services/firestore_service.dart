import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final docRef = Firestore.instance.document(path);
    await docRef.setData(data);
  }

  Stream<List<T>> collectionStream<T>(
      {@required String path, @required T builder(Map<String, dynamic> data)}) {
    final reference = Firestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot
        .map((event) => event.documents.map((e) => builder(e.data)).toList());
  }
}
