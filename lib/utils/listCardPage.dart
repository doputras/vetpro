import 'package:flutter/material.dart';

import '../constan/constan.dart';

class ListCardPage extends StatelessWidget {
  String text1;
  String text2;
  String text3;
  String flag;
  Color color;
  ListCardPage(
      {required this.color,
      required this.flag,
      required this.text1,
      required this.text2,
      required this.text3,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        height: 90,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  color: threeColor, borderRadius: BorderRadius.circular(20)),
              child: Image.asset(
                (flag == '3') ? 'assets/invoice.png' : 'assets/domba.png',
                scale: 1.3,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: TextStyle(
                        fontSize: (flag == '3') ? 18 : 16,
                        color: (flag == '1' || flag == '3')
                            ? (flag == '3')
                                ? Color.fromARGB(255, 48, 73, 119)
                                : Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    text2,
                    style: TextStyle(
                        color: (flag == '1') || flag == '3'
                            ? Colors.black
                            : Colors.white),
                  ),
                  Text(
                    text3,
                    style: TextStyle(
                        color: (flag == '1' || flag == '3')
                            ? Colors.black
                            : Colors.white),
                  )
                ],
              ),
            ),
            Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.only(right: 20),
                child: Image.asset('assets/file.png'))
          ],
        ));
  }
}
