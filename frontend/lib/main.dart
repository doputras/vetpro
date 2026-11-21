import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vetpro/bloc/auth_new/bloc/auth_new_bloc.dart';
import 'package:vetpro/bloc/inspection/inspection_bloc.dart';
import 'package:vetpro/bloc/inspection_invoice/inspection_invoice_bloc.dart';
import 'package:vetpro/bloc/invoice/invoice_bloc.dart';
import 'package:vetpro/bloc/list_inspection/list_inspection_bloc.dart';
import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/datasources/auth_remote_datasource.dart';
import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';
import 'package:vetpro/data/datasources/invoices_remote_datasource.dart';
import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/views/auth/login_page.dart';
import 'package:vetpro/views/home/home_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Datasources are injectable so lib/main_demo.dart can run on sample data.
  final AuthRemoteDatasource? auth;
  final InspectionRemoteDatasource? inspections;
  final InvoicesRemoteDatasource? invoices;
  final ScheduleRemoteDatasource? schedules;

  const MyApp({
    super.key,
    this.auth,
    this.inspections,
    this.invoices,
    this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    final inspectionSource = inspections ?? InspectionRemoteDatasource();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthNewBloc(auth ?? AuthRemoteDatasource())),
        BlocProvider(create: (_) => InspectionBloc(inspectionSource)),
        BlocProvider(create: (_) => ListInspectionBloc(inspectionSource)),
        BlocProvider(create: (_) => InspectionInvoiceBloc()),
        BlocProvider(
            create: (_) => InvoiceBloc(invoices ?? InvoicesRemoteDatasource())),
        BlocProvider(
            create: (_) =>
                ScheduleBloc(schedules ?? ScheduleRemoteDatasource())),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VetPro',
        theme: buildAppTheme(),
        home: FutureBuilder<bool>(
          future: AuthLocalDatasource().getLogin(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(body: SizedBox.shrink());
            }
            return snapshot.data! ? const HomePage() : const LoginPage();
          },
        ),
      ),
    );
  }
}
