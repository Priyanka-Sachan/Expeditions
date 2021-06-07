import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/UI/Widgets/AuthForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatelessWidget {
  static final id = 'auth-screen';

  final _auth = FirebaseAuth.instance;

  void _signUp(String username, String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({'username': username, 'email': email});
    } on PlatformException catch (e) {
      String message = 'An error occurred, please check your credentials.';
      if (e.message != null) message = e.message!;
      print(message);
    }
  }

  void _signIn(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (e) {
      String message = 'An error occurred, please check your credentials.';
      if (e.message != null) message = e.message!;
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    Icons.language,
                    color: Colors.grey.shade400,
                    size: 100,
                  ),
                  Text(
                    'EXPEDITIONS',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  )
                ],
              ),
              AuthForm(
                signUp: _signUp,
                signIn: _signIn,
              )
            ],
          ),
        ),
      ),
    );
  }
}
