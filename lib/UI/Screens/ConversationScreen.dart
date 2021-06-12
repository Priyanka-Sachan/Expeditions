import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/Message.dart';
import 'package:expeditions/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  static final id = 'conversation-screen';

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _sendMessageController = TextEditingController();

  @override
  void dispose() {
    _sendMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final chatId = args['chat_id'] as String;
    final currentUser = args['current_user'] as User;
    final messenger = args['messenger'] as User;
    final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');

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
            .orderBy('timestamp', descending: true)
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
          final messages = streamSnapshot.data!.docs;
          // if (messages.length == 0)
          //   return Center(
          //       child: SvgPicture.asset('assets/images/say_hi.svg',
          //           semanticsLabel: 'Empty conversation'));
          return Column(children: [
            Expanded(
              child: (messages.length == 0)?
              Center(
                  child: SvgPicture.asset('assets/images/say_hi.svg',
                      semanticsLabel: 'Empty conversation')):
              ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, i) {
                    final message = Message(
                        sender: messages[i].get('sender'),
                        type: messages[i].get('type'),
                        text: messages[i].get('text'),
                        imageUrl: messages[i].get('imageUrl'),
                        timeStamp: messages[i].get('timestamp').toDate());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: message.sender == currentUser.uid
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          message.sender != currentUser.uid
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(messenger.imageUrl),
                                  radius: 24,
                                )
                              : SizedBox(),
                          Column(
                            crossAxisAlignment:
                                message.sender == currentUser.uid
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.5),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      message.text,
                                      softWrap: true,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              Text(dateFormat.format(message.timeStamp))
                            ],
                          ),
                          message.sender == currentUser.uid
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(currentUser.imageUrl),
                                  radius: 24,
                                )
                              : SizedBox(),
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sendMessageController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if(messages.length==0)
                          setChat(chatId,currentUser.uid,messenger.uid);
                        sendMessage(chatId, currentUser.uid);
                      },
                      icon: Icon(
                        Icons.check_circle,
                        size: 32,
                      ))
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }

  void setChat(String chatId, String user1,String user2){
    _firestore.collection("chat").doc(chatId).set({'members':[user1,user2]});
  }

  void sendMessage(String chatId, String senderId) {
    if (_sendMessageController.text.trim().isNotEmpty)
      _firestore.collection("chat").doc(chatId).collection("messages").add({
        'sender': senderId,
        'type': 0,
        'text': _sendMessageController.text.trim(),
        'imageUrl': '',
        'timestamp': DateTime.now()
      });
    _sendMessageController.clear();
  }
}
