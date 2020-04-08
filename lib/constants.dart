import 'package:flutter/material.dart' show Border, BorderRadius, BorderSide, BoxDecoration, Colors, EdgeInsets, FontWeight, InputBorder, InputDecoration, OutlineInputBorder, Radius, TextStyle;

const TextStyle kSendButtonTextStyle = TextStyle(
  color: Colors.greenAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const InputDecoration kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: "Type your message here...",
  border: InputBorder.none,
);                                                                 

const BoxDecoration kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.greenAccent, width: 2.0),
  ),                                                                
);                                                                  

const InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: "Enter your email",
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),                                                                   
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.greenAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),                                                                   
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.greenAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),                                                                   
);                                                                     
