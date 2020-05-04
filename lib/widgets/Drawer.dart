import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal_project/functions/auth.dart';
import 'package:journal_project/intl/messages_all.dart' as intl;
import 'package:journal_project/pages/login.dart';

class JournalDrawer extends StatefulWidget {
  JournalDrawer();

  @override
  _JournalDrawerState createState() => new _JournalDrawerState();
}

class _JournalDrawerState extends State<JournalDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new JournalDrawerContent(),
    );
  }
}

class JournalDrawerContent extends StatelessWidget {
  JournalDrawerContent();

  @override
  Widget build(BuildContext context) {
    final child = <Widget>[
      new JournalDrawerHeader(),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: null),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: null),
      new ListTile(
          leading: new Icon(Icons.settings),
          title: new Text(intl.settings()),
          onTap: null)
    ];
    child.addAll(_drawerFooter(context));
    return new ListView(children: child);
  }

  Iterable<Widget> _drawerFooter(BuildContext context) =>
      [new Divider(), new JournalDrawerFooter()];
}

class JournalDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new UserAccountsDrawerHeader(
        accountName: new Text(""),
        accountEmail: new Text(""),
        currentAccountPicture: new CircleAvatar(
          backgroundImage: new NetworkImage(""),
          backgroundColor: Colors.white,
        ),
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage('assets/images/banner.jpg'),
                fit: BoxFit.cover)));
  }
}

class JournalDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        leading: new Icon(Icons.exit_to_app),
        title: new Text(intl.logout()),
        onTap: () {
          signOutGoogle();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ),
          );
        });
  }
}
