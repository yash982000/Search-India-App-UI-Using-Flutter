import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';

import 'dataModel.dart';
import 'itemDetail.dart';

class ViewAll extends StatefulWidget {
  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  var _searchEdit = new TextEditingController();

  bool _isSearch = true;
  String _searchText = "";
  List<DataModel> dataList = List();
  List<DataModel> selectedItems = List();
  String imgage, category, status, city, uid1;
  final firestore = Firestore.instance;
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
            title: Text(
                'Please turn on the internet and login, to access the features.\n If still not yet registered, then register and login in.'),
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
      for (var doc in data.documents) {
        list.add(
          CardView(
            name: doc.data['category'],
            location: doc.data['city'],
            status: doc.data['posttype'],
            img: doc.data['uri'][0],
            reward: doc.data['reward'],
            desc: doc.data['desc'],
          ),
        );
        dataList.add(
          DataModel(
            doc.data['category'],
            doc.data['city'],
            doc.data['posttype'],
            doc.data['uri'],
            doc.data['reward'],
            doc.data['desc'],
              doc.data['uid'],
              doc.data['phone']
          ),
        );

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

  _ViewAllState() {
    _searchEdit.addListener(() {
      if (_searchEdit.text.isEmpty) {
        setState(() {
          _isSearch = true;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearch = false;
          _searchText = _searchEdit.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: _searchBox(),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _isSearch
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        itemCount: dataList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: itemWidth / itemHeight,
                        ),
                        itemBuilder: (context, val) {
                          return InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemDetail(dataList[val],false)));

                              },
                              child: list[val]);
                        },
                      ),
                    )
                  : _searchListView()
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return new Container(
      child: new TextField(
        controller: _searchEdit,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          hintText: " Search Ads by location",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _searchListView() {
    selectedItems = List();
    for (int i = 0; i < dataList.length; i++) {
      var item = dataList[i].location;

      if (item.toLowerCase().contains(_searchText.toLowerCase())) {
        selectedItems.add(dataList[i]);
      }
    }
    return _searchAddList();
  }

  Widget _searchAddList() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return selectedItems.length != 0
        ? GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: selectedItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, val) {
              print(selectedItems[val].location);
              return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetail(selectedItems[val],false)));

                },
                child: Card(
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
                            image: NetworkImage(selectedItems[val].images[0]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            selectedItems[val].name,
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
                                selectedItems[val].location,
                                style:
                                    TextStyle(color: Colors.black, fontSize: 16),
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
                              selectedItems[val].status,
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
                                'Lost ${selectedItems[val].name} at ${selectedItems[val].location}, ImageUrl: ${selectedItems[val].images[0]}, if Found call: 8837342435');
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
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
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
                ),
              );
            },
          )
        : Center(
            child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100,),
                Text("No result found, please retry....."),
              ],
            ),
          ));
  }
}

class CardView extends StatelessWidget {
  final img, name, location, status, reward, desc;

  CardView({this.img, this.name, this.location, this.status, this.reward, this.desc});

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
                image: NetworkImage(img),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Column(   crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Reward",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Text("₹ $reward",
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


