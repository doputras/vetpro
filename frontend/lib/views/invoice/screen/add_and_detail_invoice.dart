// ignore_for_file: unnecessary_import, deprecated_member_use, prefer_const_constructors, avoid_print, unrelated_type_equality_checks, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/components/buttons.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/add_invoice_model.dart';
import 'package:vetpro/data/models/edit_invoice_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_api.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_invoice_api.dart';
import 'package:vetpro/views/invoice/invoice_page.dart';

class AddAndDetailInvoice extends StatefulWidget {
  final String typePage;

  final InvoiceModel? invoice;
  final int? idInvoice;
  final List<DataInvoiceModel>? items;

  const AddAndDetailInvoice({
    super.key,
    required this.typePage,
    this.items,
    this.invoice,
    this.idInvoice,
  });

  @override
  State<AddAndDetailInvoice> createState() => _AddAndDetailInvoiceState();
}

class _AddAndDetailInvoiceState extends State<AddAndDetailInvoice> {
  var idInvoice = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<DataInvoiceModel> items = [];
  List<Detail> itemsEdit = [];
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final AuthLocalDatasource authLocalDatasource = AuthLocalDatasource();
  String pemeriksa = '';

  void addItem() {
    if (descController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        qtyController.text.isNotEmpty) {
      priceController.text = priceController.text.replaceAll('.', '');
      priceController.text = priceController.text.split(',')[0];
      final int price = int.tryParse(priceController.text) ?? 0;
      final int qty = int.tryParse(qtyController.text) ?? 0;
      setState(() {
        items.add(DataInvoiceModel(
          description: descController.text,
          price: "${price}",
          quantity: qty,
          total: "${price * qty}",
        ));
      });

      descController.clear();
      priceController.clear();
      qtyController.clear();
    }
  }

  double getTotalQty() {
    return items.fold(
        0, (sum, item) => sum + (double.tryParse(item.total ?? '0') ?? 0));
  }

  Future<AddInvoiceModel> submitStatus(String status) async {
    final invoice = AddInvoiceModel(
      tanggal: DateFormat('dd MMMM yyyy').parse(dateController.text),
      pemeriksa: pemeriksa,
      status: status,
      details: items,
    );
    return invoice;
  }

  Future<EditInvoiceModel> submitEdit(String status) async {
    itemsEdit = items
        .map((e) => Detail(
              description: e.description,
              price: int.parse(e.price?.split('.')[0] ?? '0'),
              quantity: e.quantity ?? 0,
              total: int.parse(e.total?.split('.')[0] ?? '0'),
            ))
        .toList();
    final invoice = EditInvoiceModel(
      tanggal: DateFormat('dd MMMM yyyy').parse(dateController.text),
      pemeriksa: pemeriksa,
      status: status,
      details: itemsEdit,
    );
    return invoice;
  }

  bool get isAcctiveButton =>
      dateController.text.isNotEmpty &&
      items.isNotEmpty;

 @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      idInvoice = widget.invoice!.id ?? 0;
      dateController.text = DateFormat('dd MMMM yyyy').format(widget.invoice!.tanggal ?? DateTime.now());
      items = widget.invoice!.details ?? [];
    }
    _setPemeriksa();
  }

  Future<void> _setPemeriksa() async {
    final name = await authLocalDatasource.getName();
    setState(() {
      pemeriksa = name ?? '';
      nameController.text = pemeriksa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(InvoicePage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: secondaryColor,
          title: Text(
            "${widget.typePage} Invoice",
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
                        controller: dateController,
                        decoration: InputDecoration(
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20)),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20))),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015),
                            lastDate: DateTime(2027),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                selectedDate = selectedDate;
                                dateController.text = DateFormat('dd MMMM yyyy')
                                    .format(selectedDate ?? DateTime.now());
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
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
              height: 50,
              color: secondaryColor,
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Desc',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Harga',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    if (widget.typePage.contains("Add")) ...[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Hapus',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            items == 0
                ? SizedBox.shrink()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final result = items[i];
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
                                  result.description!,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp',
                                          decimalDigits: 0)
                                      .format(int.parse(
                                          result.price?.split('.')[0] ?? '0')),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  result.quantity.toString(),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(int.parse(
                                      result.total?.split('.')[0] ?? '0')),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              if (widget.typePage.contains("Add")) ...[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      items.removeAt(i);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
            if (widget.typePage.contains("Add")) ...[
              _buildAddInvoice(),
            ],
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
                  borderRadius: BorderRadius.circular(20),
                ),
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
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp', decimalDigits: 0)
                            .format(getTotalQty()),
                        style: whiteTextStyle.copyWith(
                          fontWeight: bold,
                        ),
                      )
                    ]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15)),
            ),
            if (widget.typePage.contains("Detail")) ...[
              widget.invoice?.status == 'unpaid'
                  ? BlocConsumer<InvoiceBloc, InvoiceState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () => Center(
                            child: CircularProgressIndicator(),
                          ),
                          loadedEdit: (invoice) {
                            if (!Get.isSnackbarOpen) {
                              Get.snackbar(
                                'Berhasil',
                                'Data berhasil disimpan',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            }
                            Get.offAll(InvoicePage());
                          },
                          error: (message) {
                            if (!Get.isSnackbarOpen) {
                              Get.snackbar(
                                'Error',
                                message,
                                backgroundColor: Colors.white,
                                colorText: Colors.black,
                              );
                            }
                          },
                        );
                      },
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomTextButton(
                                  onPressed: () async {
                                    if (isAcctiveButton) {
                                      final invoice = await submitEdit('paid');
                                      context.read<InvoiceBloc>().add(
                                          InvoiceEvent.editDataInvoiceEvent(
                                              data: invoice,
                                              id: "${widget.idInvoice ?? 0}"));
                                    } else {
                                      if (!Get.isSnackbarOpen) {
                                        Get.snackbar(
                                          'Error',
                                          'Tanggal, Nama Pemeriksa, dan Data tidak boleh kosong',
                                          backgroundColor: Colors.white,
                                          colorText: Colors.black,
                                        );
                                      }
                                    }
                                  },
                                  icon: Icons.check,
                                  title: 'Simpan sebagai paid Detail',
                                  colorText: whiteColor,
                                  isShowSubTitle: false,
                                  colorIcon: whiteColor,
                                  buttonColor: greenColor,
                                  textWeight: medium,
                                  height: 50,
                                  textSize: 12,
                                  borderRadius: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomTextButton(
                                  onPressed: () async {
                                    final pdfFile =
                                        await PdfInvoiceApi.generate(
                                      subTotal: getTotalQty().toString(),
                                      tax: '0',
                                      items: items,
                                      userName: widget.invoice?.pemeriksa ?? '', 
                                      invoiceId: widget.invoice?.id.toString() ?? '',
                                      invoiceDate: dateController.text,
                                    );
                                    PdfApi.openFile(pdfFile);
                                  },
                                  icon: Icons.print,
                                  title: 'Cetak Invoice',
                                  colorText: whiteColor,
                                  isShowSubTitle: false,
                                  colorIcon: whiteColor,
                                  buttonColor: greenColor,
                                  textWeight: medium,
                                  height: 50,
                                  textSize: 12,
                                  borderRadius: 12,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final pdfFile = await PdfInvoiceApi.generate(
                            subTotal: getTotalQty().toString(),
                            tax: '0',
                            items: items,
                            userName: widget.invoice?.pemeriksa ?? '', 
                            invoiceId: widget.invoice?.id.toString() ?? '',
                            invoiceDate: dateController.text,
                          );
                          PdfApi.openFile(pdfFile);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.print,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Cetak Invoice',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
            if (widget.typePage.contains("Add")) ...[
              _buildBtnPaidAndUnpaid(),
            ],
          ],
        ),
      ),
    );
  }

  BlocConsumer<InvoiceBloc, InvoiceState> _buildBtnPaidAndUnpaid() {
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loadedAdd: (invoice) {
            if (!Get.isSnackbarOpen) {
              Get.snackbar(
                'Berhasil',
                'Data berhasil disimpan',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }
            Get.offAll(InvoicePage());
          },
          error: (message) {
            if (!Get.isSnackbarOpen) {
              Get.snackbar(
                'Error',
                message,
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            }
          },
        );
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: CustomTextButton(
            onPressed: () async {
              if (isAcctiveButton) {
                final invoice = await submitStatus('unpaid');
                context
                    .read<InvoiceBloc>()
                    .add(InvoiceEvent.addDataInvoiceEvent(invoice));
              } else {
                if (!Get.isSnackbarOpen) {
                  Get.snackbar(
                    'Error',
                    'Tanggal, Nama Pemeriksa, dan Data tidak boleh kosong',
                    backgroundColor: Colors.white,
                    colorText: Colors.black,
                  );
                }
              }
            },
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

          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       child: CustomTextButton(
          //         onPressed: () async {
          //           if (isAcctiveButton) {
          //             final invoice = await submitStatus('unpaid');
          //             context
          //                 .read<InvoiceBloc>()
          //                 .add(InvoiceEvent.addDataInvoiceEvent(invoice));
          //           } else {
          //             if (!Get.isSnackbarOpen) {
          //               Get.snackbar(
          //                 'Error',
          //                 'Tanggal, Nama Pemeriksaan, dan Data tidak boleh kosong',
          //                 backgroundColor: Colors.white,
          //                 colorText: Colors.black,
          //               );
          //             }
          //           }
          //         },
          //         icon: Icons.save,
          //         title: 'Simpan sebagai unpaid',
          //         colorText: blackColor,
          //         isShowSubTitle: false,
          //         colorIcon: blackColor,
          //         buttonColor: const Color.fromARGB(137, 244, 192, 192),
          //         textWeight: medium,
          //         height: 50,
          //         width: MediaQuery.of(context).size.width / 2.5,
          //         textSize: 12,
          //         borderRadius: 12,
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     Expanded(
          //       child: CustomTextButton(
          //         onPressed: () async {
          //           if (isAcctiveButton) {
          //             final invoice = await submitStatus('paid');
          //             context
          //                 .read<InvoiceBloc>()
          //                 .add(InvoiceEvent.addDataInvoiceEvent(invoice));
          //           } else {
          //             if (!Get.isSnackbarOpen) {
          //               Get.snackbar(
          //                 'Error',
          //                 'Tanggal, Nama Pemeriksaan, dan Data tidak boleh kosong',
          //                 backgroundColor: Colors.white,
          //                 colorText: Colors.black,
          //               );
          //             }
          //           }
          //         },
          //         icon: Icons.check,
          //         title: 'Simpan sebagai paid',
          //         colorText: whiteColor,
          //         isShowSubTitle: false,
          //         colorIcon: greenColor,
          //         buttonColor: secondaryColor,
          //         textWeight: medium,
          //         height: 50,
          //         width: MediaQuery.of(context).size.width / 2.5,
          //         textSize: 12,
          //         borderRadius: 12,
          //       ),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }

  Column _buildAddInvoice() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 15,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final newText = newValue.text;
                      if (newText.isEmpty) {
                        return newValue.copyWith(text: '');
                      }
                      final onlyDigits =
                          newText.replaceAll(RegExp(r'[^0-9]'), '');

                      final formattedValue = NumberFormat.currency(
                        locale: 'id',
                        symbol: '',
                        decimalDigits: 0,
                      ).format(int.parse(onlyDigits));

                      return TextEditingValue(
                        text: formattedValue,
                        selection: TextSelection.collapsed(
                          offset: formattedValue.length,
                        ),
                      );
                    }),
                  ],
                  maxLines: null,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: qtyController,
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLines: null,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox.shrink(),
            ),
            Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: addItem,
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(
                      0xff7DC76B,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tambah Jasa',
                          style: whiteTextStyle,
                        ),
                      ],
                    ),
                  )),
            ),
            Expanded(
              flex: 2,
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}
