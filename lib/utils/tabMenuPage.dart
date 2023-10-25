import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/views/historyPage.dart';
import 'package:vetpro/views/homePage.dart';
import 'package:vetpro/views/invoicePage.dart';
import 'package:vetpro/views/schedulePage.dart';

import '../constan/constan.dart';

class TabMenuPage extends StatelessWidget {
  String menu;
  TabMenuPage({required this.menu, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (menu == '1') ? secondColor : Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
        height: 80,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 251, 244, 244),
            borderRadius: BorderRadius.circular(25)),
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.to(HomePage()),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/home.png'),
                      (menu == '1')
                          ? Image.asset('assets/Rectangle.png')
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(HistoryPage()),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/history.png'),
                      (menu == '2')
                          ? Image.asset('assets/Rectangle.png')
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(ShcedulePage()),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/calender.png'),
                      (menu == '3')
                          ? Image.asset('assets/Rectangle.png')
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(InvoicePage()),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/task.png'),
                      (menu == '4')
                          ? Image.asset('assets/Rectangle.png')
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
