import 'package:e_com/core/core.dart';
import 'package:e_com/feature/on_board/controller/onboard_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'go_route_name.dart';
import 'page/error_route_page.dart';
import 'route_list.dart';

final goRoutesProvider = Provider.autoDispose<GoRouter>((ref) {
  final rootNavigator = GlobalKey<NavigatorState>(debugLabel: 'root');
  Toaster.navigator = rootNavigator;

  final routeList = ref.watch(routeListProvider(rootNavigator));

  final isFirst = ref.watch(onboardCtrlProvider);

  final serverStatus = ref.watch(serverStatusProvider);

  final router = GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: RouteNames.home.path,
    routes: routeList,
    redirect: (context, state) {
      final current = state.uri.toString();
      Logger(current, 'ROUTE');

      final statusResult = serverStatus.paths;

      if (statusResult != null) return statusResult;

      if (isFirst) return RouteNames.onboard.path;

      return null;
    },
    errorBuilder: (context, state) => ErrorRoutePage(error: state.error),
  );

  return router;
});
