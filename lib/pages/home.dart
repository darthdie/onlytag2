import 'package:flutter/material.dart';
import 'package:onlytag2/pages/category.dart';
import 'package:onlytag2/widget/maincard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;

  Query collectionReference = Firestore.instance.collection("mainCategories").orderBy("title");

  void initState() {
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        snapshot = datasnapshot.documents;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel(); //Streams must be closed when not needed
    super.dispose();
  }

  passData(DocumentSnapshot snap, String cat, String title) {
    print(cat);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Category(snapshot: snap, category: cat, title: title,)));
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot == null) return Center(
      child: Container(
        color: Colors.black,
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          color: Colors.black,
          constraints: BoxConstraints(
              maxHeight: 300.0,
              maxWidth: 200.0,
              minWidth: 150.0,
              minHeight: 150.0
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xff0E0E0F),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "#",
              style: TextStyle(
                  fontSize: 25, color: Color(0xffff9900), fontFamily: 'Dokyo'),
            ),
            Text(
              "onlytags",
              style: TextStyle(color: Colors.white, fontFamily: 'Dokyo'),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => passData(snapshot[index], snapshot[index].documentID.toString(), snapshot[index].data["title"] ),
                          child: MainCard(
                            title: snapshot[index].data["title"],
                            subtitle: snapshot[index].data["subTitle"],
                            image: snapshot[index].data["image"],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
