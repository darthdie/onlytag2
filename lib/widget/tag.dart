import 'package:flutter/material.dart';
import 'package:onlytag2/models/tag_model.dart';

class Tag extends StatefulWidget {
  List list;
  Function(List) callback;
  final TagModel tag;

  Tag(
      {Key key,
        @required this.tag,
        this.list, this.callback
      })
      : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 50,
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffff9900) : Colors.black,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          _handleOnPressed();
          print(widget.id.toString() + "is Selected");
          widget.callback?.call(widget.list);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.tag.title,
                  style: TextStyle(
                      fontSize: 20,
                      color: isSelected ? Colors.black : Colors.white,
                      fontFamily: 'Dokyo'),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: AnimatedIcon(
                  icon: AnimatedIcons.home_menu,
                  progress: _animationController,
                  color: isSelected ? Colors.black : Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  void _handleOnPressed() {
    setState(() {
      isSelected = !isSelected;
      isSelected
          ? _animationController.forward()
          : _animationController.reverse();
      isSelected ? widget.list.add(widget.tag): widget.list.removeWhere((t) => t.id == widget.tag.id);
    });
  }
}
