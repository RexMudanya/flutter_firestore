import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firestore/pages/itemOne.dart';
import 'package:flutter_firestore/pages/itemTwo.dart';
import 'package:flutter_firestore/pages/itemThree.dart';


class Home extends StatefulWidget{
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home>{

  int _indexpage = 1;

  final pageOptions = [
    ItemOne(),
    ItemTwo(),
    ItemThree()
  ];

  @override
  Widget build(BuildContext context){
    return new Scaffold(

      appBar: AppBar(

        title: Text("App"),
        backgroundColor: Colors.deepOrange,
      ),

      drawer: Drawer(

      ),

      body: pageOptions[_indexpage],

      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.poll, size: 30, color: Colors.white,),
          Icon(Icons.home,size: 30, color: Colors.white,),
          Icon(Icons.library_books,size: 30, color: Colors.white,)
        ],

        color: Colors.deepOrange,
        buttonBackgroundColor: Colors.amber,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        index: 1,

        onTap: (int index){
          setState(() {
            _indexpage = index;
          });
        },
      ),

    );
  }
}
