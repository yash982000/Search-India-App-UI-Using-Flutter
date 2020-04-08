import 'dart:async' show Timer;
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:flutter/material.dart' show Alignment, AppBar, Axis, Border, BoxDecoration, BoxFit, BuildContext, Colors, Column, Container, CrossAxisAlignment, Curves, EdgeInsets, Expanded, FontWeight, Icon, IconButton, Icons, Image, InkWell, ListView, MainAxisAlignment, Material, MaterialPageRoute, MaterialType, MediaQuery, Navigator, Padding, Row, Scaffold, ScrollController, SizedBox, State, StatefulWidget, Text, TextStyle, Widget;
import 'package:flutter_swiper/flutter_swiper.dart' show Swiper, SwiperController;
import 'package:search_india/chat.dart' show Chat;
import 'package:search_india/user_display.dart' show UserDisplay;
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;
import 'package:search_india/dataModel.dart' show DataModel;

class ItemDetail extends StatefulWidget {
  final DataModel data;
  final bool val;
  ItemDetail(this.data, this.val);
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

mixin _ItemDetailState on State<ItemDetail> {
  bool wait = false;
  ScrollController _controller;
  int currentImg = 0;
  var swipeControl = SwiperController();

  @override
  void initState() {
    var scrollController = ScrollController();
        _controller = scrollController;
    super.initState();
  }

  @override
  Future<Widget> build(BuildContext context) async {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Details"),
        actions: <Widget>[
          widget(
                      child: IconButton(
              icon: Icon(Icons.message),
              onPressed: () async {
                if (widget.val) {
                  var docs =
                      await Firestore.instance.collection('users').getDocuments();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserDisplay(docs)));
                } else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chat(widget.data.uid,false)));
              },
            ),
          ),
          !(widget.val)?IconButton(
            icon: Icon(Icons.phone),
            onPressed: () async {
              String url = 'tel:' + widget.data.phone;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ):Container(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.grey.shade200,
                  height: 580,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Swiper(
                      curve: Curves.linear,
                      controller: swipeControl,
                      loop: false,
                      onIndexChanged: (index) {
                        setState(() {
                          if (!wait) {
                            currentImg = index;
                          }
                        });
                      },
                      containerWidth: MediaQuery.of(context).size.width,
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            child: Image.network(
                              widget.data.images[index],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                      itemCount: widget.data.images.length,
                      viewportFraction: .97,
                      scale: .8,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 90,
                  child: ListView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.images.length,
                      itemBuilder: (_, int i) {
                        return InkWell(
                          onTap: () {
                            wait = true;
                            Timer(Duration(milliseconds: 300), () {
                              wait = false;
                            });
                            setState(() {
                              swipeControl.move(
                                i,
                              );
                              currentImg = i;
                            });
                          },
                          child: Container(
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(
                                    width: 1.2,
                                    color: currentImg == i
                                        ? Colors.green.shade700
                                        : Colors.black12)),
                            height: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.network(
                                  widget.data.images[i],
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.data.name,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                        Text(widget.data.location,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.orange.shade700,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 2, 8, 2),
                            child: Text(
                              widget.data.status,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(widget.data.desc,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade900)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Reward",
                            style: TextStyle(
                                fontSize: 14, color: Colors.green.shade700)),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("₹ ${widget.data.reward}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
