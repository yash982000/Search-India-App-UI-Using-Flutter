import 'package:flutter/material.dart' show AppBar, BoxDecoration, BuildContext, Center, CircularProgressIndicator, Color, Colors, Column, Container, EdgeInsets, Expanded, FontWeight, GestureDetector, Icon, IconButton, Icons, ListView, MainAxisAlignment, MaterialPageRoute, Navigator, Padding, Row, Scaffold, SizedBox, State, StatefulWidget, StatelessWidget, StreamBuilder, Text, TextStyle, Widget, kElevationToShadow;
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore, QuerySnapshot;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;

import 'chat.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;
QuerySnapshot docs;

class UserDisplay extends StatefulWidget {

  final QuerySnapshot docs;
  UserDisplay(this.docs);

  @override
  _UserDisplayState createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {

  final _auth = FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    docs = widget.docs;
    get();
  }

  void getCurrentUser() async{
    try {
      var user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    }catch(e){
      print(e);
    }
  }

  get() async{
     var docs = await Firestore.instance.collection('messages').getDocuments();
     for(var doc in docs.documents){
       print(doc.documentID);
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your add responses'),
      ),
      body:Column(
        children: <Widget>[
          MessagesStream(),
        ],
      )
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff034198),
              ),
            ),
          );
        }
        final messages = snapshot.data.documents;
        print(messages.isNotEmpty);
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          if(message.documentID.contains(loggedInUser.uid)){
            String id = message.documentID.replaceAll(loggedInUser.uid, "");
            for ( var doc in docs.documents){
              if(doc.documentID == id){
                final cliname = doc.data['name'];
                final cliuid = doc.documentID;
                final phone = doc.data['mobile'];
                final messageBubble = MessageBubble(
                    name: cliname,
                    uid: cliuid,
                  phone: phone,
                );
                messageBubbles.add(messageBubble);
              }
            }
          }
        }
        return Expanded(
          child: ListView(
//            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {

  final String name,uid,phone;
  MessageBubble({this.name,this.uid,this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(uid,true)));
        },
        child: Container(
          height: 90,
          decoration:
          BoxDecoration(boxShadow: kElevationToShadow[2], color: Colors.greenAccent),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.person,
                color: Colors.black,
                size: 60,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: Colors.black,
                    size: 34,
                  ),
                  onPressed: () async{
                    String url = 'tel:' + phone;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
