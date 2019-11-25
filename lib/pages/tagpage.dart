
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlytag2/widget/tag.dart';
import 'package:onlytag2/models/tag_model.dart';

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
  var hashList = List<TagModel>();
  StreamSubscription<QuerySnapshot> subscription;

  List<TagModel> snapshot;

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
        snapshot = datasnapshot.documents.map((d) => TabModel(
          title: d['title'],
          id: d.documentID
        )).toList();
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
                    for (var item in hashList) Container(
                      padding: EdgeInsets.all(10),
                      height: 45,
                      child: Text(item.title, style: TextStyle(color: Color(0xffff9900), fontSize: 20, fontFamily: 'Dokyo'),),
                        decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffff9900),),
                      borderRadius: BorderRadius.circular(10))
                    ),
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
                    list: hashList,
                    tag: snapshot[index],
                  );
                },
              )
    ))]),

    );
  }
}

