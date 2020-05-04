import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final Firestore _store = Firestore.instance;
  Future<QuerySnapshot> currentDocument;

  bool dataAdd(String documentName, Map<String, dynamic> data) {
    _store.collection("users").document(documentName).setData(data);
    return true;
  }

  DocumentSnapshot dataGet(String documentName) {
    _store
        .collection("users")
        .document(documentName)
        .get()
        .then((DocumentSnapshot ds) {
      return ds;
    }).catchError((e) {
      print("$e");
    });

    return null;
  }

  bool dataDelete(String documentName) {
    _store.collection("users").document(documentName).delete();
    return true;
  }

  bool dataUpdate(String documentName, Map<String, dynamic> data) {
    _store.collection("users").document(documentName).updateData(data);
    return true;
  }

  bool isNotExistUser(String email) {
    _store
        .collection("users")
        .where("email?", isEqualTo: email)
        .getDocuments()
        .then((doc) {
      return doc.documents.length > 0 ? false : true;
    });

    return true;
  }

  Future<bool> isExistUserByUid(String uid) async {
    QuerySnapshot snapshot = await _store
        .collection("users")
        .where("uid", isEqualTo: uid)
        .getDocuments();
    int length = snapshot.documents.length;
    return length > 0 ? true : false;
  }
}
