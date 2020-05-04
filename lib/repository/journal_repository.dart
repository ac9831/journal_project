import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _store = Firestore.instance;

class JournalRepository {
  void dataAdd(Map<String, dynamic> data) {
    _store.collection("journals").add(data);
  }

  Future<QuerySnapshot> dataGetByUid(String documentName, String uid) async {
    return await _store
        .collection(documentName)
        .where("uid", isEqualTo: uid)
        .getDocuments();
  }

  bool dataDelete(String documentName) {
    _store.collection("journals").document(documentName).delete();
    return true;
  }

  bool dataUpdate(String documentName, Map<String, dynamic> data) {
    _store.collection("journals").document(documentName).updateData(data);
    return true;
  }

  Future<QuerySnapshot> dataGetByWriteDate(
      String documentName, DateTime _startDate, DateTime _endDate) {
    return _store
        .collection(documentName)
        .where('writeDate', isGreaterThanOrEqualTo: _startDate)
        .where('writeDate', isLessThanOrEqualTo: _endDate)
        .getDocuments();
  }
}
