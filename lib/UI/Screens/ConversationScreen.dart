import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/User.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  static final id = 'conversation-screen';

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final chatId = args['chat_id'];
    final messenger = args['messenger'] as User;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          messenger.username,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (streamSnapshot.hasError)
            return Center(
                child: Text('ERROR....LETS RUMMAGE AROUND TO FIX IT UP...'));
          return ListView(
            children:
                streamSnapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document.get('text')),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
