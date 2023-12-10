import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String formatDate() {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(this);
  }
}
