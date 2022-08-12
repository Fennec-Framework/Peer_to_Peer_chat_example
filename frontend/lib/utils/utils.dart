import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String body,
      {Color? color, Icon? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            icon ?? const SizedBox.shrink(),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color ?? Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  static Color getColorByString(String str) {
    return Colors.primaries[str.hashCode % Colors.primaries.length];
  }

  static String parseDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime todayDateTime = DateTime.now();
    final Duration duration = todayDateTime.difference(dateTime);

    if (duration.inDays > 62) {
      return "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
    } else if (duration.inDays > 1) {
      return "${(duration.inDays / 7).ceil()} weeks ago";
    } else if (duration.inDays == 1 && duration.inHours > 23) {
      return "yesterday";
    } else if (duration.inHours >= 1) {
      return "${duration.inHours} hours ago";
    } else if (duration.inMinutes > 1) {
      return "${duration.inMinutes} minutes ago";
    }
    return "now";
  }

  static String chatHashedCodeId(
      {required String firstUserId, required String secondUserId}) {
    if (firstUserId.hashCode >= secondUserId.hashCode) {
      return "$firstUserId-$secondUserId";
    }
    return "$secondUserId-$firstUserId";
  }

  static bool isValidEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  static bool hasValidUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
