import 'package:flutter/material.dart';

import '../constan/constan.dart';

class ListCardPage extends StatelessWidget {
  const ListCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        height: 90,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
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
                'assets/domba.png',
                scale: 1.3,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Domba'),
                  Text('16 October 2023'),
                  Text('Drh Buhori Muslim')
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset('assets/file.png'))
          ],
        ));
  }
}
