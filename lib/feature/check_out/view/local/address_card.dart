import 'package:e_com/core/core.dart';
import 'package:e_com/feature/address/controller/address_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    this.onChangeTap,
    required this.checkout,
  });

  final Function()? onChangeTap;
  final CheckoutModel checkout;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: checkout.billingAddress != null
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) =>
                    AddressBottomSheet(checkout.billingAddress?.key),
              );
            },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.colorTheme.secondaryContainer.withOpacity(
            context.isDark ? 0.2 : 0.05,
          ),
          border: Border.all(
            color: context.colorTheme.secondaryContainer,
            width: 1,
          ),
        ),
        alignment: checkout.billingAddress == null ? Alignment.center : null,
        padding: defaultPaddingAll,
        child: checkout.billingAddress == null
            ? Text(
                Translator.chooseAddress(context),
                style: context.textTheme.titleMedium,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          checkout.billingAddress?.fullName ?? '',
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: context.colorTheme.secondary,
                        ),
                        onPressed: onChangeTap ??
                            () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => AddressBottomSheet(
                                  checkout.billingAddress?.key,
                                ),
                              );
                            },
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: Text(Translator.change(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    checkout.billingAddress?.phone ?? '',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    checkout.billingAddress?.email ?? '',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    checkout.billingAddress?.fullAddress ?? '',
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: context.textTheme.bodyLarge,
                      children: [
                        TextSpan(text: '${Translator.shippingBy(context)}: '),
                        TextSpan(
                          text: checkout.shipping?.methodName ?? 'N/A',
                          style: context.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AddressBottomSheet extends HookConsumerWidget {
  const AddressBottomSheet(this.addressKey, {super.key});
  final String? addressKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressListProvider);
    final aniCtrl = useAnimationController();
    return BottomSheet(
      animationController: aniCtrl,
      showDragHandle: true,
      onClosing: () {},
      builder: (c) => Container(
        decoration: BoxDecoration(
          color: context.colorTheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        padding: defaultPadding,
        child: Column(
          children: [
            Text(
              Translator.chooseAddress(context),
              style: context.textTheme.titleLarge,
            ),
            const Divider(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 40),
                foregroundColor: context.colorTheme.secondary,
                side: BorderSide(
                  color: context.colorTheme.secondary,
                  width: 1,
                ),
              ),
              onPressed: () => RouteNames.address.pushNamed(context),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(Translator.addAddress(context)),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: defaultScrollPhysics,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Card(
                  elevation: 0,
                  color: context.colorTheme.secondary
                      .withOpacity(addressKey == address.key ? .1 : .05),
                  shape: RoundedRectangleBorder(
                    borderRadius: defaultRadius,
                    side: addressKey != address.key
                        ? BorderSide.none
                        : BorderSide(
                            color: context.colorTheme.secondaryContainer,
                          ),
                  ),
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(address.fullName),
                    subtitle: Text(address.fullAddress),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      ref
                          .read(checkoutCtrlProvider.notifier)
                          .setBilling(address);
                      context.pop();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
