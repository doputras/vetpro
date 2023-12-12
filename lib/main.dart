import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vetpro/bloc/inspection/inspection_bloc.dart';
import 'package:vetpro/bloc/inspection_invoice/inspection_invoice_bloc.dart';
import 'package:vetpro/bloc/login/auth_bloc.dart';
import 'package:vetpro/bloc/logout/logout_bloc.dart';
import 'package:vetpro/bloc/schedule/schedule_bloc.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/datasources/auth_remote_datasource.dart';
import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';
import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/views/auth/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:vetpro/views/home/home_page.dart';
import 'bloc/list_inspection/list_inspection_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(FirebasAuthDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(FirebasAuthDatasource()),
        ),
        BlocProvider(
          create: (context) => InspectionBloc(InspectionRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ListInspectionBloc(InspectionRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => InspectionInvoiceBloc(),
        ),
        BlocProvider(
          create: (context) => ScheduleBloc(ScheduleRemoteDatasource()),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VetPro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: AuthLocalDatasource().islogin(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
