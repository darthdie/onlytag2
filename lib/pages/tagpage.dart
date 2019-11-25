
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlytag2/widget/tag.dart';

class TagPage extends StatefulWidget {
  DocumentSnapshot snapshot;
  final String category;
  final String title;
  final String tag;

  TagPage({this.snapshot, this.category, this.title, this.tag});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  List hashList = new List();
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;

  Query collectionReference;

  void initState() {
    collectionReference = Firestore.instance
        .collection("mainCategories")
        .document(widget.category)
        .collection("subCategories")
        .document(widget.tag)
        .collection('tags').orderBy("title");
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
                "#",
                style: TextStyle(
                    fontSize: 25,
                    color: Color(0xffff9900),
                    fontFamily: 'Dokyo'),
              ),
              Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontFamily: 'Dokyo'),
              )
            ],
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: Wrap(
                  children: <Widget>[
                    for (var item in hashList) Container(child: item),
                  ],
                )
          )),
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                itemCount: snapshot.length,
                itemBuilder: (context, index) {
                  return Tag(
                    callback: (list) => setState(() => hashList = list),
                    tag: snapshot[index].data["title"],
                    list: hashList,
                    id: index,
                  );
                },
              )
    ))]),

    );
  }
}

