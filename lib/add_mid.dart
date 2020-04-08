import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseUser;
import 'package:flutter/material.dart' show AppBar, Border, BorderRadius, BoxDecoration, BuildContext, Center, Checkbox, Colors, Column, Container, CrossAxisAlignment, Divider, EdgeInsets, FontWeight, GestureDetector, MaterialPageRoute, Navigator, Padding, Radius, Row, Scaffold, SizedBox, State, StatefulWidget, Text, TextAlign, TextStyle, Widget;
import 'package:modal_progress_hud/modal_progress_hud.dart' show ModalProgressHUD;
import 'package:search_india/add_fin.dart' show FinalAdd;

class MakeAdd extends StatefulWidget {

  final Map<String,String> map;
  MakeAdd({this.map});

  @override
  Future<_MakeAddState> createState() async => _MakeAddState();
}

mixin _MakeAddState on State<MakeAdd> {

  var val = false;
  String name,mobile,city,uid1;
  final Firestore firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  var loading = false;

  void getCurrentUser() async{
    try {
      loading = true;
      FirebaseUser user;
      user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        uid1 = user.uid;
      }
    }catch(e){
      print(e);
    }
  }

  void loadData() async{
    try{
      QuerySnapshot data;
      data = await firestore.collection('users').getDocuments();
      for(DocumentSnapshot doc in data.documents){
        var doc2 = doc;
                if(doc2.documentID == uid1){
          name = doc.data['name'];
          mobile = doc.data['mobile'];
          city= doc.data['city'];
          break;
        }
      }
      setState(() {
        loading = false;
      });
    }catch(e){
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
  Widget build(BuildContext context) {
    var padding2 = Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: Text(
                                'Name: *',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 22,
                
                                    color: Colors.black
                                ),                                                    
                              ),                                                     
                            );                                                      
        var name2 = name;
                var padding3 = Padding(
                                                          padding: const EdgeInsets.only(left:10.0),
                                                          child: Text(
                                                            name2 !=null ? name : 'Loading',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                );
                                var data = 'Hide Phone number ?';
                                                                var text = Text(
                                          'Next',
                                          style: TextStyle(color: Colors.white),
                                        );
                                                                var container = Container(
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
                                    );
                                                                var column2 = Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                          children: <Widget>[
                                                                                            widget(child: SizedBox(height: 20,)),
                                                                                            Center(
                                                                                              child: Text(
                                                                                                "Requestor Information",
                                                                                                textAlign: TextAlign.left,
                                                                                                style: TextStyle(
                                                                                                    fontSize: 30,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    color: Colors.black
                                                                                                ),                                                 
                                                                                              ),                                                   
                                                                                            ),                                                     
                                                                                            widget(child: SizedBox(height: 24,)),
                                                                                            padding2,
                                                                                        padding3,
                                                                Divider(
                                                                  thickness: 1,
                                                                  color: Colors.black.withAlpha(140),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left:10.0),
                                                                  child: Text(
                                                                    'Phone: *',
                                                                    style: TextStyle(
                                                    
                                                                        fontSize: 22,
                                                                        color: Colors.black
                                                                    ),                                           
                                                                  ),                                             
                                                                ),                                               
                                                                widget(
                                                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:10.0),
                                                                    child: Text(
                                                                      mobile !=null ? mobile : 'Loading',
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          color: Colors.black
                                                                      ),                                            
                                                                    ),                                              
                                                                  ),                                               
                                                                ),
                                                                widget(
                                                                                                  child: Divider(
                                                                    thickness: 1,
                                                                    color: Colors.black.withAlpha(140),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left:10.0),
                                                                  child: Text(
                                                                    "City: *",
                                                                    style: TextStyle(
                                                    
                                                                        fontSize: 22,
                                                                        color: Colors.black
                                                                    ),                                                   
                                                                  ),                                                    
                                                                ),                                                    
                                                                Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:10.0),
                                                                    child: Text(
                                                                      city !=null ? city : 'Loading',
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          color: Colors.black
                                                                      ),                                            
                                                                    ),                                             
                                                                  ),                                            
                                                                ),                                            
                                                                Divider(
                                                                  thickness: 1,
                                                                  color: Colors.black.withAlpha(140),
                                                                ),                                              
                                                                Row(
                                                                  children: <Widget>[
                                                                    Checkbox(
                                                                      checkColor: Colors.white,
                                                                      activeColor: Colors.black,
                                                                      value: val,
                                                                      onChanged: (vary){
                                                                        setState(() {
                                                                          val = vary;
                                                                        });
                                                                      },
                                                                    ),
                                                                    Text(
                                                                      data,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black.withAlpha(140),
                                ),
                                widget(child: SizedBox(height: 30,)),
                                Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        Map<String,String> map = widget.map;
                                        var x = {
                                          'phoneval': val.toString(),
                                          'mobile':mobile,
                                        };
                                        map.addAll(x);
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FinalAdd(map:map)));
                                      },
                                      child: Center(
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                              color: Colors.black
                                          ),
                                          child: Center(
                                            child: text,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height:20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: container,
                                  ),
                                ),
                              ],
                            );
                var column = column2;
        Scaffold scaffold;
        var scaffold2 = Scaffold(
                            backgroundColor: Colors.greenAccent,
                            appBar: AppBar(title: Center(child: Text('Create Report')),),
                            body: column,
                      );
                scaffold = scaffold2;
        ModalProgressHUD modalProgressHUD;
        modalProgressHUD = ModalProgressHUD(
              inAsyncCall: loading,
              child: scaffold,
        );
        return modalProgressHUD;
  }
}
