import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/constan/constan.dart';
import 'package:vetpro/utils/listCardPage.dart';
import 'package:vetpro/utils/tabMenuPage.dart';
import 'package:vetpro/views/dombaInpectionPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 40, right: 15, left: 15, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/logo2.png'),
                      Image.asset('assets/logo-telkom.png')
                    ],
                  ),
                ),
                Text(
                  'Inspection',
                  style: TextStyle(
                      fontSize: 40,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    height: MediaQuery.of(context).size.height / 1.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              'Category',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          GridView.count(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            childAspectRatio: 3 / 2,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Get.to(DombaInpectionPage()),
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 65,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              'assets/domba.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Domba',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/rusa.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Rusa',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/angsa.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Angsa',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/burung.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Burung',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/kelinci.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Kelinci',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/lainnya.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Lainnya',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Recent Inspection',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListCardPage(
                                  color: Colors.white,
                                  flag: '1',
                                  text1: 'Domba',
                                  text2: '16 October 2023',
                                  text3: 'Drs. Buhori Muslim',
                                ),
                              ],
                            ),
                          )
                        ]))
              ],
            ),
          ),
        ),
        bottomNavigationBar: TabMenuPage(
          menu: '1',
        ));
  }
}
