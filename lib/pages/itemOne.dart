import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

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
                      color = colorItem[index % colorItem.length];

                      return Container(
                        height: 200,
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
                                    height: 200,
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
                                    ),
                                    
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: InkWell(
                                        onTap: (){
                                          customDialog(
                                              context,
                                              ourData.data['image'],
                                              ourData.data['title'],
                                            ourData.data['description']
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          margin: EdgeInsets.all(9),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: color,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Text("view details",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white
                                            ),
                                          ),
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

  customDialog(BuildContext context, String img, String title, String des){
    return showDialog(
        context: context,
      builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
              height: MediaQuery.of(context).size.height/1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.deepOrange,
                      Colors.lightBlue
                    ]
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 150,
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(img,
                      fit: BoxFit.cover,
                      height: 150,
                        width: MediaQuery.of(context).size.width,
                      ),
                      ),
                    ),

                    SizedBox(height: 6,),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(title.toUpperCase(),
                      style: TextStyle(fontSize: 20),
                      ),
                    ),

                    SizedBox(height: 6,),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(des,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
      }
    );
  }
}



