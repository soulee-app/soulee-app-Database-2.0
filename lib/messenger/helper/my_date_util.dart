import 'package:flutter/material.dart';

class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      return TimeOfDay.fromDateTime(date).format(context);
    } catch (e) {
      print('Error parsing formatted time: $e');
      return 'Invalid time';
    }
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    try {
      final DateTime sent =
          DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final DateTime now = DateTime.now();

      final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
      if (now.day == sent.day &&
          now.month == sent.month &&
          now.year == sent.year) {
        return formattedTime;
      }

      return now.year == sent.year
          ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
          : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
    } catch (e) {
      print('Error parsing message time: $e');
      return 'Invalid time';
    }
  }

  // get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    try {
      final DateTime sent =
          DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final DateTime now = DateTime.now();

      if (now.day == sent.day &&
          now.month == sent.month &&
          now.year == sent.year) {
        return TimeOfDay.fromDateTime(sent).format(context);
      }

      return showYear
          ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
          : '${sent.day} ${_getMonth(sent)}';
    } catch (e) {
      print('Error parsing last message time: $e');
      return 'Invalid time';
    }
  }

  // get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    // if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    try {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
      DateTime now = DateTime.now();

      String formattedTime = TimeOfDay.fromDateTime(time).format(context);
      if (time.day == now.day &&
          time.month == now.month &&
          time.year == time.year) {
        return 'Last seen today at $formattedTime';
      }

      if ((now.difference(time).inHours / 24).round() == 1) {
        return 'Last seen yesterday at $formattedTime';
      }

      String month = _getMonth(time);

      return 'Last seen on ${time.day} $month on $formattedTime';
    } catch (e) {
      print('Error parsing last active time: $e');
      return 'Last seen not available';
    }
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
