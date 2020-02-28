import 'package:flutter/material.dart';
import 'package:journal_project/pages/login.dart';
import 'package:journal_project/pages/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:journal_project/notifier/journal_notifier.dart';
import 'package:journal_project/notifier/user_notifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  UserModel _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserModel>(context);
    checkUserInfo();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<JournalModel>.value(value: JournalModel()),
        ChangeNotifierProvider<UserModel>.value(value: UserModel()),
      ],
      child: MaterialApp(
        title: 'journal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => _user.isLogin() ? CalendarPage() : LoginPage(),
        },
      ),
    );
  }

  void checkUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString('username');

    if (userName != null) {
      setState(() {
        _user.registerUser(prefs.getString('user_uid'), userName,
            prefs.getString('user_email'), prefs.getString('user_image'), true);
      });
    }
  }
}
