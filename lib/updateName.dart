import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_india/profile.dart';

class UpdateName extends StatefulWidget {
  final uid, name, number;

  UpdateName(this.uid, this.name, this.number);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  final fireStore = Firestore.instance;
  bool loading=false
  ;

  TextEditingController name;
  TextEditingController mobile;

  uploadData() async {
    await fireStore.collection('users').document(widget.uid).updateData({
      'name': name.text,
      'mobile': mobile.text,
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Profile()));

  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    mobile = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Personal Info"),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: name,
                  decoration: InputDecoration(hintText: "Enter your Name"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: mobile,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  decoration:
                      InputDecoration(hintText: "Enter mobile number to update"),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                    color: Colors.green.shade700,
                    onPressed: () {
                      setState(() {
                        loading=true;
                      });
                      uploadData();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Update My Info"),
                    ))
              ],
            ),
          ),
          loading? Center(
            child: CircularProgressIndicator(),
          ): Container(height: 0,)
        ],
      ),
    );
  }
}
