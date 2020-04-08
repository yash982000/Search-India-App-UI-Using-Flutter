import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:flutter/material.dart' show AlertDialog, BorderRadius, BoxDecoration, BoxFit, BuildContext, Card, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, GestureDetector, GridView, Icon, Icons, Image, InkWell, MainAxisAlignment, MaterialPageRoute, MediaQuery, Navigator, NetworkImage, Padding, Radius, Row, SizedBox, SliverGridDelegateWithFixedCrossAxisCount, State, StatefulWidget, StatelessWidget, Text, TextStyle, Widget, kToolbarHeight, showDialog;
import 'package:flutter/src/widgets/basic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart' show ModalProgressHUD;
import 'package:search_india/itemDetail.dart' show ItemDetail;
import 'package:share/share.dart' show Share;
import 'dataModel.dart' show DataModel;

class FirstScreen extends StatefulWidget {
  final bool dir;

  FirstScreen(this.dir);

  @override
  Future<_FirstScreenState> createState() async => _FirstScreenState();
}

mixin _FirstScreenState on State<FirstScreen> {
  String imgage, category, status, city, uid1;
  List<DataModel> dataList = List();
  final firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  bool loading = false;
  List<CardView> list = <CardView>[];

  Future getCurrentUser() async {
    try {
      loading = true;
      FirebaseUser user;
      user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        uid1 = user.uid;
      } else {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
                '''
Please turn on the internet and login, to access the features.\n If still not yet registered, then register and login in.'''),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future loadData() async {
    try {
      QuerySnapshot data;
      data = await firestore
          .collection('adds')
          .orderBy('timestamp', descending: true)
          .getDocuments();
      if (widget.dir) {
        for (var doc in data.documents) {
          if (doc.data['uid'] == uid1) {
            list.add(
              CardView(
                name: doc.data['category'],
                location: doc.data['city'],
                status: doc.data['posttype'],
                img: doc.data['uri'][0],
                reward: doc.data['reward'],
              ),
            );
            dataList.add(
              DataModel(doc.data['category'], doc.data['city'],
                  doc.data['posttype'], doc.data['uri'], doc.data['reward'], doc.data['desc'], doc.data['uid'], doc.data['phone']),
            );
          }
          setState(() {
            loading = false;
          });
        }
      } else {
        for (DocumentSnapshot doc in data.documents) {
          list.add(
            CardView(
              name: doc.data['category'],
              location: doc.data['city'],
              status: doc.data['posttype'],
              img: doc.data['uri'][0],
              reward: doc.data['reward'],

            ),
          );
          dataList.add(
            Center(
              child: DataModel(doc.data['category'], doc.data['city'],
                  doc.data['posttype'], doc.data['uri'], doc.data['reward'], doc.data['desc'],doc.data['uid'], doc.data['phone']),
            ),                                    
          );
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> initState() async {
    super.initState();
    getCurrentUser();
    loadData();
  }

  @override
  Future<Widget> build(BuildContext context) async {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var gridView = GridView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: itemWidth                     / itemHeight,
            ),                                           
            itemBuilder: (context, val) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemDetail(dataList[val],false)));
                  },
                  child: list[val]);
            },
          );                                                                         
        return ModalProgressHUD(
          inAsyncCall: loading,
          child: gridView,
    );
  }
}

class CardView extends StatelessWidget {
  final img, name, location, status, reward, docId, desc;

  CardView({this.img, this.name, this.location, this.status, this.reward, this.docId, this.desc});

  @override
  Future<Widget> build(BuildContext context) async {
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
                image: NetworkImage(img),
              ),                         
            ),                                 
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Reward",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "₹ $reward",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
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
                    location,
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
                  status,
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
              onTap: () {
                Share.share(
                    'Lost $name at $location, ImageUrl: $img, if Found call: 8837342435');
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
