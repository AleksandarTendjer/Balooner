import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late FirebaseFirestore _firestore;

  DatabaseService() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<DocumentReference> createDocument(
      String collection, Map<String, dynamic> data) async {
    DocumentReference documentReference =
        await _firestore.collection(collection).add(data);
    return documentReference;
  }

  Future<DocumentSnapshot> readDocument(
      String collection, String documentId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(collection).doc(documentId).get();
    return documentSnapshot;
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
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(collection).doc(documentId).get();
    return documentSnapshot;
  }

  Future<QueryDocumentSnapshot?> findDocumentInCollectionByField(
      String collectionName, String fieldName, dynamic value) async {
    final documents = await getDocumentsFromCollection(collectionName);
    QueryDocumentSnapshot? targetDocument;

    for (var document in documents) {
      final Map<String, dynamic>? documentData =
          document.data() as Map<String, dynamic>?;
      if (documentData != null && documentData[fieldName] == value) {
        targetDocument = document;
        break;
      }
    }
    if (targetDocument != null) {
      return targetDocument;
    } else {
      print(
          "Document with the specified field '$fieldName' and value '$value' not found in the collection '$collectionName'.");
    }
  }
}
