import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/settings/region_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

int intFromAny(dynamic value) {
  if (value is int) return value;
  if (value is String) return value.asInt;
  if (value is double) return value.toInt();
  return 0;
}

double doubleFromAny(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return value.asDouble;
  return 0;
}

num numFromAny(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value) ?? 0;

  return 0;
}

extension StringEx on String {
  int get asInt => isEmpty ? 0 : int.tryParse(this) ?? 0;

  double get asDouble => double.tryParse(this) ?? 0.0;

  String showUntil(int end, [int start = 0]) {
    return length >= end ? '${substring(start, end)}...' : this;
  }

  String ifEmpty([String onEmpty = 'EMPTY']) {
    return isEmpty ? onEmpty : this;
  }

  bool get isValidEmail {
    final reg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return reg.hasMatch(this);
  }

  bool get isValidPhone {
    final reg = RegExp(r"^[\+]?([0-9]{2})?[0-9]{11}$");
    return reg.hasMatch(this);
  }

  String get titleCaseSingle => '${this[0].toUpperCase()}${substring(1)}';
  String get toTitleCase => split(' ').map((e) => e.titleCaseSingle).join(' ');

  Color? toColorK([Color? fallbackColor]) {
    String hexColor = replaceAll("#", "");
    final color = int.tryParse("0xFF$hexColor");
    if (color == null) return fallbackColor;
    return Color(color);
  }
}

extension ConvertInt on num {
  String fromLocal(LocalCurrency local, [bool calculateRate = false]) {
    final cur = local.currency;
    var value = this;

    if (cur != null && calculateRate) value = value * cur.rate;

    //final sym = cur?.symbol ?? '\$';
    final sym = "FCFA";


    return "${value} FCFA";
  }

  String currency(CurrencyData currency, [bool calculateRate = false]) {
    final cur = currency;
    var value = this;

    if (calculateRate) value = value * cur.rate;
    return NumberFormat.currency(
      decimalDigits: this is int ? 0 : 2,
      customPattern: _pattern(currency.symbol),
    ).format(value);
  }

  String _pattern(String symbol) {
    dynamic onLeft =
        locate<SharedPreferences>().getBool(PrefKeys.currencyOnLeft) ?? true;

    symbol = symbol.replaceAll('.', '');
    //ajouter
    onLeft = false;

    final pattern =
        onLeft ? '$symbol##,##,##,##,##0' : '##,##,##,##,##0$symbol';

    return pattern;
  }
}

extension DateTimeFormat on DateTime {
  String formatDate(BuildContext context, [String pattern = 'dd-MM-yyyy']) {
    final locale = Localizations.localeOf(context);
    return DateFormat(pattern, locale.languageCode).format(this);
  }

  String welcomeMassage(BuildContext context) {
    final hour = this.hour;
    String massage = '';

    if (hour >= 0 && hour < 6) {
      massage = Translator.night(context);
    } else if (hour >= 6 && hour < 11) {
      massage = Translator.morning(context);
    } else if (hour >= 11 && hour < 16) {
      massage = Translator.noon(context);
    } else if (hour >= 16 && hour < 18) {
      massage = Translator.evening(context);
    } else if (hour >= 18 && hour < 24) {
      massage = Translator.night(context);
    }

    return massage;
  }
}

extension IterableEx<T> on Iterable<T> {
  List<T> takeFirst([int listLength = 10]) {
    final itemCount = length;
    final takeCount = itemCount > listLength ? listLength : itemCount;
    return take(takeCount).toList();
  }
}

extension ListEx<T> on List<T?> {
  List<T> removeNull() {
    return where((e) => e != null).map((e) => e!).toList();
  }
}

extension MaterialStateSet on Set<MaterialState> {
  bool get isHovered => contains(MaterialState.hovered);
  bool get isFocused => contains(MaterialState.focused);
  bool get isPressed => contains(MaterialState.pressed);
  bool get isDragged => contains(MaterialState.dragged);
  bool get isSelected => contains(MaterialState.selected);
  bool get isScrolledUnder => contains(MaterialState.scrolledUnder);
  bool get isDisabled => contains(MaterialState.disabled);
  bool get isError => contains(MaterialState.error);
}

extension WidgetEx on Widget {
  Widget conditionalExpanded(bool condition, [int flex = 1]) =>
      condition ? Expanded(flex: flex, child: this) : this;
}

extension AnimationEx on Animation<double> {
  Animation<double> withCurve(Curve curve) =>
      CurvedAnimation(parent: this, curve: curve);
}

/// Extension methods for Map
extension MapEx<K, V> on Map<K, V> {
  V? firstNoneNull() =>
      isEmpty ? null : values.firstWhereOrNull((e) => e != null);

  V? valueOrFirst(String? key, String? defKey, [V? defaultValue]) {
    return this[key] ?? this[defKey] ?? defaultValue;
  }

  Map<K, V> nonNull() {
    return {...this}..removeWhere((key, value) => value == null);
  }

  Map<K, V> nonNullAndEmpty() {
    return {...this}
      ..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
  }

  Map<K, V> log() {
    Logger.json(this);
    return this;
  }

  // int operator >>(String key) {

  //   return this[key] as int;
  // }

  int parseInt(String key, [int fallBack = 0]) {
    final it = this[key];
    if (it == null) return fallBack;
    if (it is num) return it.toInt();
    if (it is String) return int.tryParse(it) ?? fallBack;
    return fallBack;
  }

  double parseDouble(String key, [double fallBack = 0.0]) {
    final it = this[key];
    if (it == null) return fallBack;
    if (it is num) return it.toDouble();
    if (it is String) return double.tryParse(it) ?? fallBack;
    return fallBack;
  }

  num parseNum(String key, [num fallBack = 0]) {
    final it = this[key];
    if (it == null) return fallBack;
    if (it is num) return it;
    if (it is String) return num.tryParse(it) ?? fallBack;
    return fallBack;
  }

  bool? parseBool<T>(String key) {
    final it = this[key];
    if (it == null) return null;
    if (it is bool) return it;
    if (it is String) return bool.tryParse(it);

    if (it == '1' || it == 1) return true;
    if (it == '0' || it == 0) return false;
    return null;
  }

  T? convert<T>(T Function(Map<K, V> map) converter) => converter(this);
}

extension FutureResEx<T> on Future<Response<T>> {
  Future<Response<T>> logData() {
    return doAndReturn(
      (r) {
        Logger.json(r.data, r.requestOptions.uri.path);

        final data = r.requestOptions.data;
        final body = {};

        if (data is FormData) {
          for (var field in data.fields) {
            body.addAll({field.key: field.value});
          }
          Logger.json(body, 'body of ${r.requestOptions.uri.path}');
        }
      },
    );
  }
}

extension FutureEx<T> on Future<T> {
  /// Do some task and return the value of the future
  Future<T> doAndReturn(void Function(T data) task) => then((r) {
        task(r);
        return r;
      });
}
