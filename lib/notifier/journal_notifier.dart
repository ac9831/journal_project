import 'package:flutter/widgets.dart';

import '../models/journal.dart';

class JournalModel with ChangeNotifier {
  final List<Journal> _journals = new List<Journal>();

  void registerJournalList() {}

  void deleteJournalList(BigInt id) {}
}
