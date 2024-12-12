import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';

import '../../bloc/list_inspection/list_inspection_bloc.dart';
import '../../common/components/list_card_widget.dart';
import '../../common/components/tab_menu_widget.dart';
import '../../common/constants/colors.dart';
import 'add_invoice_page.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  //List<InspectionInvoice> savedItems = [];

  @override
  void initState() {
    //_loadSavedData();
    context
        .read<ListInspectionBloc>()
        .add(const ListInspectionEvent.getInspection());
    super.initState();
    context.read<InvoiceBloc>().add(InvoiceEvent.fetchDataInvoiceEvent());
  }

  // _loadSavedData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = prefs.getString('invoiceData');
  //   if (data != null) {
  //     final List<dynamic> decodedData = json.decode(data);
  //     savedItems =
  //         decodedData.map((item) => InspectionInvoice.fromJson(item)).toList();
  //   }
  //   setState(() {}); // Trigger a rebuild with the loaded data
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Unpaid',
                    style: primaryTextStyle.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset('assets/logo2.png')
                ],
              ),
            ),
            BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (data) {
                    if (data.isEmpty) {
                      return Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 500,
                        child: Center(
                          child: Text(
                            'Tidak data inspection invoice yang tersedia.',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final invoice = data[index];
                            return ListTile(
                              title: Text("${invoice.pemeriksa}"),
                              subtitle: Text(invoice.status ?? ''),
                            );
                          });
                    }
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: primaryColor,
                      ),
                    );
                  },
                  error: (message) => Center(
                    child: Text(
                      message,
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                  orElse: () {
                    return const Center(child: Text("data"));
                    // return const Center(
                    //   child: CircularProgressIndicator(
                    //     backgroundColor: Colors.transparent,
                    //     color: primaryColor,
                    //   ),
                    // );
                  },
                );
              },
            ),
            // BlocBuilder<ListInspectionBloc, ListInspectionState>(
            //   builder: (context, state) {
            //     return state.maybeWhen(
            //       loaded: (data) {
            //         if (data.isEmpty) {
            //           return Container(
            //             alignment: Alignment.topCenter,
            //             width: MediaQuery.of(context).size.width * 0.5,
            //             height: 500,
            //             child: Center(
            //               child: Text(
            //                 'Tidak data inspection invoice yang tersedia.',
            //                 maxLines: 2,
            //                 textAlign: TextAlign.center,
            //                 style: blackTextStyle.copyWith(
            //                   fontSize: 16,
            //                   fontWeight: bold,
            //                 ),
            //               ),
            //             ),
            //           );
            //         } else {
            //           return ListView.builder(
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               itemCount: data.length,
            //               itemBuilder: (context, index) {
            //                 final InspectionModel inspection = data[index];
            //                 return ListCardWidget(
            //                   color: const Color.fromARGB(255, 223, 220, 220),
            //                   flag: '3',
            //                   text1: inspection.inspector,
            //                   text2: "unpaid",
            //                   text3: inspection.animal,
            //                   widget: InkWell(
            //                       onTap: () => Get.to(const AddInvoicePage()),
            //                       child: Image.asset('assets/file.png')),
            //                 );
            //               });
            //         }
            //       },
            //       orElse: () {
            //         return const Center(
            //           child: CircularProgressIndicator(
            //             backgroundColor: Colors.transparent,
            //             color: primaryColor,
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            // ListCardWidget(
            //     color: const Color.fromARGB(255, 223, 220, 220),
            //     flag: '3',
            //     text1: 'Drh. Buhori Muslim',
            //     text2: 'Telkom University',
            //     text3: '16 September 2023',
            //     widget: InkWell(
            //         onTap: () => Get.to(const AddInvoicePage()),
            //         child: Image.asset('assets/file.png'))),
            // Container(
            //   margin: const EdgeInsets.only(top: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'Paid',
            //         style: primaryTextStyle.copyWith(
            //           fontSize: 35,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // ListCardWidget(
            //     color: const Color.fromARGB(255, 116, 204, 119),
            //     flag: '3',
            //     text1: 'Drh. Buhori Muslim',
            //     text2: 'Telkom University',
            //     text3: '16 September 2023',
            //     widget: InkWell(
            //         onTap: () => Get.to(const AddInvoicePage()),
            //         child: Image.asset('assets/file.png'))),
            // ListCardWidget(
            //     color: const Color.fromARGB(255, 116, 204, 119),
            //     flag: '3',
            //     text1: 'Drh. Buhori Muslim',
            //     text2: 'Telkom University',
            //     text3: '16 September 2023',
            //     widget: InkWell(
            //         onTap: () => Get.to(const AddInvoicePage()),
            //         child: Image.asset('assets/file.png'))),
            // ListCardWidget(
            //     color: const Color.fromARGB(255, 116, 204, 119),
            //     flag: '3',
            //     text1: 'Drh. Buhori Muslim',
            //     text2: 'Telkom University',
            //     text3: '16 September 2023',
            //     widget: InkWell(
            //         onTap: () => Get.to(const AddInvoicePage()),
            //         child: Image.asset('assets/file.png'))),
            // ListCardWidget(
            //     color: const Color.fromARGB(255, 116, 204, 119),
            //     flag: '3',
            //     text1: 'Drh. Buhori Muslim',
            //     text2: 'Telkom University',
            //     text3: '16 September 2023',
            //     widget: InkWell(
            //         onTap: () => Get.to(const AddInvoicePage()),
            //         child: Image.asset('assets/file.png'))),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        bottomNavigationBar: const TabMenuWidget(menu: '4'),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.green,
        //   onPressed: () => Get.to(const AddInvoicePage()),
        //   child: const Icon(
        //     Icons.add,
        //     size: 50,
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
