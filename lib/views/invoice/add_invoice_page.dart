import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/common/components/buttons.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/controller/invoice_controller.dart';
import 'package:vetpro/data/models/add_invoice_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/views/invoice/invoice_page.dart';
import 'package:vetpro/views/invoice/screen/add_and_detail_invoice.dart';

class AddInvoicePage extends StatelessWidget {
  const AddInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AddAndDetailInvoice(
      typePage: 'Add',
    );
  }
}
