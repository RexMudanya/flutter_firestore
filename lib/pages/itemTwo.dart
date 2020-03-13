import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class ItemTwo extends StatefulWidget {
  @override
  _ItemTwoState createState() => _ItemTwoState();
}

class _ItemTwoState extends State<ItemTwo> {

  Future getHomePost() async{

    var firestore = Firestore.instance;

    QuerySnapshot snap = await firestore.collection("HomeData").getDocuments();

    return snap.documents;

  }

  Future <Null>getRefresh()async{

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      getHomePost();
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

    body: FutureBuilder(
      future: getHomePost(),
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            // ignore: missing_return
            child: CircularProgressIndicator(),
          );
        }else{
          return RefreshIndicator(
            onRefresh: getRefresh,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return Card(
                  elevation: 10,
                  margin: EdgeInsets.all(10),
                  child: Container(
                    child: Column(
                      children: <Widget>[

                        Text(snapshot.data[index].data["title"])
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    ),

    );
  }
}
