import 'package:flutter/material.dart';
import 'package:iot/theme/colors/light_colors.dart';

class TopContainer extends StatelessWidget {

   final double height;
   final double width;
   final Widget child;


   const TopContainer({this.height=2 , this.width=2, required this.child});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: LightColors.kDarkYellow,
        //color: Color(0xffc496b8),
            borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
