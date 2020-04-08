import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show BottomNavigationBar, BottomNavigationBarItem, BuildContext, Colors, Container, Icon, Icons, MaterialPageRoute, Navigator, Scaffold, State, StatefulWidget, Text, Widget;
import 'package:search_india/about_us.dart' show AboutUs;
import 'package:search_india/make_add.dart' show CreateAdd;
import 'package:search_india/my_adds.dart' show MyAdds;
import 'package:search_india/profile.dart';
import 'mpage.dart' show MainPage2;
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();

  }

  void firebaseCloudMessaging_Listeners() {
    var platform = Platform;
        if (platform.isIOS) {
      iOS_Permission();
    }

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Future<void> iOS_Permission() async {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("""
Settings registered: $settings""");
    });
  }

  var num = 0;
  final widgets = [MainPage2(),CreateAdd(),MyAdds(),Container(),AboutUs()];


  @override
  void initState() {
    super.initState();
    setUpFirebase();
  }

  @override
  Future<Widget> build(BuildContext context) async {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: widgets[num],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: Colors.red,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text('home').tr(context: context),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.view_quilt,
              color: Colors.white,
            ),
            title: Text('new_ad').tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            title: Text('our_ads').tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text('person').tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            title: Text('about').tr()
          )
        ],
        onTap: (a){
          setState(() {
            if(a == 3){
              num = 0;
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
            }else
              num = a;
          });
        },
        currentIndex: num,
        selectedItemColor: Colors.greenAccent,
      ),
    );
  }
}
