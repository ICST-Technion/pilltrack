import 'package:flutter/material.dart';
import 'package:iot/models/box_cell_model.dart';


class BoxCell extends StatelessWidget {

  Cell_info info;
  BoxCell({required this.info});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(

        margin: EdgeInsets.symmetric(vertical: 5.0),
        //padding: EdgeInsets.all(15.0),
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(2)
        ),
        child: Image.asset(info.imageURL,)
      ),
    );
  }
}
