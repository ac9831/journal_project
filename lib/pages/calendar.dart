import 'package:flutter/material.dart';
import 'package:journal_project/widgets/Drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:journal_project/design/styling.dart';
import 'package:provider/provider.dart';
import 'package:journal_project/models/email_model.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:journal_project/pages/editor_page.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

const PrimaryColor = const Color(0xFF151026);

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPage createState() => new _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> with TickerProviderStateMixin {
  final appTitle = '업무 일지 관리';
  CalendarController _calendarController;
  AnimationController _animationController;
  Map<DateTime, List> _events;
  List _selectedEvents;
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _calendarController = CalendarController();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
            appBar: AppBar(
              title: Text(appTitle),
              backgroundColor: PrimaryColor,
            ),
            body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              _buildTableCalendarWithBuilders(),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),
            ]),
            drawer: new JournalDrawer(),
            bottomNavigationBar: _bottomNavigation,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _fab,
          )),
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Widget get _bottomNavigation {
    final Animation<Offset> slideIn =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: ModalRoute.of(context).animation, curve: Curves.ease));
    final Animation<Offset> slideOut =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
            CurvedAnimation(
                parent: ModalRoute.of(context).secondaryAnimation,
                curve: Curves.fastOutSlowIn));

    return SlideTransition(
      position: slideIn,
      child: SlideTransition(
        position: slideOut,
        child: BottomAppBar(
          color: AppTheme.grey,
          shape:
              AutomaticNotchedShape(RoundedRectangleBorder(), CircleBorder()),
          notchMargin: 8,
          child: SizedBox(
            height: 48,
            child: Row(
              children: <Widget>[
                IconButton(
                  iconSize: 48,
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 21,
                        height: 21,
                      ),
                    ],
                  ),
                  onPressed: () => print('Tap!'),
                ),
                Spacer(),
                _actionItems,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _actionItems {
    return Consumer<EmailModel>(
      builder: (BuildContext context, EmailModel model, Widget child) {
        final bool showSecond = model.currentlySelectedEmailId >= 0;

        return AnimatedCrossFade(
          firstCurve: Curves.fastOutSlowIn,
          secondCurve: Curves.fastOutSlowIn,
          sizeCurve: Curves.fastOutSlowIn,
          firstChild: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => print('Tap!'),
          ),
          secondChild: showSecond
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/images/ic_important.png',
                          width: 28),
                      onPressed: () => print('Tap!'),
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/ic_more.png', width: 28),
                      onPressed: () => print('Tap!'),
                    ),
                  ],
                )
              : const SizedBox(),
          crossFadeState:
              showSecond ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 450),
        );
      },
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'ko_kr',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  Widget get _fab {
    return AnimatedBuilder(
      animation: ModalRoute.of(context).animation,
      child: Consumer<EmailModel>(
        builder: (BuildContext context, EmailModel model, Widget child) {
          final bool showEditAsAction = model.currentlySelectedEmailId == -1;

          return FloatingActionButton(
            key: _fabKey,
            child: SizedBox(
              width: 24,
              height: 24,
              child: FlareActor(
                'assets/flare/edit_reply.flr',
                animation: showEditAsAction ? 'ReplyToEdit' : 'EditToReply',
              ),
            ),
            backgroundColor: AppTheme.orange,
            onPressed: () => Navigator.of(context).push<void>(
              EditorPage.route(context, _fabKey),
            ),
          );
        },
      ),
      builder: (BuildContext context, Widget fab) {
        final Animation<double> animation = ModalRoute.of(context).animation;
        return SizedBox(
          width: 54 * animation.value,
          height: 54 * animation.value,
          child: fab,
        );
      },
    );
  }

  Future<bool> _willPopCallback() async {
    if (_navigatorKey.currentState.canPop()) {
      _navigatorKey.currentState.pop();
      Provider.of<EmailModel>(context).currentlySelectedEmailId = -1;
      return false;
    }
    return true;
  }
}
