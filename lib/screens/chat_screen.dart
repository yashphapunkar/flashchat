import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }
  

  void messagesStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
         print(message.data());
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
               _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Color(0xFF37474F),
      ),
      backgroundColor: Color(0xFFD4D4D4),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(backgroundColor: Colors.grey,),
                  );
                }

                  final messages = snapshot.data?.docs.reversed;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages!) {
                    var data = message.data() as Map;
                    final messageText = data['text'];
                    final messageSender = data['sender'];
                    final messageTime = data['time'];
                    final currentUser = loggedInUser.email;
                    final messageWidget = MessageBubble(
                       messageSender,
                      messageText,
                      currentUser == messageSender,
                    );
                    messageWidgets.add(messageWidget);
                  }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    children: messageWidgets,
                  ),
                );
              }
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: messageTextController,
                      onChanged: (value) {
                      messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                     _firestore.collection('messages').add({
                       'text': messageText,
                       'sender': loggedInUser.email,
                       'time' : FieldValue.serverTimestamp(),
                     });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  MessageBubble(this.sender, this.text, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              sender,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[850]
              ),
          ),
          Material(
          borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30) ) : BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30) ),
          elevation: 12,
          color:  isMe ? Color(0xFF546E7A) : Color(0xFFB0BEC5),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

