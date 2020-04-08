import 'package:flutter/material.dart' show BuildContext, StatelessWidget, Widget;
import 'package:flutter/src/widgets/framework.dart' show BuildContext, State, StatefulWidget, StatelessWidget, Widget;

class DataModel extends StatefulWidget {
  final String name;
  final String location;
  final String status;
  final List images;
  final String reward;
  final String desc;
  final String uid;
  final String phone;

  DataModel(this.name, this.location, this.status, this.images, this.reward, this.desc, this.uid, this.phone);

  @override
  Future<_DataModelState> createState() async => _DataModelState();
}

mixin _DataModelState implements State<DataModel> {
  @override 
  Widget build(BuildContext context) {
    return null;
  }}