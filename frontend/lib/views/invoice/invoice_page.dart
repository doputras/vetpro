import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/components/record_card.dart';
import 'package:vetpro/common/components/states.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/components/tab_menu_widget.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/common/extensions/format_ext.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/add_invoice_page.dart';
import 'package:vetpro/views/invoice/detail_invoice_page.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  String role = '';

  @override
  void initState() {
    super.initState();
    _refresh();
    AuthLocalDatasource().getRole().then((r) {
      if (mounted) setState(() => role = r ?? '');
    });
  }

  void _refresh() => context
      .read<InvoiceBloc>()
      .add(const InvoiceEvent.fetchDataInvoiceEvent());

  bool get _canCreate => role != 'admin';

  void _create() =>
      Get.to(() => const AddInvoicePage(), arguments: {'type': 'add'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TabMenuWidget(index: 3),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                children: [
                  Expanded(child: Text('Tagihan', style: displayStyle(34))),
                  if (_canCreate)
                    StickerButton(
                      label: 'Buat',
                      icon: Icons.add_rounded,
                      expand: false,
                      compact: true,
                      onPressed: _create,
                    ),
                ],
              ),
              const SizedBox(height: 18),
              BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) => state.maybeWhen(
                  loaded: _sections,
                  error: (m) => ErrorState(message: m, onRetry: _refresh),
                  orElse: () => const LoadingList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sections(List<InvoiceModel> data) {
    if (data.isEmpty) {
      return EmptyState(
        title: 'Belum ada tagihan',
        message:
            'Buat tagihan setelah pemeriksaan selesai, lalu cetak PDF-nya.',
        action: _canCreate
            ? StickerButton(
                label: 'Buat tagihan',
                icon: Icons.add_rounded,
                expand: false,
                onPressed: _create,
              )
            : null,
      );
    }
    List<InvoiceModel> byStatus(String status) => data
        .where((i) => i.status == status)
        .toList()
      ..sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    final unpaid = byStatus('unpaid');
    final paid = byStatus('paid');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (unpaid.isNotEmpty) ...[
          _header('Belum dibayar', unpaid),
          for (final i in unpaid) InvoiceCard(i),
          const SizedBox(height: 14),
        ],
        if (paid.isNotEmpty) ...[
          _header('Lunas', paid),
          for (final i in paid) InvoiceCard(i),
        ],
      ],
    );
  }

  Widget _header(String title, List<InvoiceModel> items) {
    final total = items.fold<int>(0, (sum, i) => sum + invoiceTotal(i));
    return SectionHeader(
      '$title (${items.length})',
      trailing: total == 0
          ? null
          : Text(total.toRupiah(),
              style: labelStyle.copyWith(fontWeight: FontWeight.w800)),
    );
  }
}

int invoiceTotal(InvoiceModel i) =>
    (i.details ?? []).fold(0, (sum, d) => sum + parseAmount(d.total));

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  const InvoiceCard(this.invoice, {super.key});

  @override
  Widget build(BuildContext context) {
    final paid = invoice.status == 'paid';
    final total = invoiceTotal(invoice);
    return RecordCard(
      leading: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: paid ? mintColor : yellowColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: inkColor, width: 2),
        ),
        child: Icon(paid ? Icons.task_alt_rounded : Icons.receipt_long_rounded,
            color: inkColor, size: 26),
      ),
      title: 'Tagihan #${invoice.id ?? '-'}',
      subtitle: [
        if (invoice.tanggal != null) invoice.tanggal!.formatDate(),
        invoice.pemeriksa ?? '',
      ].where((s) => s.isNotEmpty).join(' · '),
      meta: Row(
        children: [
          StatusPill(
            label: paid ? 'Lunas' : 'Belum dibayar',
            color: paid ? mintColor : yellowColor,
          ),
          const Spacer(),
          if (total > 0)
            Text(total.toRupiah(),
                style: labelStyle.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w800)),
        ],
      ),
      onTap: () => Get.to(() => const DetailInvoicePage(),
          arguments: {'type': 'detail', 'id': invoice.id}),
    );
  }
}
