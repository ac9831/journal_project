import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:journal_project/repository/journal_repository.dart';

import '../models/journal.dart';

class JournalModel with ChangeNotifier {
  List<Journal> _journals = new List<Journal>();
  final JournalRepository _repository = new JournalRepository();
  bool _currentlySelectedJournal = false;
  DateTime _currentlySelectedJournalWriteDate;
  String _currentlyJournalName;
  Journal _journal = new Journal();

  void registerJouranl(String title, String subject, DateTime createDate,
      DateTime writeDate, DateTime changeTime, String uid) {
    _journal = Journal.setJournal(
        title, subject, createDate, writeDate, changeTime, uid);

    try {
      _repository.dataAdd(_journal.toJson());
      _journal.clear();
    } catch (e) {
      print(e);
    }
  }

  void updateJournal(
      String title,
      String subject,
      DateTime createDate,
      DateTime writeDate,
      DateTime changeTime,
      String uid,
      String documentName) {
    _journal = Journal.setJournal(
        title, subject, createDate, writeDate, changeTime, uid);

    try {
      _repository.dataUpdate(documentName, _journal.toJson());
      _journal.clear();
    } catch (e) {
      print(e);
    }
  }

  void registerJournalList() {}

  void deleteJournalList(BigInt id) {}

  bool get currentlySelectedJournal => _currentlySelectedJournal;

  DateTime get currentlySelectedJournalWriteDate =>
      _currentlySelectedJournalWriteDate;

  String get currentlyJournalName => _currentlyJournalName;

  set currentlySelectedJournal(bool value) {
    _currentlySelectedJournal = value;
    notifyListeners();
  }

  set currentlySelectedJournalWriteDate(DateTime val) {
    _currentlySelectedJournalWriteDate = val;
    notifyListeners();
  }

  set currentlyJournalName(String value) {
    _currentlyJournalName = value;
    notifyListeners();
  }

  Future<List<Journal>> getJounalToJsonByUid(
      String documentName, String uid) async {
    _journals = new List<Journal>();

    if (uid == null) return _journals;

    QuerySnapshot snapshots = await _repository.dataGetByUid(documentName, uid);

    snapshots.documents.forEach((value) {
      _journals.add(Journal.setJournalToJson(value));
    });

    return _journals.toList();
  }

  Future<QuerySnapshot> getJournalToJsonByWriteDate(
      String documentName, DateTime writeDate) {
    DateTime _startDate =
        new DateTime(writeDate.year, writeDate.month, writeDate.day, 0, 0);
    DateTime _endDate =
        new DateTime(writeDate.year, writeDate.month, writeDate.day, 23, 59);

    return _repository.dataGetByWriteDate(documentName, _startDate, _endDate);
  }

  Journal getJournal() {
    return _journal;
  }

  void setJournalWriteDate(DateTime wirteDate) {
    _journal.writeDate = wirteDate;
  }

  void setJournal(String title, String subject, DateTime createDate,
      DateTime writeDate, DateTime changeDate, String uid) {
    _journal.title = title;
    _journal.subject = subject;
    _journal.createDate = createDate;
    _journal.writeDate = writeDate;
    _journal.changeDate = changeDate;
    _journal.uid = uid;
  }

  void clearJournal() {
    _journal.clear();
  }
}
