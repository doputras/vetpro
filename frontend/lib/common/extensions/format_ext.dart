import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  /// 12 November 2026
  String formatDate() => DateFormat('d MMMM yyyy', 'id_ID').format(this);

  /// Kamis, 12 November
  String formatDay() => DateFormat('EEEE, d MMMM', 'id_ID').format(this);

  /// Kamis, 12 November 2026
  String formatLong() => DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(this);
}

final NumberFormat _rupiah =
    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

extension RupiahExtension on num {
  /// Rp150.000
  String toRupiah() => _rupiah.format(this);
}

/// Parses API amounts like "150000.00" without float drift.
int parseAmount(String? raw) => int.tryParse(raw?.split('.').first ?? '') ?? 0;
