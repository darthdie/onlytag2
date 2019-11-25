import 'package:flutter/material.dart';
import 'package:onlytag2/pages/tagpage.dart';
import 'package:onlytag2/widget/sub.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Category extends StatefulWidget {
  DocumentSnapshot snapshot;
  final String category;
  final String title;

  Category({this.snapshot, this.category, this.title});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>{

  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;

  Query collectionReference;

  void initState() {
    collectionReference = Firestore.instance.collection("mainCategories").document(widget.category).collection("subCategories").orderBy("title");
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

  passData(DocumentSnapshot snap, String cat, String tag, String title) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TagPage(snapshot: snap, category: cat, tag: tag, title: title)));
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
        iconTheme: IconThemeData(
          color: Color(0xffff9900),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "#", style: TextStyle(fontSize: 25, color: Color(0xffff9900), fontFamily: 'Dokyo'),
            ),
            Text(widget.title.toLowerCase(), style: TextStyle(color: Colors.white, fontFamily: 'Dokyo'),)
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
                          onTap: () => passData(snapshot[index], widget.category, snapshot[index].documentID.toString() ,snapshot[index].data["title"]),
                          child: Sub(
                            title: snapshot[index].data["title"],
                            subtitle: snapshot[index].data["subTitle"],
                            image: snapshot[index].data["image"],
                          ),
                        );
                      }),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
