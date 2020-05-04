import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  String title;
  String subject;
  DateTime createDate;
  DateTime writeDate;
  DateTime changeDate;
  String uid;

  toJson() {
    return {
      "title": title,
      "subject": subject,
      "createDate": createDate,
      "writeDate": writeDate,
      "changeDate": changeDate,
      "uid": uid,
    };
  }

  Journal();

  Journal.setJournalToJson(DocumentSnapshot snapshot) {
    title = snapshot.data["title"];
    subject = snapshot.data["subject"];
    createDate = (snapshot.data["createDate"] as Timestamp).toDate();
    writeDate = (snapshot.data["writeDate"] as Timestamp).toDate();
    changeDate = (snapshot.data["changeDate"] as Timestamp).toDate();
    uid = snapshot.data["uid"];
  }

  Journal.setJournal(String title, String subject, DateTime createDate,
      DateTime writeDate, DateTime changeDate, String uid) {
    this.title = title;
    this.subject = subject;
    this.createDate = createDate;
    this.writeDate = writeDate;
    this.changeDate = changeDate;
    this.uid = uid;
  }

  void clear() {
    this.title = null;
    this.subject = null;
    this.createDate = null;
    this.writeDate = null;
    this.changeDate = null;
    this.uid = null;
  }
}
