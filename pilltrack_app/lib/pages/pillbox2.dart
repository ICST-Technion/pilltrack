import 'package:flutter/material.dart';
import 'package:iot/screens/calendar_page.dart';
import 'package:iot/theme/colors/light_colors.dart';
import 'package:iot/widgets/box_cell.dart';
import 'package:iot/widgets/box_cell2.dart';
import 'package:iot/widgets/menu_row.dart';
import 'package:iot/widgets/top_container.dart';
import 'package:iot/models/box_cell_model.dart';

class PillBox extends StatelessWidget {
  final List<Cell_info> box_cells = [
    //Cell_info(id: 'morning', dosetime: '12:00', is_filled: false, open_next: true, imageURL: 'non'),
    //Cell_info(id: 'evening', dosetime: '20:00', is_filled: false, open_next: false, imageURL: 'non'),
    Cell_info(id: 'sun_morning', dosetime: '12:00', is_filled: false, open_next: true, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'sun_evening', dosetime: '20:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'mon_morning', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'mon_evening', dosetime: '20:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'teus_morning', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'teus_evening', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'wed_morning', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'wed_evening', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'thur_morning', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'thur_evening', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'fri_morning', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'fri_evening', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'sat_morning', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    Cell_info(id: 'sat_evening', dosetime: '12:00', is_filled: false, open_next: false, imageURL: 'assets/images/pill3.png'),
    //add evening
  ];

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width*0.1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Lovely Pill Box'),
      ),
      backgroundColor: LightColors.kLightYellow,
      body: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: box_cells.length,
                      controller: new ScrollController(keepScrollOffset: false),
                      itemBuilder: (context,i)=>BoxCell2(id:box_cells[i].id,imageURL: box_cells[i].imageURL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1/4, crossAxisSpacing: 2, mainAxisSpacing: 2),
      ),
    );
  }
}
