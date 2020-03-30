import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemOne extends StatefulWidget {
  @override
  _ItemOneState createState() => _ItemOneState();
}

class _ItemOneState extends State<ItemOne> {
  Future getPost() async{

    var firestore = Firestore.instance;

    QuerySnapshot snap = await firestore.collection("itemone").getDocuments();

    return snap.documents;
  }

  Future<Null>getRefresh() async{

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPost(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return RefreshIndicator(
                child: ListView.builder(
                    itemBuilder: (context, index){

                      var ourData = snapshot.data[index];

                      return Container(
                        height: 170,
                        margin: EdgeInsets.all(5),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(ourData.data['image'],
                                    height: 170,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(ourData.data['title'],
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ),

                                    SizedBox(height: 5,),

                                    Container(
                                      child: Text(ourData.data['description'],
                                        maxLines: 5,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              )

                            ],
                          ),
                        )
                      );
                    },
                    itemCount: snapshot.data.length,
                ),
                onRefresh: getRefresh);
          }

        },
      ),
    );
  }
}



