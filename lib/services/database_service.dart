import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDocument(
      String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<DocumentSnapshot> readDocument(
      String collection, String documentId) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }

  Future<void> updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  Future<List<QueryDocumentSnapshot>> getDocumentsFromCollection(
      String collection) async {
    QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
    return querySnapshot.docs;
  }

  Future<DocumentSnapshot> getDocumentFromCollectionById(
      String collection, String documentId) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }
}
