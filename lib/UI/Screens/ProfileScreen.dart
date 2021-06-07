import 'package:firebase_auth/firebase_auth.dart';
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
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: [Icon(Icons.exit_to_app_rounded), Text('Log Out')],
                ),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Container(),
    );
  }
}
