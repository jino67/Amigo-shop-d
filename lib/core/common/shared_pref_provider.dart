import 'package:e_com/locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider =
    Provider<SharedPreferences>((ref) => locate<SharedPreferences>());
