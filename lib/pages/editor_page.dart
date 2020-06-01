import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal_project/models/journal.dart';
import 'package:journal_project/notifier/journal_notifier.dart';
import 'package:journal_project/notifier/user_notifier.dart';
import 'package:journal_project/design/styling.dart';
import 'package:journal_project/transition/fab_fill_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import '../constants/common_constants.dart';

final JournalModel _journalModel = JournalModel();

class EditorPage extends StatefulWidget {
  const EditorPage({Key key, @required this.sourceRect})
      : assert(sourceRect != null),
        super(key: key);

  static Route<dynamic> route(BuildContext context, GlobalKey key) {
    final RenderBox box = key.currentContext.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) =>
          EditorPage(sourceRect: sourceRect),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  final Rect sourceRect;

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  String dateTime;
  Duration duration;
  String formatter;
  UserModel _user;
  JournalModel _journal;
  final subjectController = TextEditingController();
  final titleController = TextEditingController();
  final StreamController<Journal> _streamController =
      StreamController<Journal>();
  bool isEditButtonEnable = true;

  void getJounal() {
    if (_journal.currentlySelectedJournalWriteDate != null) {
      dateTime = DateFormat('yyyy-MM-dd')
          .format(_journal.currentlySelectedJournalWriteDate);
    } else {
      dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  @override
  void initState() {
    dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    duration = Duration(minutes: 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _journal = Provider.of<JournalModel>(context);
    _user = Provider.of<UserModel>(context);
    String fabIcon = 'assets/images/ic_edit.png';
    final _formKey = GlobalKey<FormState>();
    getJounal();

    return FabFillTransition(
      source: widget.sourceRect,
      icon: fabIcon,
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: double.infinity,
              margin: const EdgeInsets.all(4),
              color: AppTheme.nearlyWhite,
              child: Material(
                color: Colors.white,
                child: FutureBuilder(
                  future: _journal.getJournalToJsonByWriteDate(
                      journalDocumentName,
                      _journal.currentlySelectedJournalWriteDate),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        {
                          if (snapshot.hasData) {
                            if (snapshot.data.documents.length > 0) {
                              _journal.setJournal(
                                snapshot.data.documents.first.data["title"]
                                    .toString(),
                                snapshot.data.documents.first.data["subject"]
                                    .toString(),
                                (snapshot.data.documents.first
                                        .data["createDate"] as Timestamp)
                                    .toDate(),
                                (snapshot.data.documents.first.data["writeDate"]
                                        as Timestamp)
                                    .toDate(),
                                (snapshot.data.documents.first
                                        .data["changeDate"] as Timestamp)
                                    .toDate(),
                                snapshot.data.documents.first.data["uid"]
                                    .toString(),
                              );
                              subjectController.value =
                                  subjectController.value.copyWith(
                                text: snapshot
                                    .data.documents.first.data["subject"]
                                    .toString(),
                              );
                              titleController.value =
                                  titleController.value.copyWith(
                                text: snapshot
                                    .data.documents.first.data["title"]
                                    .toString(),
                              );
                            }
                          }
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _appBarRow,
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: _journalDateRow,
                                ),
                                _spacer,
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: _titleRow(),
                                ),
                                _spacer,
                                _subjectRow(),
                                _spacer,
                              ],
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    _streamController.close();
    super.dispose();
  }

  Widget get _spacer {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child:
          Container(width: double.infinity, height: 1, color: AppTheme.spacer),
    );
  }

  Widget get _appBarRow {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              _journal.clearJournal();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: AppTheme.lightText,
            ),
          ),
          Expanded(
              child:
                  Text("업무 일지 작성", style: Theme.of(context).textTheme.title)),
          IconButton(
            onPressed: isEditButtonEnable
                ? null
                : () {
                    if (_journal.currentlySelectedJournal) {
                      _journalModel.updateJournal(
                          titleController.text,
                          subjectController.text,
                          null,
                          DateTime.parse(dateTime),
                          DateTime.now(),
                          _user.getLocalUser().uid,
                          _journal.currentlyJournalName);
                    } else {
                      _journalModel.registerJouranl(
                          titleController.text,
                          subjectController.text,
                          DateTime.now(),
                          DateTime.parse(dateTime),
                          DateTime.now(),
                          _user.getLocalUser().uid);
                    }
                    _journal.clearJournal();

                    Navigator.of(context).pop();
                  },
            icon: Image.asset(
              'assets/images/ic_edit.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _journalDateRow {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              dateTime,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
            onPressed: () async {
              DateTime newDateTime = await showRoundedDatePicker(
                context: context,
                theme: ThemeData(primarySwatch: Colors.blue),
                imageHeader: AssetImage("assets/images/calendar_header.jpg"),
                description: "업무 일지 날짜를 선택해주세요.",
              );
              if (newDateTime != null) {
                setState(() {
                  dateTime = DateFormat('yyy-MM-dd').format(newDateTime);
                  isEditButtonEnable = false;
                  _journal
                      .getJournalToJsonByWriteDate(journalDocumentName,
                          _journal.currentlySelectedJournalWriteDate)
                      .then((value) {
                    if (value.documents.length > 0) {
                      _journal.currentlySelectedJournal = true;
                      _journal.currentlyJournalName =
                          value.documents.first.documentID;
                    } else {
                      _journal.currentlySelectedJournal = false;
                    }

                    isEditButtonEnable = true;
                  });
                });
              }
            },
            icon: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '제목을 입력해주세요.',
                  labelText: '제목* '),
              validator: (val) {
                if (val.isEmpty) {
                  return '제목을 입력하세요.';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: subjectController,
              minLines: 6,
              maxLines: 100,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '내용을 입력해주세요.\n내용을 입력하세요',
                labelText: '내용 *',
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return '내용을 입력하세요.';
                }
                return null;
              },
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
