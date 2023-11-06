import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/controller/calendar_controller.dart';

import '../../common/components/list_card_widget.dart';
import '../../common/components/tab_menu_widget.dart';

class ShcedulePage extends StatelessWidget {
  const ShcedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarC = Get.put(CalendarController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondaryColor,
        title: const Text(''),
        elevation: 0,
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                size: 45,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView(
        children: [
          Container(
              decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: calendarC.buildDefaultSingleDatePickerWithValue()),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, top: 25, right: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today Schedule',
                        style: blackTextStyle.copyWith(
                            fontSize: 18, fontWeight: bold),
                      ),
                      Image.asset('assets/add.png')
                    ],
                  ),
                ),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 15),
                  child: Text(
                    'Upcoming Schedule',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 15),
                  child: Text(
                    '23 October 2023',
                    style: blackTextStyle,
                  ),
                ),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                Container(
                  margin: const EdgeInsets.only(left: 5, top: 15),
                  child: Text(
                    '24 October 2023',
                    style: blackTextStyle,
                  ),
                ),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                ListCardWidget(
                    color: secondaryColor,
                    flag: '2',
                    text1: 'Domba',
                    text2: 'Telkom University',
                    text3: 'Drh. Buhori Muslim',
                    image: 'assets/domba.png',
                    widget: InkWell(
                        //onTap: () => Get.to(const DetailAnimalInpectionPage()),
                        child: Image.asset('assets/file.png'))),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TabMenuWidget(menu: '3'),
    );
  }
}
