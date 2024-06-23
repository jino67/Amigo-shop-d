import 'package:e_com/core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locate = GetIt.instance;

Future<void> locatorSetUp() async {
  final pref = await SharedPreferences.getInstance();

  locate.registerSingleton<SharedPreferences>(pref);
  locate.registerSingleton<TalkerConfig>(TalkerConfig());
}
