library time_ago_provider;

import '../core/core.dart';

class TimeAgo {
  // static const int SECOND_MILLIS = 1000;
  static const int minute = 60 * 1000;
  static const int hour = 60 * minute;
  static const int day = 24 * hour;
  static const int month = 30 * day;
  static const int year = 12 * month;

  static String getTimeAgo(int timeStamp) {
    if (timeStamp < 1000000000000) {
      timeStamp *= 1000;
    }

    int now = DateTime.now().millisecondsSinceEpoch;
    if (timeStamp > now || timeStamp <= 0) {
      return "just now";
    }

    final int difference = now - timeStamp;
    if (difference < minute) {
      return "just now";
    } else if (difference < 2 * minute) {
      return "a minute ago";
    } else if (difference < 50 * minute) {
      return "${(difference / minute).toString().split(".")[0]}m ago";
    } else if (difference < 90 * minute) {
      return "an hour ago";
    } else if (difference < 24 * hour) {
      return "${(difference / hour).toString().split(".")[0]} hours ago";
    } else if (difference < 48 * hour) {
      return "Yesterday";
    } else if (difference < 7 * day) {
      return "${(difference / day).toString().split(".")[0]} days ago";

      // } else if (difference < 12 * month) {
      //       return (difference / month < 2)
      //           ? "a month ago"
      //           : "${(difference / month).toString().split(".")[0]} months ago";

    } else {
      DateTime d = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String mon;
      mon = Months.english[d.month - 1];
      return "${d.day} $mon";
    }
  }
}
