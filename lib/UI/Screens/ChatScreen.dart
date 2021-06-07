import 'package:cloud_firestore/cloud_firestore.dart';
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
              final members = document.get('members');
              final userId = members[0] == _uid ? members[1] : members[0];
              return FutureBuilder(
                future: getUser(userId),
                builder: (ctx, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: LinearProgressIndicator(),
                    );
                  if (futureSnapshot.hasError) return SizedBox();
                  final messenger = futureSnapshot.data as User;
                  return ListTile(
                    title: Text(messenger.username),
                    onTap: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        screen: ConversationScreen(),
                        settings: RouteSettings(
                            name: ConversationScreen.id,
                            arguments: {
                              'chat_id': document.id,
                              'messenger': futureSnapshot.data
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

  Future<User> getUser(String uid) async {
    final userData = await _firestore.collection("users").doc(uid).get();
    final user = User(
        uid: uid, username: userData['username'], emailId: userData['email']);
    print(user.toString());
    return user;
  }
}
