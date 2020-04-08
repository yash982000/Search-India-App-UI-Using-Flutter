
import 'package:flutter/material.dart' show AppBar, AssetImage, BoxFit, BuildContext, Colors, Column, CrossAxisAlignment, EdgeInsets, Expanded, Icon, IconButton, Icons, Image, MainAxisAlignment, MaterialPageRoute, Navigator, Padding, Row, Scaffold, State, StatefulWidget, Text, TextStyle, Widget;
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart' show FlutterOpenWhatsapp;
import 'package:search_india/chat.dart' show Chat;
import 'package:search_india/my_flutter_app_icons.dart' show MyFlutterApp;
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;

mixin AboutUs implements StatefulWidget {
  @override
  Future<_AboutUsState> createState() async => _AboutUsState();
}
//
mixin _AboutUsState implements State<AboutUs> {
  @override
  Future<Widget> build(BuildContext context) {
    var scaffold = Scaffold(
          appBar: AppBar(
            title: Text('Search India'),
            actions: <Widget>[
              Center(
                child: IconButton(
                  icon: Icon(Icons.message,color: Colors.tealAccent,),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat('Admin',false)));
                  },
                ),                                                                 
              ),                                                                   
            ],                                                                   
          ),                                                                       
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('images/splash.png'),
                  fit: BoxFit.fill,
                  height: 200,
                  width: 200,
                ),                                                               
              ),                                                                 
              Center(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Search India is the digital platform for lost and found. We provide our service all over India.\n\nWe provide the most efficient service when it comes to searching for your lost items. Search India provides service to both rural and urban areas. Documents, items lost once logged with us will be returned  to your address within a span of time. We also provide a option for our customers to log for any missing loved ones. Once the issue is logged with us, we provide the option for you to check the updates on your logged case. If any lost items is found, you can register the item with us and can get rewards from the customer.You "
                        'can use our feedback to rate our services too.\n\nSearch karo India.\n',style: TextStyle(fontSize: 16,letterSpacing: 0.8
                    ,),),
    
                  ),                                                               
                ),                                                                 
              ),                                                                   
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.phone,color: Colors.tealAccent,),
                        onPressed: ()async{
                          var url = 'tel:8837342435';
                          var x = await canLaunch(url);
                                                    if (x) {
                            await launch(url);
                          }
                           else {
                            throw "Could not launch $url";
                          }
                        },
                      ),                                                           
                    ),                                                             
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.mail,color: Colors.tealAccent,),
                        onPressed: ()async{
                          String url = "mailto:searchindia27@gmail.com?subject=SearchIndiaAppFeedback.";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw "Could not launch $url";
                          }
                        },
                      ),                                                           
                    ),                                                             
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(MyFlutterApp.whatsapp,color: Colors.tealAccent,),
                          onPressed: (){
                            var sendSingleMessage = FlutterOpenWhatsapp.sendSingleMessage("918837342435", "Feedback:\n");
                          },
                        ),                                                        
                      ],                                                         
                    ),                                                           
                  ],                                                             
                ),                                                                  
              )                                                                  
            ],                                                                  
          ),                                                                    
        );                                                                     
        return scaffold;
  }
}