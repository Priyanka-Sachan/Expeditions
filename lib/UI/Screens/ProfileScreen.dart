import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static final id = 'profile-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Container(),
    );
  }
}
