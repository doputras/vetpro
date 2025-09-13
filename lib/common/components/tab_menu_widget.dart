import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/views/history/history_page.dart';
import 'package:vetpro/views/home/home_page.dart';
import 'package:vetpro/views/invoice/invoice_page.dart';
import 'package:vetpro/views/schedule/schedule_page.dart';
import '../constants/colors.dart';

class TabMenuWidget extends StatelessWidget {
  final String menu;
  const TabMenuWidget({required this.menu, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (menu == '1') ? secondaryColor : Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
        height: 80,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 251, 244, 244),
            borderRadius: BorderRadius.circular(25)),
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.to(const HomePage()),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/home.png'),
                      (menu == '1')
                          ? Image.asset('assets/Rectangle.png')
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(const HistoryPage()),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/history.png'),
                      (menu == '2')
                          ? Image.asset('assets/Rectangle.png')
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(const SchedulePage()),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/calender.png'),
                      (menu == '3')
                          ? Image.asset('assets/Rectangle.png')
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.to(const InvoicePage()),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/task.png'),
                      (menu == '4')
                          ? Image.asset('assets/Rectangle.png')
                          : const SizedBox(),
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
