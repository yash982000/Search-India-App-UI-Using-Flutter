import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:search_india/uploadRegistrationImg.dart';

Position _currentPosition;
String _currentAddress = 'City';

final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final key = new GlobalKey<ScaffoldState>();
  final firestore = Firestore.instance;
  String name, email, password, mobile, city;
  bool loading = false;
  final _storage = FirebaseStorage.instance;
  File _image;
  String location, uid1;

  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
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
        _currentAddress = "${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future uploadPic() async {
    StorageReference reference =
        _storage.ref().child(_image.path.split('/').last);
    StorageUploadTask uploadTask = reference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    location = await reference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          key: key,
          resizeToAvoidBottomPadding: false,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_a_photo),
            backgroundColor: Colors.white.withAlpha(180),
            onPressed: () async {
              location = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadPic()));
            },
          ),
          body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/login.jpeg'),
              fit: BoxFit.cover,
            )),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white.withAlpha(255),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Text(
                            "It's 100% Free",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                          color: Colors.black,
                          height: 130,
                          width: 170,
                          child: Image(
                            image: AssetImage('images/splash.png'),
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  new InputWidget(
                    name: 'Name',
                    data: Icons.person,
                    onpressed: (val) {
                      name = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new InputWidget(
                    name: 'Email',
                    data: Icons.mail,
                    onpressed: (val) {
                      email = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new InputWidget(
                    name: 'Password',
                    data: Icons.lock,
                    onpressed: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new InputWidget(
                    name: 'Mobile',
                    data: Icons.phone_android,
                    onpressed: (val) {
                      mobile = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new InputWidget(
                    name: _currentAddress,
                    data: Icons.location_on,
                    onpressed: (val) {
                      _currentAddress = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new InputWidget(
                    name: 'Confirm Password',
                    data: Icons.lock,
                    onpressed: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Please verify your e-mail before login.'),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!password.contains(new RegExp(r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$')) ){
                        final snackBar = new SnackBar(
                            content: new Text(
                              "Password must contain at least one letter, at least one number, and be longer than six charaters.",
                              style: TextStyle(fontSize: 15),
                            ),
                            duration: new Duration(milliseconds: 3300),
                            backgroundColor: Colors.grey.shade200);
                        key.currentState.showSnackBar(snackBar);
                      }
                      else{
                        try {
                          setState(() {
                            loading = true;
                          });
                          var x = await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          if (x != null) {
                            var user = await _auth.currentUser();
                            await user.sendEmailVerification();
                            await firestore
                                .collection('users')
                                .document(user.uid)
                                .setData({
                              'name': name,
                              'mobile': mobile,
                              'city': _currentAddress,
                              'img': location,
                            });
                            setState(() {
                              loading = false;
                            });
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                    }},
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white.withAlpha(150),
                      ),
                      child: Center(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 2, color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  var name, data, onpressed;

  InputWidget({this.name, this.data, this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        textCapitalization: TextCapitalization.words,
        onChanged: onpressed,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withAlpha(125),
          hintText: name == "City" ? _currentAddress : name,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          icon: InkWell(
            onTap: () {
              name = _currentAddress;
            },
            child: Icon(
              data,
              size: 40,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
