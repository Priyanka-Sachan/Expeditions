import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static final id = 'chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: StreamBuilder(
        stream: _firestore
            .collection("chat")
            .doc("5KWsATnAdlYocinQvHls")
            .collection("messages")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (streamSnapshot.hasError)
            return Text('ERROR....LETS RUMMAGE AROUND TO FIX IT UP...');
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
