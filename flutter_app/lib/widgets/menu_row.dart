import 'package:flutter/material.dart';

class MenuRow extends StatefulWidget {
  final String label;
  final String time;
  MenuRow({Key? key, required this.label, required this.time})
      : super(key: key);

  @override
  _MenuRowState createState() => _MenuRowState(label: label, time: time);
}

class _MenuRowState extends State<MenuRow> {
  final String label;
  final String time;

  _MenuRowState({required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    final scale_factor = MediaQuery.of(context).textScaleFactor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 17.0,
          backgroundColor: Color(0xFF0A1744),
          //backgroundColor: Color(0xff77205a),
          child: Icon(
            Icons.alarm,
            size: 22.0 * scale_factor,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.label,
              style: TextStyle(
                //fontSize: 17.0*scale_factor,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              this.time,
              style: TextStyle(
                //fontSize: 18.0*scale_factor,
                fontWeight: FontWeight.w600,
                color: Color(0xff5b5353),
              ),
            ),
          ],
        )
      ],
    );
  }
}
