import 'package:flutter/material.dart';

class MainCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final Widget page;

  MainCard(
      {Key key,this.title, this.subtitle, this.image, this.page})
      : super(key: key);

  _MainCardState createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          padding: EdgeInsets.fromLTRB(60, 35, 0, 0),
          height: 120,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.8), BlendMode.dstATop),
                image: NetworkImage(widget.image),
                fit: BoxFit.cover,
              )),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                      color: Color(0xffff9900),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 8,
                            color: Colors.black)
                      ]),
                ),
              ],
          )),
    );
  }
}
