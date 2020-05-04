import 'package:flutter/material.dart';
import 'package:journal_project/functions/auth.dart';
import 'package:journal_project/pages/login.dart';
import 'package:journal_project/pages/calendar.dart';
import 'package:provider/provider.dart';
import 'package:journal_project/notifier/journal_notifier.dart';
import 'package:journal_project/notifier/user_notifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUserInfo(),
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          String initialRoute = '/';
          if (snapshot.data.getLocalUser() != null) {
            initialRoute = '/calendar';
          } else {
            initialRoute = '/login';
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<JournalModel>.value(value: JournalModel()),
              ChangeNotifierProvider<UserModel>.value(value: snapshot.data),
            ],
            child: MaterialApp(
              title: 'journal',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: initialRoute,
              routes: {
                '/login': (context) => LoginPage(),
                '/calendar': (context) => CalendarPage(),
              },
            ),
          );
        }
      },
    );
  }
}
