import 'package:flutter/material.dart';
import 'package:journal_project/widgets/Drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPage createState() => new _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  final appTitle = '업무 일지 관리';
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(title: Text(appTitle)),
          body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            _tableCalendarBody(),
          ]),
          drawer: new JournalDrawer(),
        ));
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _tableCalendarBody() {
    return TableCalendar(
      locale: 'ko_KR',
      calendarController: _calendarController,
    );
  }
}
