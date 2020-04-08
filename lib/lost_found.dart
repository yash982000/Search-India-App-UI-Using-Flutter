import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:flutter/material.dart' show AlertDialog, BorderRadius, BoxDecoration, BoxFit, BuildContext, Card, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, GestureDetector, GridView, Icon, Icons, Image, MainAxisAlignment, MediaQuery, NetworkImage, Padding, Radius, Row, SizedBox, SliverGridDelegateWithFixedCrossAxisCount, State, StatefulWidget, StatelessWidget, Text, TextStyle, Widget, kToolbarHeight, showDialog;
import 'package:modal_progress_hud/modal_progress_hud.dart' show ModalProgressHUD;
import 'package:share/share.dart' show Share;

class LostFound extends StatefulWidget {
  final String type;

  LostFound(this.type);

  @override
  Future<_LostFoundState> createState() async => _LostFoundState();
}

mixin _LostFoundState on State<LostFound> {

  String imgage, category, status, city, uid1;
  final Firestore firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  bool loading = false;
  List<CardView> list = <CardView>[];

  Future getCurrentUser() async {
    try {
      loading = true;
      var user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        uid1 = user.uid;
      } else {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Please turn on the internet and login, to access the features.\n If still not yet registered, then register and login in.'),
          ),                                               
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future loadData() async {
    try {
      var data = await firestore
          .collection('adds')
          .orderBy('timestamp', descending: true)
          .getDocuments();
      for (DocumentSnapshot doc in data.documents) {
        if (doc.data['posttype'] == widget.type ) {
          list.add(
            CardView(
              name: doc.data['category'],
              location: doc.data['city'],
              status: doc.data['posttype'],
              img: doc.data['uri'][0],
            ),
          );
        }
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadData();
  }

  @override
  Future<Widget> build(BuildContext context) async {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var modalProgressHUD = ModalProgressHUD(
          inAsyncCall: loading,
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: itemWidth / itemHeight,
            ),           
            itemBuilder: (context, val) {
              return list[val];
            },
          ),               
        );                    
        return modalProgressHUD;
  }
}

class CardView extends StatefulWidget {
  final img, name, location, status;
  CardView({this.img, this.name, this.location, this.status});

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image(
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(widget.img),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                widget.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
                Expanded(
                  child: Text(
                    widget.location,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  widget.status,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 6),
              child: Text(
                'Time',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: (){
                Share.share('Lost ${widget.name} at ${widget.location}, ImageUrl: ${widget.img}, if Found call: 8837342435');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          'Share',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
