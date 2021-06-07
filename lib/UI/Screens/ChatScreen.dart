import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/Message.dart';
import 'package:expeditions/Models/User.dart';
import 'package:expeditions/UI/Screens/ConversationScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ChatScreen extends StatefulWidget {
  static final id = 'chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _uid = 'fOgyiBZLcWU4lITRE4PAlkDO2lC3';

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
              .where('members', arrayContains: _uid)
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
              return FutureBuilder(
                future: getChatInfo(document),
                builder: (ctx, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: LinearProgressIndicator(),
                    );
                  if (futureSnapshot.hasError) return SizedBox();
                  final data = futureSnapshot.data as Map<String, dynamic>;
                  final messenger = data['messenger'] as User;
                  final lastMessage = data['message'] as Message;
                  return ListTile(
                    title: Text(messenger.username),
                    subtitle: Text(lastMessage.text),
                    onTap: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        screen: ConversationScreen(),
                        settings: RouteSettings(
                            name: ConversationScreen.id,
                            arguments: {
                              'chat_id': document.id,
                              'messenger': messenger
                            }),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  );
                },
              );
            }).toList());
          }),
    );
  }

  Future<Map<String, dynamic>> getChatInfo(DocumentSnapshot document) async {
    final members = document.get('members');
    final messengerId = members[0] == _uid ? members[1] : members[0];
    final messenger = await getUser(messengerId);
    final message = await getLastMessage(document.id);
    return {'messenger': messenger, 'message': message};
  }

  Future<User> getUser(String uid) async {
    final userData = await _firestore.collection("users").doc(uid).get();
    final user = User(
        uid: uid, username: userData['username'], emailId: userData['email']);
    return user;
  }

  Future<Message> getLastMessage(String chatId) async {
    final data = await _firestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp')
        .limit(1)
        .get();
    final messageData = data.docs.last.data();
    final message = Message(
        sender: messageData['sender'],
        type: messageData['type'],
        text: messageData['text'],
        imageUrl: messageData['imageUrl'].toString(),
        timeStamp: messageData['timestamp'].toString());
    return message;
  }
}
