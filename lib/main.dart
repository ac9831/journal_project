import 'package:flutter/material.dart';
import 'package:journal_project/pages/login.dart';
import 'package:journal_project/pages/calendar.dart';
import 'package:journal_project/functions/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:journal_project/models/email_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  bool isLogin;

  @override
  void initState() {
    isLogin = false;
    super.initState();
    checkUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmailModel>.value(value: EmailModel()),
      ],
      child: MaterialApp(
        title: 'journal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => isLogin ? CalendarPage() : LoginPage(),
          '/login': (context) => LoginPage(),
        },
      ),
    );
  }

  void checkUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString('username');
    if (userName != null) {
      setState(() {
        isLogin = true;
        name = userName;
        email = prefs.getString('useremail');
        imageUrl = prefs.getString('userimage');
      });
    }
  }
}
