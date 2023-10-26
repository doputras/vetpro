import 'package:flutter/material.dart';
import 'package:vetpro/constan/constan.dart';

class DetailDombaInpectionPage extends StatelessWidget {
  const DetailDombaInpectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detail Domba Inpection',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Text(
                  '16 October 2023',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 231, 229, 229),
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Hasil pemeriksaan hewan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              initialValue:
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              maxLines: 5,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 30,
                              top: 15,
                            ),
                            child: Text(
                              'Perawatan medis',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Perawatan kandang',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Pemberian makan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Perawatan lingkungan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Saran tambahan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'lokasi',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, right: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Nama Pemeriksaan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 15, right: 30, bottom: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 30, top: 15, bottom: 15),
                            child: Text(
                              'Bukti Gambar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 15, right: 30, bottom: 30),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                        ],
                      ),
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