import 'package:intl/intl.dart' as intl;

extension DifferenceExtension on DateTime {
  String getChatMessageTimeFormat() {
    if (this == null) return '--:--';
    final todaysDate = DateTime.now();

    double diff = todaysDate.difference(this).inMilliseconds.toDouble();
    double secondsInMilli = 1000;
    double minutesInMilli = secondsInMilli * 60;
    double hoursInMilli = minutesInMilli * 60;

    int elapsedHours = diff ~/ hoursInMilli;
    diff = diff % hoursInMilli;

    if (elapsedHours < 25) {
      return '${intl.DateFormat('hh:mm').format(this)}';
    } else if (elapsedHours < 48) {
      if (elapsedHours > 24)
        return 'Yesterday';
      else
        return '${intl.DateFormat('hh:mm').format(this)}';
    } else {
      return intl.DateFormat('dd/MM/yyyy').format(this);
    }
  }
}
