import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vetpro/common/components/buttons.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/controller/invoice_controller.dart';

class AddInvoicePage extends StatefulWidget {
  const AddInvoicePage({super.key});

  @override
  State<AddInvoicePage> createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  @override
  Widget build(BuildContext context) {
    final invoiceC = Get.put(InvoiceController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryColor,
        title: const Text(
          'Detail Invoice',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView(
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
                    const Text('Tanggal'),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20))),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2025),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              selectedDate = selectedDate;
                            });
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
                    const Text('Pemeriksaan'),
                    TextFormField(
                      decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            height: 50,
            color: secondaryColor,
            child: const DefaultTextStyle(
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
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                    ),
                    height: 50,
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.black),
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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Jumlah Total',
                      style: whiteTextStyle,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '300.000',
                      style: whiteTextStyle.copyWith(
                        fontWeight: bold,
                      ),
                    )
                  ]),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 30, left: 25, right: 25),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       InkWell(
          //         onTap: () => invoiceC.addCart(),
          //         child: Container(
          //           padding: const EdgeInsets.only(left: 20, right: 20),
          //           height: 50,
          //           decoration: BoxDecoration(
          //               color: Colors.green,
          //               borderRadius: BorderRadius.circular(20)),
          //           child: const Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Icon(
          //                 Icons.add,
          //                 color: Colors.white,
          //               ),
          //               Text(
          //                 'Tambah jasa',
          //                 style: TextStyle(color: Colors.white),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       Container(
          //         padding: const EdgeInsets.only(left: 20, right: 20),
          //         height: 50,
          //         decoration: BoxDecoration(
          //             color: secondaryColor,
          //             borderRadius: BorderRadius.circular(20)),
          //         child: const Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Text(
          //                 'Jumlah Total',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //               SizedBox(
          //                 width: 10,
          //               ),
          //               Text(
          //                 '300.000',
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold, color: Colors.white),
          //               )
          //             ]),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: secondaryColor, borderRadius: BorderRadius.circular(15)),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextButton(
                    onPressed: () {},
                    icon: Icons.save,
                    title: 'Simpan sebagai unpaid',
                    colorText: blackColor,
                    isShowSubTitle: false,
                    colorIcon: blackColor,
                    buttonColor: const Color.fromARGB(137, 244, 192, 192),
                    textWeight: medium,
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    textSize: 12,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextButton(
                    onPressed: () {},
                    icon: Icons.check,
                    title: 'Simpan sebagai paid',
                    colorText: whiteColor,
                    isShowSubTitle: false,
                    colorIcon: greenColor,
                    buttonColor: secondaryColor,
                    textWeight: medium,
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    textSize: 12,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
