import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/Message.dart';
import 'package:expeditions/Models/User.dart';
import 'package:expeditions/UI/Screens/ConversationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ChatScreen extends StatefulWidget {
  static final id = 'chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late User _user;

  Future<void> getCurrentUser() async {
    final uid = _firebaseAuth.currentUser!.uid;
    _user = await User.getUser(_firestore, uid);
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

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
              .where('members', arrayContains: _firebaseAuth.currentUser!.uid)
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
                  return GestureDetector(
                      child: Card(
                        color: Theme.of(context).backgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(32)),
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(messenger.imageUrl),
                                radius: 24,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messenger.username,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      lastMessage.text,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        pushNewScreenWithRouteSettings(
                          context,
                          screen: ConversationScreen(),
                          settings: RouteSettings(
                              name: ConversationScreen.id,
                              arguments: {
                                'chat_id': document.id,
                                'current_user': _user,
                                'messenger': messenger
                              }),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      });
                },
              );
            }).toList());
          }),
    );
  }

  Future<Map<String, dynamic>> getChatInfo(DocumentSnapshot document) async {
    final members = document.get('members');
    final messengerId = members[0] == _user.uid ? members[1] : members[0];
    final messenger = await User.getUser(_firestore, messengerId);
    final message = await getLastMessage(_firestore, document.id);
    return {'messenger': messenger, 'message': message};
  }

  Future<Message> getLastMessage(
      FirebaseFirestore firestore, String chatId) async {
    final data = await firestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    final messageData = data.docs.last.data();
    final message = Message(
        sender: messageData['sender'],
        type: messageData['type'],
        text: messageData['text'],
        imageUrl: messageData['imageUrl'],
        timeStamp: messageData['timestamp'].toDate());
    return message;
  }
}
