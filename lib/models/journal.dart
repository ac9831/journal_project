class Journal {
  const Journal(
      this.title, this.subject, this.user, this.createDate, this.writeDate);

  final String title;
  final String subject;
  final DateTime createDate;
  final DateTime writeDate;
  final String user;
}
