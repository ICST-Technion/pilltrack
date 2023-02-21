import 'package:flutter/material.dart';

class BoxCell2 extends StatelessWidget {
  final String id;
  final String imageURL;

// Image.asset image;
  BoxCell2({required this.id,required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return
      GridTile(
        child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        //padding: EdgeInsets.all(15.0),
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(2)
        ),
        child: Image.asset(this.imageURL),
        ),
    );
  }
}
