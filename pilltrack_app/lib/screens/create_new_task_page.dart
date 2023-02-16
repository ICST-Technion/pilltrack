import 'package:flutter/material.dart';
import 'package:iot/theme/colors/light_colors.dart';
import 'package:iot/widgets/top_container.dart';
import 'package:iot/widgets/back_button.dart';
import 'package:iot/widgets/my_text_field.dart';
import 'package:iot/screens/home_page.dart';



class CreateNewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              //padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Set Pills Time',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: MyTextField(
                        label: 'Morning Dose Time',
                        icon: downwardIcon,
                      )),
                      SizedBox(width: 40),
                      Expanded(
                        child: MyTextField(
                          label: 'Evening Dose Time',
                          icon: downwardIcon,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                ],
              ),
            )),
            Container(
              height: 80,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MaterialButton(
                    onPressed: (){
                      //Navigator.pushNamed(context, '');
                    },
                    height: 45,
                    minWidth: 140,
                    child: const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    textColor: Colors.white,
                    color: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  MaterialButton(
                    onPressed: (){
                      //Navigator.pushNamed(context, '');
                    },
                    height: 45,
                    minWidth: 140,
                    child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    textColor: Colors.white,
                    color: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



