import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/Message.dart';
import 'package:expeditions/Models/User.dart';
import 'package:flutter/material.dart';

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
            .orderBy('timestamp')
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
          final messages = streamSnapshot.data!.docs;
          return Column(children: [
            Expanded(
              child: ListView.builder(
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
                      child: Column(
                        crossAxisAlignment: message.sender == messenger.uid
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                message.text,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          Text(message.timeStamp.toLocal().toString()),
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
                        sendMessage(chatId);
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

  void sendMessage(String chatId) {
    if (_sendMessageController.text.trim().isNotEmpty)
      _firestore.collection("chat").doc(chatId).collection("messages").add({
        'sender': 'fOgyiBZLcWU4lITRE4PAlkDO2lC3',
        'type': 0,
        'text': _sendMessageController.text.trim(),
        'imageUrl': '',
        'timestamp': DateTime.now()
      });
    _sendMessageController.clear();
  }
}
