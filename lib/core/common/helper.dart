import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ClipBoardHelper {
  const ClipBoardHelper._();
  static copy(String text) => Clipboard.setData(ClipboardData(text: text));
}

class URLHelper {
  const URLHelper._();

  static url(String url) async {
    if (!url.startsWith(RegExp('(http(s)://.)'))) url = 'https://$url';

    await launchUrlString(url);
  }

  static call(String number) async {
    if (number.isValidPhone) {
      await launchUrl(
        Uri(scheme: "tel", path: number),
      );
    }
  }

  static mail(String mail) async {
    if (mail.isValidEmail) {
      await launchUrl(
        Uri(scheme: "mailto", path: mail),
      );
    }
  }

  static massage(String number, String message) async {
    if (number.isValidPhone) {
      launchUrl(
        Uri(
          scheme: "sms",
          path: number,
          queryParameters: <String, String>{
            'body': Uri.encodeComponent(message),
          },
        ),
      );
    }
  }
}

hideSoftKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
