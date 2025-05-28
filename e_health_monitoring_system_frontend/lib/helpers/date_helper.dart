import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(String isoDateString) {
    final date =
        DateTime.parse(
          isoDateString,
        ).toLocal(); // Convert from UTC to local time
    return DateFormat('EEEE, dd MMMM').format(date); // e.g., Wednesday, 28 May
  }

  static String formatTime(String isoDateString) {
    final date = DateTime.parse(isoDateString).toLocal();
    return DateFormat('HH:mm').format(date); // e.g., 17:35
  }
}
