import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/constan/constan.dart';
import 'package:vetpro/utils/listCardPage.dart';
import 'package:vetpro/utils/tabMenuPage.dart';
import 'package:vetpro/views/detailDombaInpectionPage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'History',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.search,
                          size: 45,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        '16 October 2023',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListCardPage(
                      color: secondColor,
                      flag: '2',
                      text1: 'Domba',
                      text2: 'Telkom University',
                      text3: 'Drh buhori Muslim',
                      widget: InkWell(
                          onTap: () => Get.to(DetailDombaInpectionPage()),
                          child: Image.asset('assets/file.png')),
                    ),
                    ListCardPage(
                      color: secondColor,
                      flag: '2',
                      text1: 'Domba',
                      text2: 'Telkom University',
                      text3: 'Drh buhori Muslim',
                      widget: InkWell(
                          onTap: () => Get.to(DetailDombaInpectionPage()),
                          child: Image.asset('assets/file.png')),
                    ),
                    ListCardPage(
                      color: secondColor,
                      flag: '2',
                      text1: 'Domba',
                      text2: 'Telkom University',
                      text3: 'Drh buhori Muslim',
                      widget: InkWell(
                          onTap: () => Get.to(DetailDombaInpectionPage()),
                          child: Image.asset('assets/file.png')),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        '15 October 2023',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListCardPage(
                      color: secondColor,
                      flag: '2',
                      text1: 'Domba',
                      text2: 'Telkom University',
                      text3: 'Drh buhori Muslim',
                      widget: InkWell(
                          onTap: () => Get.to(DetailDombaInpectionPage()),
                          child: Image.asset('assets/file.png')),
                    ),
                    ListCardPage(
                      color: secondColor,
                      flag: '2',
                      text1: 'Domba',
                      text2: 'Telkom University',
                      text3: 'Drh buhori Muslim',
                      widget: InkWell(
                          onTap: () => Get.to(DetailDombaInpectionPage()),
                          child: Image.asset('assets/file.png')),
                    ),
                    ListCardPage(
                      color: secondColor,
                      flag: '2',
                      text1: 'Domba',
                      text2: 'Telkom University',
                      text3: 'Drh buhori Muslim',
                      widget: InkWell(
                          onTap: () => Get.to(DetailDombaInpectionPage()),
                          child: Image.asset('assets/file.png')),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: TabMenuPage(menu: '2'),
    );
  }
}
