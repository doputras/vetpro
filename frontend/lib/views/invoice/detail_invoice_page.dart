import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/components/states.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/views/invoice/screen/add_and_detail_invoice.dart';

class DetailInvoicePage extends StatefulWidget {
  const DetailInvoicePage({super.key});

  @override
  State<DetailInvoicePage> createState() => _DetailInvoicePageState();
}

class _DetailInvoicePageState extends State<DetailInvoicePage> {
  late final int idInvoice = (Get.arguments?['id'] as int?) ?? 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Fetch once on open, not on every rebuild.
  void _load() => context
      .read<InvoiceBloc>()
      .add(InvoiceEvent.getInvoiceById('$idInvoice'));

  @override
  Widget build(BuildContext context) {
    bool isLoaded(InvoiceState s) =>
        s.maybeWhen(loadedById: (_) => true, orElse: () => false);
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      // Once shown, keep the invoice on screen while saving (edit states).
      buildWhen: (prev, curr) => !isLoaded(prev) || isLoaded(curr),
      builder: (context, state) => state.maybeWhen(
        loadedById: (invoice) => AddAndDetailInvoice(
          typePage: 'Detail',
          invoice: invoice,
          idInvoice: idInvoice,
        ),
        orElse: () => Scaffold(
          appBar: stickerAppBar(context, 'Tagihan #$idInvoice'),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: state.maybeWhen(
              error: (m) => ErrorState(message: m, onRetry: _load),
              orElse: () => const LoadingList(count: 2),
            ),
          ),
        ),
      ),
    );
  }
}
