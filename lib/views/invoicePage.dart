import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/utils/listCardPage.dart';
import 'package:vetpro/utils/tabMenuPage.dart';
import 'package:vetpro/views/addInvoicePage.dart';

import 'detailDombaInpectionPage.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Unpaid',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 66, 87, 125)),
                  ),
                  Image.asset('assets/logo2.png')
                ],
              ),
            ),
            ListCardPage(
              color: const Color.fromARGB(255, 223, 220, 220),
              flag: '3',
              text1: 'Drh. Buhori Muslim',
              text2: 'Telkom University',
              text3: '16 September 2023',
              widget: InkWell(
                  onTap: () => Get.to(DetailDombaInpectionPage()),
                  child: Image.asset('assets/file.png')),
            ),
            ListCardPage(
                color: const Color.fromARGB(255, 223, 220, 220),
                flag: '3',
                text1: 'Drh. Buhori Muslim',
                text2: 'Telkom University',
                text3: '16 September 2023',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paid',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 66, 87, 125)),
                  )
                ],
              ),
            ),
            ListCardPage(
                color: Color.fromARGB(255, 116, 204, 119),
                flag: '3',
                text1: 'Drh. Buhori Muslim',
                text2: 'Telkom University',
                text3: '16 September 2023',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: Color.fromARGB(255, 116, 204, 119),
                flag: '3',
                text1: 'Drh. Buhori Muslim',
                text2: 'Telkom University',
                text3: '16 September 2023',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: Color.fromARGB(255, 116, 204, 119),
                flag: '3',
                text1: 'Drh. Buhori Muslim',
                text2: 'Telkom University',
                text3: '16 September 2023',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
            ListCardPage(
                color: Color.fromARGB(255, 116, 204, 119),
                flag: '3',
                text1: 'Drh. Buhori Muslim',
                text2: 'Telkom University',
                text3: '16 September 2023',
                widget: InkWell(
                    onTap: () => Get.to(DetailDombaInpectionPage()),
                    child: Image.asset('assets/file.png'))),
          ],
        )),
      ),
      bottomNavigationBar: TabMenuPage(menu: '4'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Get.to(AddInvoicePage()),
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
