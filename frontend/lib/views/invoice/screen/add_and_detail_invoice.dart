import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/add_invoice_model.dart';
import 'package:vetpro/data/models/edit_invoice_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_api.dart';
import 'package:vetpro/views/invoice/generation_pdf/pdf_invoice_api.dart';
import 'package:vetpro/views/invoice/invoice_page.dart';

class AddAndDetailInvoice extends StatefulWidget {
  final String typePage; // 'Add' or 'Detail'
  final InvoiceModel? invoice;
  final int? idInvoice;

  const AddAndDetailInvoice({
    super.key,
    required this.typePage,
    this.invoice,
    this.idInvoice,
  });

  @override
  State<AddAndDetailInvoice> createState() => _AddAndDetailInvoiceState();
}

class _AddAndDetailInvoiceState extends State<AddAndDetailInvoice> {
  late final bool isAdd = widget.typePage.contains('Add');
  late DateTime _date =
      widget.invoice?.tanggal ?? DateUtils.dateOnly(DateTime.now());
  late final TextEditingController dateController =
      TextEditingController(text: _date.formatDate());
  late List<DataInvoiceModel> items = [...?widget.invoice?.details];
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController(text: '1');
  String pemeriksa = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    AuthLocalDatasource().getName().then((name) {
      if (mounted) setState(() => pemeriksa = name ?? '');
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    descController.dispose();
    priceController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  void addItem() {
    final price =
        int.tryParse(priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            0;
    final qty = int.tryParse(qtyController.text) ?? 0;
    if (descController.text.trim().isEmpty || price <= 0 || qty <= 0) {
      _toast('Isi deskripsi, harga, dan jumlah dulu, ya.');
      return;
    }
    setState(() {
      items.add(DataInvoiceModel(
        description: descController.text.trim(),
        price: '$price',
        quantity: qty,
        total: '${price * qty}',
      ));
    });
    descController.clear();
    priceController.clear();
    qtyController.text = '1';
    FocusScope.of(context).unfocus();
  }

  int get total => items.fold(0, (sum, item) => sum + parseAmount(item.total));

  bool get isAcctiveButton => items.isNotEmpty;

  AddInvoiceModel submitStatus(String status) => AddInvoiceModel(
        tanggal: _date,
        pemeriksa: pemeriksa,
        status: status,
        details: items,
      );

  EditInvoiceModel submitEdit(String status) => EditInvoiceModel(
        tanggal: _date,
        pemeriksa: widget.invoice?.pemeriksa ?? pemeriksa,
        status: status,
        details: items
            .map((e) => Detail(
                  description: e.description,
                  price: parseAmount(e.price),
                  quantity: e.quantity ?? 0,
                  total: parseAmount(e.total),
                ))
            .toList(),
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(DateTime.now().year + 2, 12, 31),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        dateController.text = picked.formatDate();
      });
    }
  }

  Future<void> _printPdf() async {
    try {
      final pdfFile = await PdfInvoiceApi.generate(
        subTotal: '$total',
        tax: '0',
        items: items,
        userName: widget.invoice?.pemeriksa ?? pemeriksa,
        invoiceId: widget.invoice?.id.toString() ?? '',
        invoiceDate: DateFormat('dd MMMM yyyy', 'id_ID').format(_date),
      );
      await PdfApi.openFile(pdfFile);
    } catch (e) {
      _toast('PDF belum bisa dibuat di perangkat ini.');
    }
  }

  void _save() {
    if (!isAcctiveButton) {
      _toast('Tambahkan minimal satu jasa dulu.');
      return;
    }
    setState(() => _saving = true);
    final bloc = context.read<InvoiceBloc>();
    if (isAdd) {
      bloc.add(InvoiceEvent.addDataInvoiceEvent(submitStatus('unpaid')));
    } else {
      bloc.add(InvoiceEvent.editDataInvoiceEvent(
          data: submitEdit('paid'), id: '${widget.idInvoice ?? 0}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final paid = widget.invoice?.status == 'paid';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Get.offAll(() => const InvoicePage());
      },
      child: Scaffold(
        appBar: stickerAppBar(
          context,
          isAdd ? 'Tagihan baru' : 'Tagihan #${widget.idInvoice ?? ''}',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            _receipt(paid),
            if (isAdd) ...[
              const SizedBox(height: 16),
              _addItemForm(),
            ],
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: const BoxDecoration(
              color: backgroundColor,
              border: Border(top: inkBorder),
            ),
            child: BlocListener<InvoiceBloc, InvoiceState>(
              listener: (context, state) {
                void done(String message) {
                  Get.offAll(() => const InvoicePage());
                  _toast(message);
                }

                state.maybeWhen(
                  orElse: () {},
                  loadedAdd: (_) => done('Tagihan tersimpan!'),
                  loadedEdit: (_) => done('Tagihan ditandai lunas.'),
                  error: (message) {
                    setState(() => _saving = false);
                    _toast('Gagal menyimpan: $message');
                  },
                );
              },
              child: _actions(paid),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actions(bool paid) {
    const printLabel = 'Cetak PDF';
    if (isAdd) {
      return StickerButton(
        label: 'Simpan tagihan',
        icon: Icons.save_rounded,
        loading: _saving,
        onPressed: _save,
      );
    }
    if (paid) {
      return StickerButton(
        label: printLabel,
        icon: Icons.print_rounded,
        color: tealColor,
        onPressed: _printPdf,
      );
    }
    return Row(
      children: [
        Expanded(
          child: StickerButton(
            label: printLabel,
            icon: Icons.print_rounded,
            color: whiteColor,
            textColor: inkColor,
            onPressed: _printPdf,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StickerButton(
            label: 'Tandai lunas',
            icon: Icons.task_alt_rounded,
            color: mintColor,
            textColor: inkColor,
            loading: _saving,
            onPressed: _save,
          ),
        ),
      ],
    );
  }

  Widget _receipt(bool paid) {
    return Sticker(
      padding: EdgeInsets.zero,
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                const VetproMark(size: 38),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VetPro', style: displayStyle(20)),
                      Text('Jasa pemeriksaan hewan', style: mutedStyle),
                    ],
                  ),
                ),
                if (!isAdd)
                  StatusPill(
                    label: paid ? 'Lunas' : 'Belum dibayar',
                    color: paid ? mintColor : yellowColor,
                    icon: paid ? Icons.check_rounded : null,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: isAdd
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomFormField(
                        title: 'Tanggal',
                        controller: dateController,
                        readOnly: true,
                        onTap: _pickDate,
                        suffixIcon: const Icon(Icons.calendar_month_rounded),
                      ),
                      const SizedBox(height: 12),
                      _meta('Pemeriksa', pemeriksa),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _meta('Tanggal', _date.formatDate())),
                      Expanded(
                          child: _meta(
                              'Pemeriksa', widget.invoice?.pemeriksa ?? '')),
                    ],
                  ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: DashedDivider(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
            child: items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Belum ada jasa. Tambahkan lewat form di bawah.',
                      textAlign: TextAlign.center,
                      style: mutedStyle.copyWith(fontSize: 14),
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < items.length; i++) _itemRow(i),
                    ],
                  ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: DashedDivider(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Total', style: labelStyle.copyWith(fontSize: 16)),
                const SizedBox(width: 16),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(total.toRupiah(), style: displayStyle(28)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: mutedStyle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value.isEmpty ? '—' : value,
              style: labelStyle.copyWith(fontSize: 15)),
        ],
      );

  Widget _itemRow(int i) {
    final item = items[i];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description ?? '-',
                    style: labelStyle.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                    '${parseAmount(item.price).toRupiah()} × ${item.quantity ?? 0}',
                    style: mutedStyle),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(parseAmount(item.total).toRupiah(),
              style: labelStyle.copyWith(
                  fontSize: 15, fontWeight: FontWeight.w800)),
          if (isAdd)
            IconButton(
              tooltip: 'Hapus ${item.description ?? 'jasa'}',
              icon: const Icon(Icons.close_rounded, color: mutedColor),
              onPressed: () => setState(() => items.removeAt(i)),
            )
          else
            const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _addItemForm() {
    return FormSection(
      title: 'Tambah jasa',
      icon: Icons.playlist_add_rounded,
      children: [
        CustomFormField(
          title: 'Deskripsi',
          hintText: 'mis. Vaksinasi, Transport',
          controller: descController,
          textInputAction: TextInputAction.next,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomFormField(
                title: 'Harga (Rp)',
                hintText: 'mis. 75.000',
                controller: priceController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) return newValue;
                    final formatted = NumberFormat.decimalPattern('id')
                        .format(int.parse(newValue.text));
                    return TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 92,
              child: CustomFormField(
                title: 'Jumlah',
                controller: qtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (_) => addItem(),
              ),
            ),
          ],
        ),
        StickerButton(
          label: 'Tambah ke tagihan',
          icon: Icons.add_rounded,
          color: tealColor,
          onPressed: addItem,
        ),
      ],
    );
  }
}
