import 'package:e_com/core/core.dart';
import 'package:e_com/feature/address/repository/address_repo.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/models/user_content/billing_address.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addressListProvider = Provider<List<BillingAddress>>((ref) {
  final addresses =
      ref.watch(userDashProvider.select((v) => v?.user.billingAddress));

  return addresses ?? [];
});

final addressCtrlProvider = AutoDisposeNotifierProviderFamily<
    AddressCtrlNotifier,
    BillingAddress,
    BillingAddress?>(AddressCtrlNotifier.new);

class AddressCtrlNotifier
    extends AutoDisposeFamilyNotifier<BillingAddress, BillingAddress?> {
  @override
  BillingAddress build(BillingAddress? arg) {
    return arg ?? BillingAddress.empty;
  }

  AddressRepo get _repo => ref.read(addressRepoProvider);

  Future<void> saveAddress(BillingAddress address, [String? oldKey]) async {
    state = address;
    if (oldKey != null) state = state.setOldKey(oldKey);
  }

  Future<void> submitAddress() async {
    final res = state.oldKey == null
        ? await _repo.createAddress(state)
        : await _repo.updateAddress(state);

    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(userDashCtrlProvider.notifier).reload();
        if (state.oldKey == null) {
          Toaster.showSuccess('Address Saved Successfully');
        } else {
          Toaster.showSuccess('Address Updated Successfully');
        }
      },
    );
    return;
  }

  Future<void> deleteAddress([String? key]) async {
    final res = await _repo.deleteAddress(key ?? state.key);
    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(userDashCtrlProvider.notifier).reload();
        Toaster.showSuccess('Address Deleted Successfully');
      },
    );
    return;
  }
}
