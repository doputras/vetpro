import 'package:flutter/material.dart';

import '../constan/constan.dart';

class TabMenuPage extends StatelessWidget {
  const TabMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondColor,
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/home.png'),
              Image.asset('assets/history.png'),
              Image.asset('assets/calender.png'),
              Image.asset('assets/task.png')
            ],
          ),
        ),
      ),
    );
  }
}
