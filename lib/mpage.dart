import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' show AssetImage, Axis, BorderRadius, BoxDecoration, BoxFit, BuildContext, Center, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, GestureDetector, Icon, Image, MainAxisAlignment, Navigator, NestedScrollView, NetworkImage, Padding, Radius, RoundedRectangleBorder, Row, ScrollController, SingleChildScrollView, SingleTickerProviderStateMixin, SizedBox, State, StatefulWidget, Text, TextStyle, Widget;
import 'package:flutter/material.dart' show AppBar, AssetImage, Axis, BorderRadius, BoxDecoration, BoxFit, BuildContext, Center, CircleAvatar, Colors, Column, Container, CrossAxisAlignment, DefaultTabController, EdgeInsets, Expanded, FlexibleSpaceBar, FontWeight, GestureDetector, Icon, IconButton, Icons, Image, InkWell, ListTile, MainAxisAlignment, MaterialPageRoute, Navigator, NestedScrollView, NetworkImage, Padding, Radius, RaisedButton, RoundedRectangleBorder, Row, Scaffold, ScrollController, SingleChildScrollView, SingleTickerProviderStateMixin, SizedBox, SliverAppBar, State, StatefulWidget, Tab, TabBar, TabBarView, TabController, Text, TextStyle, Widget, showDialog;
import 'package:flutter/rendering.dart' show AssetImage, Axis, BorderRadius, BoxDecoration, BoxFit, CrossAxisAlignment, EdgeInsets, FontWeight, MainAxisAlignment, NetworkImage, Radius, RoundedRectangleBorder, TextStyle;
import 'package:search_india/customDialogBox.dart' show CustomDialog;
import 'package:search_india/categ_adds.dart' show CategAdds;
import 'package:search_india/first_screen.dart' show FirstScreen;
import 'package:search_india/login_page.dart' show LoginPage;
import 'package:geolocator/geolocator.dart' show Geolocator, LocationAccuracy, Placemark, Position;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:search_india/lost_found.dart' show LostFound;
import 'package:search_india/view_all.dart' show ViewAll;

class MainPage2 extends StatefulWidget {
  @override
  _MainPage2State createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  ScrollController scrollController;
  Position _currentPosition;
  var _currentAddress = 'locate'.tr();
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

  @override
  Future<void> initState() async {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    scrollController = ScrollController();
    var schedulerBinding = SchedulerBinding;
        schedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          _getCurrentLocation();
        }));
  }

  _getCurrentLocation() {
    geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position p) {
      setState(() {
        _currentPosition = p;
      });
      _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.location_on),
          onPressed: () {
            print('Hello');
            _getCurrentLocation();
          },
        ),
        title: Text(_currentAddress),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ViewAll()));
            },
            child: Icon(Icons.search),
          ),
          IconButton(
            icon: Icon(Icons.lock_outline),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          InkWell(
            onTap: () {
              _showDialog();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                  child: Text(
                'lng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ).tr()),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 480,
              backgroundColor: Colors.greenAccent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Column(
                    children: <Widget>[
                      Wid1(),
                      Wid2(),
                      ListTile(
                        title: Text(
                          'new',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                              fontSize: 18,
                              color: Colors.black),
                        ).tr(),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text('see_all').tr(),
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewAll()));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: tabController,
                indicatorColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "complete",
                      style: TextStyle(color: Colors.black),
                    ).tr(),
                  ),
                  Tab(
                    child: Text(
                      "missing",
                      style: TextStyle(color: Colors.black),
                    ).tr(),
                  ),
                  Tab(
                    child: Text(
                      "found_item",
                      style: TextStyle(color: Colors.black),
                    ).tr(),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            FirstScreen(false),
            LostFound('LOST'),
            LostFound('FOUND'),
          ],
          controller: tabController,
        ),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
              "Choose Language", "Eng".tr(), "Hindi".tr(), "Bang".tr());
        });
  }
}

class Wid1 extends StatefulWidget {
  @override
  _Wid1State createState() => _Wid1State();
}

class _Wid1State extends State<Wid1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 250,
          color: Colors.greenAccent,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/splash.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: Text(
                            'title',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ).tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            ' Lost or Found ',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 1.2),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Wid2 extends StatefulWidget {
  @override
  _Wid2State createState() => _Wid2State();
}

class _Wid2State extends State<Wid2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: Colors.black,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategAdds("MOBILE")));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://image.shutterstock.com/image-vector/mobile-icon-260nw-424667419.jpg'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('MOBILE').tr()
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategAdds("PEOPLE")));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/people.jpeg'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('PEOPLE').tr()
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategAdds("BAGS")));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://img1.cohimg.net/is/image/Coach/76106_v5mvs_a0?fmt=jpg&wid=680&hei=885&bgc=f0f0f0&fit=vfit&qlt=75'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('BAGS').tr()
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategAdds("PETS")));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('PETS').tr()
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategAdds("VEHICLES")));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://imgd.aeplcdn.com/370x208/cw/ec/33372/Kia-Seltos-Exterior-167737.jpg?wm=0'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('VEHICLES').tr()
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategAdds('DOCUMENTS')));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2011/08/Documents.jpg'),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text('DOCUMENTS').tr()
              ],
            ),
            SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class Wid3 extends StatefulWidget {
  @override
  _Wid3State createState() => _Wid3State();
}

class _Wid3State extends State<Wid3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.greenAccent,
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('VIEW ALL'),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed: () {},
                ),
              )
            ],
            title: Text(
              'LatestPosts',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.greenAccent,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "ALL",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "LOST",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "FOUND",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              FirstScreen(false),
              Container(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
