import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/constan/constan.dart';
import 'package:vetpro/controller/calendarController.dart';
import 'package:vetpro/utils/listCardPage.dart';
import 'package:vetpro/utils/tabMenuPage.dart';

import 'detailDombaInpectionPage.dart';

class ShcedulePage extends StatelessWidget {
  const ShcedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarC = Get.put(CalendarController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondColor,
        title: Text(''),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                size: 45,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: calendarC.buildDefaultSingleDatePickerWithValue()),
            Container(
              margin: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Image.asset('assets/add.png')
                ],
              ),
            ),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            Container(
              margin: EdgeInsets.only(left: 20, top: 15),
              child: Text(
                'Upcoming Schedule',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 15),
              child: Text(
                '23 October 2023',
                style: TextStyle(fontSize: 14),
              ),
            ),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            Container(
              margin: EdgeInsets.only(left: 20, top: 15),
              child: Text(
                '24 October 2023',
                style: TextStyle(fontSize: 14),
              ),
            ),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: secondColor,
                flag: '2',
                text1: 'Domba',
                text2: 'Telkom University',
                text3: 'Drh. Buhori Muslim',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
          ],
        )),
      ),
      bottomNavigationBar: TabMenuPage(menu: '3'),
    );
  }
}
