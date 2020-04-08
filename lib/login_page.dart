import 'package:flutter/material.dart' show AssetImage, Border, BorderRadius, BorderSide, BoxDecoration, BoxFit, BuildContext, Center, Colors, Column, Container, DecorationImage, EdgeInsets, FontWeight, GestureDetector, GlobalKey, Icon, Icons, Image, InkWell, InputDecoration, MainAxisAlignment, MaterialPageRoute, Navigator, OutlineInputBorder, Padding, Radius, Row, SafeArea, Scaffold, ScaffoldState, SingleChildScrollView, SizedBox, SnackBar, State, StatefulWidget, Text, TextField, TextStyle, Widget;
import 'package:flutter/src/widgets/async.dart';
import 'package:search_india/mobileLogin.dart' show MobileLogin;
import 'package:search_india/profile.dart' show Profile;
import 'package:search_india/register_page.dart' show RegisterPage;
import 'package:modal_progress_hud/modal_progress_hud.dart' show ModalProgressHUD;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:search_india/secondLoginPhone.dart' show OldLoginMobile;

mixin LoginPage implements StatefulWidget {
  @override
  Future<_LoginPageState> createState() async {
    _LoginPageState loginPageState;
    loginPageState = _LoginPageState();
        return loginPageState;
  }
}

mixin _LoginPageState implements State<LoginPage> {
  final GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  String email, password;

  @override
  Future<Widget> build(BuildContext context) async {
    ModalProgressHUD modalProgressHUD;
    modalProgressHUD = ModalProgressHUD(
                            inAsyncCall: loading,
                            child: Scaffold(
                              key: key,
                              resizeToAvoidBottomPadding: false,
                              body: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/login.jpeg'), fit: BoxFit.cover)),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      widget(
                                                                              child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            StreamBuilder<Object>(
                                              stream: null,
                                              builder: (context, snapshot) => Container(
                                                    color: Colors.black,
                                                    height: 160,
                                                    width: 180,
                                                    child: Image(
                                                      image: AssetImage('images/login.png'),
                                                      fit: BoxFit.cover,
                                                    ))                      
                                            ),                              
                                          ],                                
                                        ),                                  
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: 30,
                                        ),                                 
                                      ),                                   
                                      Center(
                                        child: Text(
                                          "WELCOME",
                                          style: TextStyle(
                                              fontSize: 36,
                                              color: Colors.white.withAlpha(220),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2),             
                                        ),                                   

                                      ),                                    
                                      SizedBox(
                                        height: 10,
                                      ),                                   

                                      Text(
                                        'Login to Continue',
                                        style: TextStyle(fontSize: 18),
                                      ),                                    

                                      SizedBox(
                                        height: 50,
                                      ),                                    

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                        child: TextField(
                                          onChanged: (val) {
                                            email = val;
                                          },
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white.withAlpha(125),
                                            hintText: 'Email',

                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                            ),                                
                                            icon: Icon(
                                              Icons.person,     
                                              size: 40,
                                              color: Colors.white,
                                            ),                                 
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide.none,
                                            ),                              
                                          ),                               
                                        ),                                 
                                      ),                                    
                                      SizedBox(
                                        height: 10,
                                      ),                                    
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                          child: TextField(
                                            obscureText: true,
                                            onChanged: (val) {
                                              password = val;
                                            },
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white.withAlpha(125),
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                              ),                             
                                              icon: Icon(
                                                Icons.lock,
                                                size: 40,
                                                color: Colors.white,
                                              ),                             
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide.none,
                                              ),                             
                                            ),                               
                                          ),                                 
                                        ),                                   
                                      ),                                     
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),                                 
                                        ],                                   
                                      ),                                     

                                      Container(
                                        child: InkWell(
                                          onTap: () async {
                                            if (email == null || email == "") {
                                              final snackBar = new SnackBar(
                                                  content: new Text(
                                                    "Please fill your e-mail address above to get a password reset link",
                                                    style: TextStyle(fontSize: 15),
                                                  ),
                                                  duration: new Duration(milliseconds: 2800),
                                                  backgroundColor: Colors.grey.shade200);
                                              key.currentState.showSnackBar(snackBar);
                                            } else {
                                              await _auth.sendPasswordResetEmail(email: email);
                                              final SnackBar snackBar = new SnackBar(
                                                  content: new Text(
                                                    """
Check your e-mail to reset your password""",
                                                    style: TextStyle(fontSize: 16),
                                                  ),                                        
                                                  duration: new Duration(milliseconds: 2800),
                                                  backgroundColor: Colors.grey.shade200);  
                                              key.currentState.showSnackBar(snackBar);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Forgot Password?'),
                                          ),                                               
                                        ),                                                 
                                      ),                                                   
                                      SizedBox(
                                        height: 5,
                                      ),                                                   
                                      Container(
                                        child: InkWell(
                                          onTap: (){
                                            var push = Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MobileLogin()));
                
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text("Sign-up using Mobile"),
                                          ),                                            
                                        ),                                               
                                      ),                                                
                                      SizedBox(
                                        height: 5,
                                      ),                                                
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OldLoginMobile()));
                
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text("Login using Mobile"),
                                        ),                                      
                                      ),                                        
                                      SizedBox(
                                        height: 40,
                                      ),                                        
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            setState(() {
                                              loading = true;
                                            });
                                            var user =
                                                (await _auth.signInWithEmailAndPassword(
                                                        email: email, password: password))
                                                    .user;
                                            if (!user.isEmailVerified) {
                                              final snackBar = new SnackBar(
                                                  content: new Text(
                                                    "Please verify your account first",
                                                    style: TextStyle(fontSize: 15),
                                                  ),
                                                  duration: new Duration(milliseconds: 1800),
                                                  backgroundColor: Colors.grey.shade200);
                                              key.currentState.showSnackBar(snackBar);
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              var push = Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Profile()));
                                            }
                                          }
                                           catch (e) {
                                            print(e);
                                            final snackBar = new SnackBar(
                                                content: new Text(
                                                  "An error has occured, please try again later.",
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                                duration: new Duration(milliseconds: 1800),
                                                backgroundColor: Colors.grey.shade200);
                                            key.currentState.showSnackBar(snackBar);
                                          }
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                                      widget(
                                                                              child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => RegisterPage()));
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
                                                "REGISTER",
                                                style: TextStyle(color: Colors.white),
                                              ),                                 
                                            ),                                   
                                          ),                                     
                                        ),                                       
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),                                         
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Back to Home",
                                            style: TextStyle(fontSize: 18),
                                          )),                              
                                      SizedBox(
                                        height: 20,
                                      )                                   
                                    ],                                    
                                  ),                                     
                                ),                                     
                              ),                                      
                            ),                                        
                          );                                          
    Center center;
    center = Center(
                          child: modalProgressHUD,
                        );
        var safeArea4 = SafeArea(
                              child: <Widget>[
                                center,
                          ],                                         
                        );                                           
                SafeArea safeArea3 = safeArea4;
        SafeArea safeArea2;
        safeArea2 = safeArea3;
        SafeArea safeArea = safeArea2;
        return safeArea;
  }
}
