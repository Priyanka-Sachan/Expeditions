import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static final id = 'chat-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Chats',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Container(),
    );
  }
}
