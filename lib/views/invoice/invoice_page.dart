// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/detail_invoice_page.dart';

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
  String role = '';
  @override
  void initState() {
    //_loadSavedData();
    context
        .read<ListInspectionBloc>()
        .add(const ListInspectionEvent.getInspection());
    context.read<InvoiceBloc>().add(InvoiceEvent.fetchDataInvoiceEvent());
    getRole();
    super.initState();
  }

  Future<void> getRole() async {
    role = (await AuthLocalDatasource().getRole())!;
    setState(() {});
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
        floatingActionButton: role == 'admin'
            ? SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () =>
                    Get.to(const AddInvoicePage(), arguments: {'type': 'add'}),
                child: const Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                ),
              ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          children: [
            // BlocBuilder<InvoiceBloc, InvoiceState>(
            //   builder: (context, state) {
            //     return state.maybeWhen(
            //       loaded: (data) {
            //         data = data
            //             .where((invoice) => invoice.status == 'unpaid')
            //             .toList();
            //         if (data.isEmpty) {
            //           return SizedBox.shrink();
            //         } else {
            //           final modifiableData = List<InvoiceModel>.from(data);
            //           modifiableData
            //               .sort((a, b) => b.tanggal!.compareTo(a.tanggal!));

            //           return Column(
            //             children: [
            //               Container(
            //                 margin: const EdgeInsets.only(top: 20),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       'Unpaid',
            //                       style: primaryTextStyle.copyWith(
            //                         fontSize: 35,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                     ),
            //                     Image.asset('assets/logo2.png')
            //                   ],
            //                 ),
            //               ),
            //               ListView.builder(
            //                   shrinkWrap: true,
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   itemCount: modifiableData.length,
            //                   itemBuilder: (context, index) {
            //                     final inspection = modifiableData[index];
            //                     return ListCardWidget(
            //                       color:
            //                           const Color.fromARGB(255, 223, 220, 220),
            //                       flag: '3',
            //                       text1: inspection.pemeriksa ?? '-',
            //                       text2: inspection.status ?? '-',
            //                       text3: DateFormat('dd MMMM yyyy').format(
            //                           inspection.tanggal ?? DateTime.now()),
            //                       widget: InkWell(
            //                           onTap: () => Get.to(
            //                                   const DetailInvoicePage(),
            //                                   arguments: {
            //                                     'type': 'detail',
            //                                     'id': inspection.id
            //                                   }),
            //                           child: Image.asset('assets/file.png')),
            //                     );
            //                   }),
            //             ],
            //           );
            //         }
            //       },
            //       loading: () {
            //         return const Center(
            //           child: CircularProgressIndicator(
            //             backgroundColor: Colors.transparent,
            //             color: primaryColor,
            //           ),
            //         );
            //       },
            //       error: (message) => Center(
            //         child: Text(
            //           message,
            //           style: blackTextStyle.copyWith(
            //             fontSize: 16,
            //             fontWeight: bold,
            //           ),
            //         ),
            //       ),
            //       orElse: () {
            //         // return const Center(child: Text("data"));
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
            BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (data) {
                    final dataUnpaid = data
                        .where((invoice) => invoice.status == 'unpaid')
                        .toList();
                    final dataPaid = data
                        .where((invoice) => invoice.status == 'paid')
                        .toList();
                    if (data.isEmpty) {
                      return SizedBox.shrink();
                    } else {
                      final modifiableData = List<InvoiceModel>.from(dataPaid);
                      final modifiableDataUnpaid =
                          List<InvoiceModel>.from(dataUnpaid);
                      modifiableData
                          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                      modifiableDataUnpaid
                          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                      return Column(
                        children: [
                          // UNPAID
                          if (modifiableDataUnpaid.isNotEmpty) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            _CardInvoice(modifiableDataUnpaid),
                          ],

                          // PAID
                          if (modifiableData.isNotEmpty) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Paid',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  modifiableDataUnpaid.isEmpty
                                      ? Image.asset('assets/logo2.png')
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            _CardInvoice(modifiableData),
                          ],
                        ],
                      );
                    }
                  },
                  loading: () {
                    return Center(
                      child: CircularProgressIndicator(),
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
                    // return const Center(child: Text("data"));
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: primaryColor,
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        bottomNavigationBar: TabMenuWidget(menu: '4'),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.green,
        //   onPressed: () => Get.to(const AddInvoicePage()),
        //   child: const Icon(
        //     Icons.add,
        //     size: 50,
        //     color: Colors.white
        //   ),
        // ),
      ),
    );
  }

  ListView _CardInvoice(List<InvoiceModel> modifiableDataUnpaid) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: modifiableDataUnpaid.length,
        itemBuilder: (context, index) {
          final inspection = modifiableDataUnpaid[index];
          return ListCardWidget(
            color: const Color.fromARGB(255, 223, 220, 220),
            flag: '3',
            text1: inspection.pemeriksa ?? '-',
            text2: inspection.status ?? '-',
            text3: DateFormat('dd MMMM yyyy')
                .format(inspection.tanggal ?? DateTime.now()),
            widget: InkWell(
                onTap: () => Get.to(const DetailInvoicePage(),
                    arguments: {'type': 'detail', 'id': inspection.id}),
                child: Image.asset('assets/file.png')),
          );
        });
  }
}
