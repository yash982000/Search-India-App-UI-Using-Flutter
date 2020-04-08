import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:search_india/profile.dart';
import 'package:search_india/uploadRegistrationImg.dart';

Position _currentPosition;
String _currentAddress = 'City';
final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

class OldLoginMobile extends StatefulWidget {
  @override
  _OldLoginMobileState createState() => _OldLoginMobileState();
}

class _OldLoginMobileState extends State<OldLoginMobile> {
  String otp;
  List<PhoneNumber> numbers = List();
  final key = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  String name, email, password, mobile, city;
  bool loading = false;
  final _storage = FirebaseStorage.instance;
  File _image;
  String _smsVerificationCode;
  String location, uid1;

  Future loadData() async {
    try {
      var data = await firestore.collection('users').getDocuments();
      for (var doc in data.documents) {
        numbers.add(PhoneNumber(doc.data['mobile']));
      }
      print(numbers[0].phone);
    } catch (e) {
      print(e);
    }
  }

  _phoneAuth(BuildContext context) async {
    try {
      String phoneNumber = "+91" + mobile;

      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: 5),
          verificationCompleted: (authCredential) =>
              _verificationComplete(authCredential, context),
          verificationFailed: (authException) =>
              _verificationFailed(authException, context),
          codeAutoRetrievalTimeout: (verificationId) =>
              _codeAutoRetrievalTimeout(verificationId),
          // called when the SMS code is sent
          codeSent: (verificationId, [code]) =>
              _smsCodeSent(verificationId, [code]));
    } catch (e) {
      print(e);
    }
  }

  Future<bool> verifyPhoneNumber(String code) async {
    try {
      loading = true;
      await _auth.signInWithCredential(PhoneAuthProvider.getCredential(
          verificationId: _smsVerificationCode, smsCode: otp));
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loading = false;
        });
        final snackBar = SnackBar(content: Text("Success!!!"));
        key.currentState.showSnackBar(snackBar);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Profile()));
      }
      setState(() {
        loading = false;
      });
      return true;
    } catch (e) {
      setState(() {
        loading = false;
        final snackBar = SnackBar(content: Text("Failure!, try again later."));
        key.currentState.showSnackBar(snackBar);
      });
      return false;
    }
  }

  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((authResult) async {
      final snackBar = SnackBar(content: Text("Success!!!"));
      key.currentState.showSnackBar(snackBar);
      setState(() {
        loading = false;
        print("hello");
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Profile()));
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
    setState(() {
      loading = false;
    });
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    final snackBar = SnackBar(
        content:
            Text("Exception!! message:" + authException.message.toString()));
    key.currentState.showSnackBar(snackBar);
    setState(() {
      loading = false;
    });
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    setState(() {
      loading = false;
    });
    _smsVerificationCode = verificationId;
  }

  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          _getCurrentLocation();
          loadData();
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
                              'OTP LOGIN',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white.withAlpha(255),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Text(
                            "For returning users",
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
                    height: 120,
                  ),
                  otp == null
                      ? Column(
                          children: <Widget>[
                            new InputWidget(
                              name: 'Mobile',
                              data: Icons.phone_android,
                              onpressed: (val) {
                                mobile = val;
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Please enter mobile number to receive OTP'),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            InputWidget(
                                name: 'OTP',
                                data: Icons.lock,
                                onpressed: (val) {
                                  otp = val;
                                }),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                  otp == null
                      ? GestureDetector(
                          onTap: () async {
                            bool proceed = false;
                            for (int i = 0; i < numbers.length; i++) {
                              if (mobile == numbers[i].phone) {
                                proceed = true;
                              } else
                                proceed = false;
                            }

                            if ((mobile != null || mobile != "") && proceed) {
                              try {
                                _phoneAuth(context);
                                setState(() {
                                  otp = "";
                                });
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              final snackBar = SnackBar(
                                  content:
                                      Text("Sorry, can't find your number"));
                              key.currentState.showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.white.withAlpha(150),
                            ),
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            try {
                              setState(() {
                                loading = true;
                              });
                              verifyPhoneNumber(otp);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.white.withAlpha(150),
                            ),
                            child: Center(
                              child: Text(
                                'LOGIN',
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
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
                          'BACK',
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
        decoration: name == "Mobile"
            ? InputDecoration(
                filled: true,
                fillColor: Colors.white.withAlpha(125),
                hintText: name,
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
              )
            : InputDecoration(
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

class PhoneNumber {
  final String phone;

  PhoneNumber(this.phone);
}
