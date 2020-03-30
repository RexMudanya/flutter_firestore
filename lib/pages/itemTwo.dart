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

  List<MaterialColor> colorItem = [
    Colors.deepOrange,
    Colors.amber,
    Colors.pink,
    Colors.purple,
    Colors.yellow,
    Colors.lightBlue,
    Colors.pink
  ];
  MaterialColor color;


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

                var ourdata = snapshot.data[index];

                color = colorItem[index % colorItem.length];

                return Container(
                 height: 420,
                  margin: EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        // first container
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        child: Text(ourdata.data["title"][0], style: TextStyle(fontSize: 20.0),),
                                        backgroundColor: color,
                                      ),
                                    ),

                                    SizedBox(width: 5,),
                                    Container(
                                      child: Text(ourdata.data['title'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Icon(Icons.more_horiz, size: 35,),
                              )

                            ],
                          ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(ourdata.data['image'],
                            height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0,),

                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(ourdata.data['desc'],
                          maxLines: 4,
                            style: TextStyle(
                            fontSize: 17,
                            color: Colors.black
                          ),
                          ),
                        )

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
