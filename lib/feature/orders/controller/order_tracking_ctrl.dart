import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/orders/repository/order_repo.dart';
import 'package:e_com/models/user_content/order_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderDetailsProvider =
    FutureProvider.family<OrderModel, String?>((ref, orderId) async {
  if (orderId == null) return Future.error('No Order ID');
  final result =
      await ref.watch(orderRepoProvider).getOrderDetails(orderId: orderId);

  return result.fold(
    (l) => Future.error(l.message, l.stackTrace),
    (r) => r.data,
  );
});

final orderTrackingCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    OrderTrackingNotifier, OrderModel?, String?>(OrderTrackingNotifier.new);

class OrderTrackingNotifier
    extends AutoDisposeFamilyAsyncNotifier<OrderModel?, String?> {
  @override
  FutureOr<OrderModel?> build(String? arg) async {
    final repo = ref.watch(orderRepoProvider);
    if (arg == null) return null;

    final result = await repo.getOrderDetails(orderId: arg);
    return result.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  Future<void> trackOrder(String id) async {
    final repo = ref.read(orderRepoProvider);
    state = const AsyncValue.loading();

    final res = await repo.getOrderDetails(orderId: id);

    res.fold(
      (l) {
        Toaster.showError(l);
        state = const AsyncValue.data(null);
      },
      (r) => state = AsyncValue.data(r.data),
    );
  }

  Future<void> reload(String id) async {
    if (id.isNotEmpty) {
      await trackOrder(id);
      return;
    }

    ref.invalidateSelf();
  }
}
