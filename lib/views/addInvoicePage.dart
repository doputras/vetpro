import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/constan/constan.dart';
import 'package:vetpro/controller/invoiceController.dart';
import 'package:vetpro/model/cart.dart';

class AddInvoicePage extends StatelessWidget {
  const AddInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceC = Get.put(InvoiceController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondColor,
        title: Text(
          'Add Invoice',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo-telkom2.png',
                    scale: 2,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal'),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20))),
                          onTap: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: DateTime(2025),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                print(selectedDate);
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter date.';
                            }
                            return null;
                          },
                        ),
                        Text('Pemeriksaan'),
                        TextFormField(
                          decoration: InputDecoration(
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                height: 50,
                color: secondColor,
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Desc",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Harga",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Qty",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GetBuilder<InvoiceController>(builder: (invoiceC) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: invoiceC.listCart.length,
                    itemBuilder: (context, i) {
                      print(invoiceC.listCart[i]);
                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        height: 50,
                        child: DefaultTextStyle(
                          style: TextStyle(color: Colors.black),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  invoiceC.listCart[i].description!,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  invoiceC.listCart[i].harga!,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  invoiceC.listCart[i].qty!,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  invoiceC.listCart[i].total!,
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }),
              Container(
                margin: EdgeInsets.only(top: 30, left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => invoiceC.addCart(),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                              'Tambah jasa',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: 50,
                      decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Jumlah Total',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '300.000',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: BorderRadius.circular(15)),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(137, 244, 192, 192),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.save,
                          ),
                          Text(
                            'Simpan sebagai unpaid',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            'Simpan sebagai paid',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
