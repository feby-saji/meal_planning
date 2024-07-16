import 'package:intl/intl.dart';

String formattedDate(DateTime date) {
  return DateFormat('EEEE, MMM d').format(date);
}
