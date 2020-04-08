import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, BoxShadow, BoxShape, BuildContext, Colors, Column, Container, Dialog, EdgeInsets, FontWeight, InkWell, Locale, MainAxisAlignment, MainAxisSize, Navigator, Offset, Padding, RoundedRectangleBorder, SizedBox, StatelessWidget, Text, TextAlign, TextStyle, Widget;
import 'package:flutter/src/widgets/framework.dart';

var english = Locale("en", "IN");
var hindi = Locale("hi", "IN");
var bengali = Locale("bn", "IN");

class CustomDialog extends StatefulWidget {
  final String title, one, two, three;

  CustomDialog(
    this.title,
    this.one,
    this.two,
    this.three,
  );

  @override
  Future<_CustomDialogState> createState() async => _CustomDialogState();
}

mixin _CustomDialogState implements State<CustomDialog> {
  @override
  Future<Widget> build(BuildContext context) async {
    var column2 = Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // To make the card compact
                    children: <Widget>[
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),                               
                      ),                                 
                      SizedBox(height: 16.0),
                      InkWell(
                        onTap: () {
                          EasyLocalization.of(context).locale = english;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.one,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          EasyLocalization.of(context).locale = hindi;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.two,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      widget(
                                              child: InkWell(
                          onTap: () {
                            EasyLocalization.of(context).locale = bengali;
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              widget.three,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  );
        Column column;
        column = column2;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Consts.padding),
          ),                                                         
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
              top: 20 + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),                                                       
            margin: EdgeInsets.only(top: 40),
            decoration: new BoxDecoration(
              color: Colors.black45.withOpacity(.85),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),                                                    
              ],
            ),                                                        
            children: <Widget>[
              column,
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 12.0;
  static const double avatarRadius = 66.0;
}
