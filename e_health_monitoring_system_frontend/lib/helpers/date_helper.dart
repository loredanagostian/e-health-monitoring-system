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

  static String formatDateTimeUtc(String date, String time) {
    final parsedDate = DateFormat("EEEE, dd MMMM").parse(date);
    final parsedTime = DateFormat("HH:mm").parse(time);

    final combined = DateTime(
      DateTime.now().year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    return combined.toIso8601String();
  }
}
