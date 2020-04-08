import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:search_india/updateName.dart';

import 'uploadProfilePhoto.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int a = 1;
  String imgOldValue;
  String name, email, password, mobile, city, uid1;
  final firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  bool loading = true;
  String loc = 'https://null';

  void getCurrentUser() async {
    try {
      loading = true;
      var user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        uid1 = user.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  void loadData() async {
    try {
      var data = await firestore.collection('users').getDocuments();
      for (var doc in data.documents) {
        if (doc.documentID == uid1) {
          name = doc.data['name'];
          email = loggedinuser.email;
          mobile = doc.data['mobile'];
          city = doc.data['city'];
          loc = doc.data['img'] != null?doc.data['img'] != null:"https://www.stickpng.com/assets/images/585e4beacb11b227491c3399.png";
          break;
        }
      }
      setState(() {
        loading = false;
      });
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
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.white.withAlpha(230),
        appBar: AppBar(
          title: Text('PROFILE'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(loc),
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name != null ? name : 'Loading',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   UpdateName(uid1, name, mobile) ));

                      },
                      child: Icon(Icons.edit, color: Colors.black,
                      size: 20,),
                    )
                  ],
                ),
                SizedBox(
                    width: 200,
                    child: Divider(
                      thickness: 1,
                      color: Colors.black.withAlpha(140),
                    )),
                InkWell(
                  onTap: () async {
                    imgOldValue = loc;
                    loc = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdatePic(uid1, name, mobile, city)));

                    setState(() {
                      if (profilePhoto != null && profilePhoto != "") {
                        loc = profilePhoto;
                      } else
                        loc = imgOldValue;
                    });
                  },
                  child: Text(
                    'Change Profile Picture',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      activeColor: Colors.black,
                      onChanged: (i) {
                        setState(() {
                          a = i;
                        });
                      },
                      groupValue: a,
                    ),
                    Text(
                      'Male',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Radio(
                      value: 1,
                      activeColor: Colors.black,
                      onChanged: (i) {
                        setState(() {
                          a = i;
                        });
                      },
                      groupValue: a,
                    ),
                    Text(
                      'Female',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withAlpha(140),
                ),
                Text(
                  'Email: *',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  email != null ? email : 'Loading',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withAlpha(140),
                ),
                Text(
                  'Phone: *',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.black),
                ),
                Text(
                  mobile != null ? mobile : 'Loading',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withAlpha(140),
                ),
                Text(
                  'City: *',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.black),
                ),
                Text(
                  city != null ? city : 'Loading',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withAlpha(140),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    _auth.signOut();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 2, color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        'LOGOUT',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text(
                    'Back to Home',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
