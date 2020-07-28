import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();

  Future<void> setData(
      {@required String path, Map<String, dynamic> data}) async {
    final docRef = Firestore.instance.document(path);
    await docRef.setData(data);
  }

  Future<void> deleteData({@required String path}) async {
    final docRef = Firestore.instance.document(path);
    await docRef.delete();
    print(path);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot.map((event) =>
        event.documents.map((e) => builder(e.data, e.documentID)).toList());
  }
}
