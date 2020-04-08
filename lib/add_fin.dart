import 'dart:io' show File;
import 'dart:typed_data' show ByteData;
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:search_india/file_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:flutter/material.dart' show Alignment, AppBar, Border, BorderRadius, BoxDecoration, BuildContext, Card, Center, ClipRRect, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, GestureDetector, GridView, Icon, IconButton, Icons, InkWell, MainAxisAlignment, MediaQuery, ModalRoute, Navigator, NeverScrollableScrollPhysics, Padding, Radius, RoundedRectangleBorder, Scaffold, SingleChildScrollView, SizedBox, State, StatefulWidget, Text, TextAlign, TextStyle, Widget, required;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage, StorageReference, StorageTaskSnapshot, StorageUploadTask;
import 'package:modal_progress_hud/modal_progress_hud.dart' show ModalProgressHUD;
import 'package:multi_image_picker/multi_image_picker.dart' show Asset, AssetThumb, CupertinoOptions, MaterialOptions, MultiImagePicker;

class FinalAdd extends StatefulWidget {
  final Map<String, String> map;

  FinalAdd({this.map});

  @override
  Future<_FinalAddState> createState() async => _FinalAddState();
}

mixin _FinalAddState on State<FinalAdd> {
  var images = List<Asset>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _error = 'No Error Dectected';
  final Firestore _firestore = Firestore.instance;
  FirebaseUser loggedinuser;
  var loading = false;
  String location, uid1;
  List uris = [];

  void getCurrentUser() async {
    try {
      setState(() {
        loading = true;
      });
      FirebaseUser user;
      user = await _auth.currentUser();
      var user2 = user;
            if (user2 != null) {
        loggedinuser = user;
        uid1 = loggedinuser.uid;
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> uploadImage({@required List<Asset> assets}) async {
    List uploadUrls;
    uploadUrls = [];

    var assets2 = assets;
        var wait = Future.wait(
                    assets2.map((Asset asset) async {
                  ByteData byteData;
                  byteData = await asset.getByteData();
                  var imageData = byteData.buffer.asUint8List();
                  StorageReference reference;
                  reference = FirebaseStorage.instance.ref().child(
                      """
        pics/""" + DateTime.now().millisecondsSinceEpoch.toString());
                  StorageUploadTask uploadTask;
                  uploadTask = reference.putData(imageData);
                  StorageTaskSnapshot storageTaskSnapshot;
                  StorageTaskSnapshot snapshot;
                  snapshot = await uploadTask.onComplete;
                  if (snapshot.error == null) {
                    storageTaskSnapshot = snapshot;
                    final String downloadUrl =
                        await storageTaskSnapshot.ref.getDownloadURL();
                    uploadUrls.add(downloadUrl);
        
                    print('Upload success');
                  } else {
                    print('Error from image repo ${snapshot.error.toString()}');
                    throw ('This file is not an image');
                  }
                }),
                eagerError: true,
                cleanUp: (_) {
                  print('eager cleaned up');
                });
                var list = await wait;

    return uploadUrls;
  }

  Future<Widget> buildGridView() async {
    var gridView = GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset;
            asset = images[index];
            var card = Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AssetThumb(
                              asset: asset,
                              width: 300,
                              height: 300,
                            ),                                                 
                          ),                                                   
                        );                                                     
                        return card;
          }),                                                                 
        );                                                                     
        return gridView;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      var pickImages = MultiImagePicker.pickImages(
              maxImages: 5,
              enableCamera: true,
              selectedAssets: images,
              cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
              materialOptions: MaterialOptions(
                statusBarColor: "#191919",
                actionBarColor: "#212121",
                actionBarTitle: "Upload Image",
                allViewTitle: "All Photos",
                useDetailsView: false,
                selectCircleStrokeColor: "#212121",
              ),
            );
            resultList = await pickImages;
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Future<void> initState() async {
    var _finalAddState = super;
        _finalAddState.initState();
    getCurrentUser();
    images.clear();
  }

  @override
  Future<Widget> build(BuildContext context) async {
    var a = 250;
        var container = Container(
                                                      height: 300, child: buildGridView());
                var container3 = Container(
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              uris = await uploadImage(assets: images);
                                              var documentReference = await _firestore.collection('adds').add({
                                                'uid': uid1,
                                                'category': widget.map['category'],
                                                'reward': widget.map['reward'],
                                                'subcategory': widget.map['subcategory'],
                                                'posttype':
                                                    widget.map['posttype'] == '0' ? 'LOST' : "FOUND",
                                                'city': widget.map['city'],
                                                'uri': uris,
                                                'desc': widget.map['desc'],
                                                'phone':(widget.map['phoneval'] == 'false')? widget.map['mobile']:" ",
                                                'timestamp':
                                                    DateTime.now().millisecondsSinceEpoch.toString(),
                                              });
                                              setState(() {
                                                loading = true;
                                              });
                                              Navigator.popUntil(context, ModalRoute.withName('/'));
                                            },
                                            child: Center(
                                              child: Container(
                                                width: 200,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Text(
                                                    'Finish',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                var column = Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),                                                            
                                                    if (images.length == 0) Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(30)),
                                                                  ),                                            
                                                                  child: Center(
                                                                      child: InkWell(
                                                                    onTap: () {
                                                                      loadAssets();
                                                                    },
                                                                    child: Container(
                                                                      child: Column(
                                                                        children: <Widget>[
                                                                          Icon(
                                                                            Icons.add,
                                                                            size: 100,
                                                                            color: Colors.white.withAlpha(a),
                                                                      ),                                     
                                                                      Text(
                                                                        "SELECT PICTURES",
                                                                        style: TextStyle(
                                                                          fontSize: 30,
                                                                          color: Colors.white.withAlpha(230),
                                                                        ),                                 
                                                                      ),                                   
                                                                    ],                                     
                                                                  ),                                       
                                                                ),                                         
                                                              ))),                                        
                                                        ),                                               
                                                      ) else Container(                                 
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 20,
                                                            ),                                            
                                                            Row(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                                                  child: container,
                                                        ),                                                
                                                      ],                                                 
                                                    ),                                                  
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(bottom: 12.0, top: 5),
                                                      child: Column(
                                                        children: <Widget>[
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons.refresh,
                                                                size: 32,
                                                                color: Colors.white,
                                                              ),                                             
                                                              onPressed: () {
                                                                loadAssets();
                                                              }),                                           
                                                          Text("Re-take")
                                                        ],                                                 
                                                      ),                                                   
                                                    ),                                                     
                                                  ],                                                       
                                                ),                                                         
                                              ),                                                           
                                        StreamBuilder<Object>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            var column = Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        children: <Widget>[
                                                                                                          Text(
                                                                                                            'Use real picture, not Catalog.',
                                                                                                            textAlign: TextAlign.left,
                                                                                                            style: TextStyle(
                                                                                                                fontSize: 22,
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                                color: Colors.white),                 
                                                                                                          ),                                         
                                                                                                        ],                                           
                                                                                                      );                                            
                                                                        var container2 = Container(
                                                                                                                                                              margin: EdgeInsets.only(bottom: 30, top: 20),
                                                                                                                                                              alignment: Alignment.bottomCenter,
                                                                                                                                                              child: column,
                                                                                                                                );
                                                                                                                                var container = container2;
                                                                        return container;
                                          }
                                        ),                                                                     
                                        SizedBox(
                                          height: 80,
                                        ),                                                                     
                                        container3,
                        SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: Border.all(width: 2, color: Colors.black),
                              ),
                              child: Center(
                                child: Text(
                                  'Back',
                                  style: TextStyle(color: Colors.black),
                                ),                           
                              ),                            
                            ),                              
                          ),                                
                        ),                                 
                        SizedBox(
                          height: 45,
                        ),                                  
                      ],                                   
                    );                                     
        var scaffold = Scaffold(
                backgroundColor: Colors.greenAccent,
                appBar: AppBar(
                  title: Text('Create Report'),
                  actions: <Widget>[],
                ),                                         
                body: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: column,
              ),                                           
            ),                                             
          );                                             
        return ModalProgressHUD(
          inAsyncCall: loading,
          child: scaffold,
    );
  }
}
