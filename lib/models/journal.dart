class Journal {
  const Journal(
      this.title, this.subject, this.createDate, this.writeDate, this.uid);

  final String title;
  final String subject;
  final DateTime createDate;
  final DateTime writeDate;
  final String uid;

  toJson() {
    return {
      "title": title,
      "subject": subject,
      "createDate": createDate,
      "writeDate": writeDate,
      "uid": uid,
    };
  }
}
