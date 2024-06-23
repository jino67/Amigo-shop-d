import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final connectionProvider = StreamProvider<bool>((ref) async* {
  yield* InternetConnectionChecker().onStatusChange.map((event) {
    return event == InternetConnectionStatus.connected;
  });
});

final serverStatusProvider =
    AutoDisposeNotifierProvider<ServerStatusNotifier, ServerStatus>(
        ServerStatusNotifier.new);

class ServerStatusNotifier extends AutoDisposeNotifier<ServerStatus> {
  void update(int? code) {
    if (code == null) return;

    final status = ServerStatus.fromCode(code);
    if (status == state) return;

    state = status;
  }

  Future<void> retryStatusResolver() async {
    await ref.read(settingsCtrlProvider.notifier).reload();
  }

  @override
  ServerStatus build() {
    ServerStatus status = ServerStatus.active;

    final connected = ref.watch(connectionProvider);

    connected.whenData((isConnected) {
      if (!isConnected) status = ServerStatus.noInternet;
    });

    return status;
  }
}

enum ServerStatus {
  active,
  maintenance,
  noInternet,
  invalidPurchase;

  String? get paths => switch (this) {
        ServerStatus.active => null,
        ServerStatus.maintenance => RouteNames.maintenance.path,
        ServerStatus.noInternet => RouteNames.noInternet.path,
        ServerStatus.invalidPurchase => RouteNames.invalidPurchase.path,
      };
  int? get code => switch (this) {
        active => null,
        maintenance => 1000000,
        noInternet => 0,
        invalidPurchase => 2000000,
      };

  factory ServerStatus.fromCode(int? code) => switch (code) {
        null => ServerStatus.noInternet,
        1000000 => ServerStatus.maintenance,
        2000000 => ServerStatus.invalidPurchase,
        _ => ServerStatus.active,
      };

  bool get isActive => this == ServerStatus.active;
  bool get isMaintenance => this == ServerStatus.maintenance;
  bool get isNoInternet => this == ServerStatus.noInternet;
  bool get isInvalidPurchase => this == ServerStatus.invalidPurchase;
}
