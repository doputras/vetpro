// Demo mode: the real app on in-memory sample data, no backend needed.
//   flutter run -t lib/main_demo.dart
// Any email/password logs in. Nothing is sent or stored.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetpro/data/datasources/auth_remote_datasource.dart';
import 'package:vetpro/data/datasources/inspection_remote_datasource.dart';
import 'package:vetpro/data/datasources/invoices_remote_datasource.dart';
import 'package:vetpro/data/datasources/schedule_remote_datasource.dart';
import 'package:vetpro/data/models/add_invoice_model.dart';
import 'package:vetpro/data/models/edit_invoice_model.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:vetpro/data/models/invoices_model.dart';
import 'package:vetpro/data/models/schedule_request_model.dart';
import 'package:vetpro/data/models/schedule_response_model.dart';
import 'package:vetpro/data/models/user_model.dart';
import 'package:vetpro/main.dart';

const _user = 'drh. Sari Wulandari';
final _today = DateUtils.dateOnly(DateTime.now());
String _ymd(int daysAgo) =>
    DateFormat('yyyy-MM-dd').format(_today.subtract(Duration(days: daysAgo)));
Future<void> _lag() => Future.delayed(const Duration(milliseconds: 450));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(
      {'isLoggedIn': true, 'name': _user, 'role': 'user', 'id': '1'});
  runApp(MyApp(
    auth: _DemoAuth(),
    inspections: _DemoInspections(),
    invoices: _DemoInvoices(),
    schedules: _DemoSchedules(),
  ));
}

class _DemoAuth extends AuthRemoteDatasource {
  @override
  Future<Either<String, UserModel>> login(UserData model) async {
    await _lag();
    return right(UserModel(
        success: true,
        data: UserData(id: 1, name: _user, email: model.email, role: 'user')));
  }

  @override
  Future<Either<String, UserModel>> register(UserData model) => login(model);
}

class _DemoInspections extends InspectionRemoteDatasource {
  final List<InspectionModel> _items = [
    _i(
        1,
        'Domba',
        0,
        'Kandang A',
        'Nafsu makan baik, bulu bersih. Suhu 39,1°C.',
        'Obat cacing rutin',
        'Ganti jerami',
        'Rumput + konsentrat 2x sehari'),
    _i(
        2,
        'Rusa',
        0,
        'Area Rusa Timur',
        'Luka kecil di kaki kiri belakang, sudah dibersihkan.',
        'Salep antiseptik 2x sehari',
        'Ratakan tanah becek',
        'Daun & umbi'),
    _i(
        3,
        'Kelinci',
        1,
        'Kandang Kelinci 2',
        'Aktif, mata jernih, berat naik 0,2 kg.',
        '-',
        'Bersihkan alas',
        'Wortel & pelet'),
    _i(
        4,
        'Angsa',
        3,
        'Kolam Utara',
        'Bulu sayap rontok sedikit, masih normal (musim ganti bulu).',
        'Vitamin B kompleks',
        'Kuras kolam',
        'Dedak + sayuran'),
    _i(5, 'Burung', 3, 'Aviary', 'Suara aktif, paruh & kuku normal.', '-',
        'Ganti tenggeran', 'Biji-bijian & buah'),
    _i(
        6,
        'Domba',
        8,
        'Kandang B',
        'Satu ekor batuk ringan, dipisahkan sementara.',
        'Antibiotik 3 hari',
        'Ventilasi dibuka',
        'Rumput segar'),
    _i(7, 'Kambing', 12, 'Kandang C', 'Sehat, siap vaksin bulan depan.', '-',
        '-', 'Rumput + ampas tahu'),
  ];

  static InspectionModel _i(int id, String animal, int daysAgo, String loc,
          String result, String med, String cage, String feed) =>
      InspectionModel(
        id: id,
        animal: animal,
        date: _ymd(daysAgo),
        location: loc,
        inspector: id.isOdd ? _user : 'drh. Bima Pratama',
        result: result,
        medicalTreatment: med,
        cageTreatment: cage,
        feeding: feed,
        environmentalCare: 'Area bersih, sirkulasi udara baik',
        suggestion: 'Pantau lagi minggu depan',
      );

  @override
  Future<Either<String, List<InspectionModel>>> getListInspection() async {
    await _lag();
    return right([..._items]..sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        return byDate != 0 ? byDate : (b.id ?? 0).compareTo(a.id ?? 0);
      }));
  }

  @override
  Future<Either<String, InspectionModel>> addInspection(
      InspectionModel data) async {
    await _lag();
    final saved = InspectionModel(
      id: _items.length + 1,
      animal: data.animal,
      cageTreatment: data.cageTreatment,
      date: data.date,
      environmentalCare: data.environmentalCare,
      feeding: data.feeding,
      medicalTreatment: data.medicalTreatment,
      inspector: data.inspector,
      location: data.location,
      suggestion: data.suggestion,
      result: data.result,
    );
    _items.add(saved);
    return right(saved);
  }
}

class _DemoSchedules extends ScheduleRemoteDatasource {
  int _nextId = 6;
  final List<Schedule> _items = [
    _s(1, 'Domba', 0, 'Kandang A', 'Cek berat & kuku'),
    _s(2, 'Rusa', 2, 'Area Rusa Timur', 'Kontrol luka kaki'),
    _s(3, 'Angsa', 2, 'Kolam Utara', 'Cek ganti bulu'),
    _s(4, 'Kelinci', 5, 'Kandang Kelinci 2', 'Vaksin RHD'),
    _s(5, 'Burung', 9, 'Aviary', 'Pemeriksaan rutin bulanan'),
  ];

  static Schedule _s(int id, String animal, int inDays, String loc, String d) =>
      Schedule(
        id: id,
        animalName: animal,
        inspectionDate: _today.add(Duration(days: inDays)),
        location: loc,
        inspector: _user,
        description: d,
      );

  @override
  Future<Either<String, ScheduleResponseModel>> getSchedule() async {
    await _lag();
    return right(ScheduleResponseModel(data: [..._items]));
  }

  Schedule _from(int id, ScheduleRequestModel m) => Schedule(
        id: id,
        animalName: m.animalName,
        inspectionDate: m.inspectionDate,
        location: m.location,
        inspector: m.inspector,
        description: m.description,
      );

  @override
  Future<Either<String, Schedule>> createSchedule(
      ScheduleRequestModel model) async {
    await _lag();
    final s = _from(_nextId++, model);
    _items.add(s);
    return right(s);
  }

  @override
  Future<Either<String, Schedule>> updateSchedule(
      int id, ScheduleRequestModel model) async {
    await _lag();
    final s = _from(id, model);
    _items[_items.indexWhere((e) => e.id == id)] = s;
    return right(s);
  }

  @override
  Future<Either<String, String>> deleteSchedule(int id) async {
    await _lag();
    _items.removeWhere((e) => e.id == id);
    return right('deleted');
  }
}

class _DemoInvoices extends InvoicesRemoteDatasource {
  final List<InvoiceModel> _items = [
    _inv(101, 'unpaid', 0,
        [('Pemeriksaan umum', 75000, 3), ('Transport', 50000, 1)]),
    _inv(100, 'unpaid', 3, [('Vaksinasi', 120000, 2)]),
    _inv(98, 'paid', 9,
        [('Pemeriksaan umum', 75000, 4), ('Obat cacing', 25000, 4)]),
    _inv(97, 'paid', 16, [('Perawatan luka', 90000, 1)]),
  ];

  static InvoiceModel _inv(
      int id, String status, int daysAgo, List<(String, int, int)> lines) {
    final date = _today.subtract(Duration(days: daysAgo));
    return InvoiceModel(
      id: id,
      tanggal: date,
      pemeriksa: _user,
      status: status,
      createdAt: date,
      details: [
        for (final (desc, price, qty) in lines)
          DataInvoiceModel(
              description: desc,
              price: '$price.00',
              quantity: qty,
              total: '${price * qty}.00'),
      ],
    );
  }

  @override
  Future<Either<String, List<InvoiceModel>>> getInvoicesByUserID() async {
    await _lag();
    return right([..._items]);
  }

  @override
  Future<Either<String, List<InvoiceModel>>> getListInvoices() =>
      getInvoicesByUserID();

  @override
  Future<Either<String, InvoiceModel>> getInvoicesById(String id) async {
    await _lag();
    return right(_items.firstWhere((i) => '${i.id}' == id));
  }

  @override
  Future<Either<String, InvoiceModel>> addInvoices(AddInvoiceModel data) async {
    await _lag();
    final inv = InvoiceModel(
      id: _items.map((i) => i.id ?? 0).reduce((a, b) => a > b ? a : b) + 1,
      tanggal: data.tanggal,
      pemeriksa: data.pemeriksa,
      status: data.status,
      createdAt: DateTime.now(),
      details: data.details,
    );
    _items.add(inv);
    return right(inv);
  }

  @override
  Future<Either<String, InvoiceModel>> updateInvoices(
      {required EditInvoiceModel data, required String id}) async {
    await _lag();
    final i = _items.indexWhere((e) => '${e.id}' == id);
    final old = _items[i];
    _items[i] = InvoiceModel(
      id: old.id,
      tanggal: data.tanggal,
      pemeriksa: data.pemeriksa,
      status: data.status,
      createdAt: old.createdAt,
      details: old.details,
    );
    return right(_items[i]);
  }
}
