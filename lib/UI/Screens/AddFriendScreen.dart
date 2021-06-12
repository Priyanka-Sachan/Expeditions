import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/User.dart';
import 'package:expeditions/UI/Screens/ConversationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AddFriendScreen extends StatefulWidget {
  static final id = 'add-friend-screen';

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {

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
          'Add Friend',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: StreamBuilder(
          stream: _firestore
              .collection("users")
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (streamSnapshot.hasError)
              return Center(
                  child: SvgPicture.asset('assets/images/bug.svg',
                      semanticsLabel: 'Bug'));
            if (streamSnapshot.data!.docs.length == 0)
              return Center(
                  child: SvgPicture.asset('assets/images/no_chats.svg',
                      semanticsLabel: 'No friends'));
            return ListView(
                children:
                streamSnapshot.data!.docs.map((DocumentSnapshot document) {
                      final user=User(uid: document.id, username: document.get('username'), emailId: document.get('email'), imageUrl: document.get('imageUrl'));
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
                                    NetworkImage(user.imageUrl),
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
                                          user.username,
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!11111');
                            // print(getChatId(_user.uid,data.id));
                            pushNewScreenWithRouteSettings(
                              context,
                              screen: ConversationScreen(),
                              settings: RouteSettings(
                                  name: ConversationScreen.id,
                                  arguments: {
                                    'chat_id': getChatId(_user.uid,user.uid),
                                    'current_user': _user,
                                    'messenger': user
                                  }),
                              withNavBar: false,
                              pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                            );
                          });
                }).toList());
          }),
    );
  }
  String getChatId(String user1,String user2){
    String chatId;
    if(user1.compareTo(user2)==-1)
      chatId=user1+'@'+user2;
    else
      chatId=user2+'@'+user1;
    print('ChatId: '+chatId);
    return chatId;
  }
}


