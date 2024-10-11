import 'dart:convert';
import 'dart:developer';

import 'package:e_com/locator.dart';
import 'package:flutter/material.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talk = locate<TalkerConfig>();

class TalkerConfig {
  TalkerConfig()
      : talker = Talker(
          logger: TalkerLogger(
            output: (v) => log(v, name: '\u276f_'),
            formatter: const KLoggerFormatter(),
          ),
          settings: TalkerSettings(
            useConsoleLogs: logOnConsole,
            enabled: enable,
          ),
        );

  static bool enable = true;
  static bool logOnConsole = false;

  late final Talker talker;

  void critical(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    talker.critical(msg, exception, stackTrace);
  }

  void info(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    talker.info(msg, exception, stackTrace);
  }

  void error(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    talker.error(msg, exception, stackTrace);
  }

  void debug(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    talker.debug(msg, exception, stackTrace);
  }

  void verbose(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    talker.verbose(msg, exception, stackTrace);
  }

  void warning(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    talker.warning(msg, exception, stackTrace);
  }

  void ex(Object exception, [StackTrace? stackTrace, dynamic msg]) {
    talker.handle(exception, stackTrace, msg);
  }

  TalkerDioLogger get dioLogger => TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          printRequestData: false,
          printResponseData: true,
          responseFilter: (response) => response.statusCode != 200,
          requestPen: AnsiPen()..xterm(87),
        ),
      );

  goToLogView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TalkerScreen(
          talker: talker,
          theme: const TalkerScreenTheme(
            backgroundColor: Colors.black,
            cardColor: Colors.black45,
          ),
        ),
      ),
    );
  }
}

class Logger {
  Logger([Object? obj, String name = 'LOG']) {
    _log(obj, name);
  }

  static json(response, [String name = 'JSON']) {
    _log(_prettyJSON(response), name, true);
  }

  static String _prettyJSON(response) {
    try {
      var encoder = const JsonEncoder.withIndent("  ");
      return encoder.convert(response);
    } catch (e) {
      _log(e, '_prettyJSON');
      return response;
    }
  }

  static void _log(Object? obj, [String name = 'LOG', bool isJson = false]) {
    final talk = Talker(
      logger: TalkerLogger(
        formatter: const KLoggerFormatter(),
        output: (v) => log(v, name: '\u276f_'),
      ),
    );
    talk.logTyped(_KLog(obj.toString(), name, isJson));
  }
}

class KLoggerFormatter implements LoggerFormatter {
  const KLoggerFormatter();

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final underline = ConsoleUtils.getUnderline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
      // withCorner: true,
    );
    final topLine = ConsoleUtils.getTopline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
      // withCorner: true,
    );

    final msg = details.message?.toString() ?? '';

    final msgBorderedLines = msg.split('\n').map((e) => '  $e');

    if (!settings.enableColors) {
      return '$topLine\n$msg\n$underline';
    }

    var lines = [topLine, ...msgBorderedLines, underline];
    lines = lines.map((e) => details.pen.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }
}

class RouteLogger extends TalkerLog {
  RouteLogger({
    required Route route,
    bool isPush = true,
  }) : super(_createMessage(route, isPush));

  @override
  AnsiPen get pen => AnsiPen()..xterm(38);

  @override
  String get key => TalkerLogType.route.key;

  @override
  // String generateTextMessage() {
  //   return '[$title]  $displayMessage';
  // }

  static String _createMessage(
    Route<dynamic> route,
    bool isPush,
  ) {
    final buffer = StringBuffer();
    buffer.write(isPush ? 'Open' : 'Close');
    buffer.write(' route named ');
    buffer.write(route.settings.name ?? 'null');

    final args = route.settings.arguments;
    if (args != null) {
      buffer.write('\nArguments: $args');
    }
    return buffer.toString();
  }
}

class _KLog extends TalkerLog {
  _KLog(super.message, String title, [this.isJson = false])
      : super(title: title);

  final bool isJson;

  // @override
  // String generateTextMessage() {
  //   return '[$title]  $displayMessage$displayStackTrace';
  // }

  @override
  AnsiPen? get pen {
    if (isJson) return AnsiPen()..green();
    return super.pen;
  }
}
