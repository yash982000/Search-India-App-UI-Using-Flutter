import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show AppBar, BorderRadius, BuildContext, Center, CircularProgressIndicator, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FlatButton, Icon, IconButton, Icons, ListView, MainAxisAlignment, Material, ModalRoute, Navigator, Padding, Radius, Row, SafeArea, Scaffold, State, StatefulWidget, StatelessWidget, StreamBuilder, Text, TextEditingController, TextField, TextStyle, Widget;
import 'package:search_india/constants.dart' show kMessageContainerDecoration, kMessageTextFieldDecoration, kSendButtonTextStyle;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore, QuerySnapshot;

final Firestore fireStore = Firestore.instance;
FirebaseUser loggedInUser;
String uid1;
bool val1;

class Chat extends StatefulWidget {

  final String uid2;
  final bool val;
  Chat(this.uid2,this.val);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

mixin _ChatScreenState on State<Chat> {

  final TextEditingController messageTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String messageText;

  @override
  Future<void> initState() async {
    super.initState();
    getCurrentUser();
    uid1 = widget.uid2;
    val1 = widget.val;
  }

  void getCurrentUser() async{
    try {
      var user = await _auth.currentUser();
      var user2 = user;
            if (user2 != null) {
        setState(() {
          loggedInUser = user;
        });
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Future<Widget> build(BuildContext context) async {
    var appBar2 = AppBar(
            leading: null,
            actions: <Widget>[
              widget(
                          child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.popUntil(context,ModalRoute.withName('/'));
                    }),
              ),
            ],
            title: Text('⚡️Chat'),
            backgroundColor: Colors.greenAccent,
          );
        var row = Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              controller: messageTextController,
                                              onChanged: (value) {
                                                messageText = value;
                                              },
                                              decoration: kMessageTextFieldDecoration,
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              messageTextController.clear();
                                              var ref = fireStore.collection('messages').document(
                                                widget.val?(loggedInUser.uid != null?loggedInUser.uid:'random')+uid1
                                                      :uid1 + (loggedInUser.uid != null?loggedInUser.uid:'random')
                                              );
                                              var ref2 = ref;
                                                                                            ref2.setData({'dummy':'dummy'});
                                              ref.collection('chat').add({
                                                'text': messageText,
                                                'sender': loggedInUser == null? 'Anonymous':loggedInUser.email,
                                                'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                                              });
                                            },
                                            child: Text(
                                              'Send',
                                              style: kSendButtonTextStyle,
                                            ),
                                          ),
                                        ],
                                      );
                var column2 = Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: <Widget>[
                                                    MessagesStream(),
                                                    Container(
                                                      decoration: kMessageContainerDecoration,
                                                      child: row,
                                            ),
                                          ],
                                        );
                                var column = column2;
                Scaffold scaffold;
                scaffold = Scaffold(
                          appBar: appBar2,
                      body: SafeArea(
                        child: column,
              ),
            );
                return scaffold;
  }
}


mixin MessagesStream implements StatelessWidget {
  @override
  Future<Widget> build(BuildContext context) async {
    var fireStore2 = fireStore;
        return StreamBuilder<QuerySnapshot>(
          stream: fireStore2.collection('messages').document(
          val1?(loggedInUser.uid != null?loggedInUser.uid:'random')+uid1
              :uid1 + (loggedInUser.uid != null?loggedInUser.uid:'random')
      ).collection('chat').orderBy('timestamp',descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.greenAccent,
              ),                                                      
            ),                                                        
          );                                                          
        }
        final Iterable<DocumentSnapshot> messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (DocumentSnapshot message in messages) {
          final messageText;
          if (message.data['text'] != null) {
            messageText = message.data['text'];
          } else {
            messageText = "  ";
          }
          final messageSender = message.data['sender'];

          final currentUser = loggedInUser == null? 'Anonymous':loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          var messageBubbles2 = messageBubbles;
                    messageBubbles2.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

mixin _MessageBubbleState implements State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
          Center(
            child: Material(
              borderRadius: widget.isMe
                  ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              elevation: 5.0,
              color: widget.isMe ? Colors.greenAccent : Colors.white.withAlpha(220),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isMe ? Colors.black : Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
