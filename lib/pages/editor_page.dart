import 'package:flutter/material.dart';
import 'package:journal_project/models/journal.dart';
import 'package:provider/provider.dart';
import 'package:journal_project/notifier/journal_notifier.dart';
import 'package:journal_project/design/styling.dart';
import 'package:journal_project/transition/fab_fill_transition.dart';

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
  String _senderEmail = 'from.jennifer@example.com';
  String _subject = '';
  String _recipient = 'Recipient';
  String _recipientAvatar = 'avatar.png';

  @override
  Widget build(BuildContext context) {
    String fabIcon = 'assets/images/ic_edit.png';

    return FabFillTransition(
      source: widget.sourceRect,
      icon: fabIcon,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: double.infinity,
            margin: const EdgeInsets.all(4),
            color: AppTheme.nearlyWhite,
            child: Material(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _subjectRow,
                    _spacer,
                    _senderAddressRow,
                    _spacer,
                    _recipientRow,
                    _spacer,
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        minLines: 6,
                        maxLines: 20,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Message'),
                        autofocus: false,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _spacer {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child:
          Container(width: double.infinity, height: 1, color: AppTheme.spacer),
    );
  }

  Widget get _subjectRow {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: AppTheme.lightText,
            ),
          ),
          Expanded(
              child: Text(_subject, style: Theme.of(context).textTheme.title)),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Image.asset(
              'assets/images/ic_send.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _senderAddressRow {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (String email) {
        setState(() {
          _senderEmail = email;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'from.jennifer@example.com',
          child: Text('from.jennifer@example.com',
              style: Theme.of(context).textTheme.subtitle),
        ),
        PopupMenuItem<String>(
          value: 'hey@phantom.works',
          child: Text('hey@phantom.works',
              style: Theme.of(context).textTheme.subtitle),
        ),
      ],
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12, top: 16, right: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Text(_senderEmail,
                    style: Theme.of(context).textTheme.subtitle)),
            const Icon(
              Icons.arrow_drop_down,
              color: AppTheme.lightText,
              size: 28,
            )
          ],
        ),
      ),
    );
  }

  Widget get _recipientRow {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Wrap(
              children: <Widget>[
                Chip(
                    backgroundColor: AppTheme.chipBackground,
                    padding: EdgeInsets.zero,
                    avatar: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/$_recipientAvatar'),
                    ),
                    label: Text(_recipient,
                        style: Theme.of(context).textTheme.subtitle)),
              ],
            ),
          ),
          const Icon(
            Icons.add_circle_outline,
            color: AppTheme.lightText,
          )
        ],
      ),
    );
  }
}
