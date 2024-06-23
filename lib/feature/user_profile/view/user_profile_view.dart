import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/user_profile/controller/user_profile_ctrl.dart';
import 'package:e_com/feature/user_profile/view/local/order_slider.dart';
import 'package:e_com/feature/user_profile/view/local/user_appbar.dart';
import 'package:e_com/feature/user_profile/view/local/user_order_card.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user_dash/provider/user_dash_provider.dart';

class UserProfileView extends HookConsumerWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final userDash = ref.watch(userDashProvider);
    if (userDash == null) return ErrorView.withScaffold('No User Found');
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final orderCount = userDash.orders.listData.length +
        userDash.digitalOrders.listData.length;
    final digitalOrder = userDash.digitalOrders.listData.length;
    final shippedOrder =
        userDash.orders.listData.where((e) => e.status == OrderStatus.shipped);
    final toReview = userDash.orders.listData
        .where((e) => e.status == OrderStatus.delivered);

    final isLogout = useState(false);
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(onPressed: () => context.pop()),
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () => RouteNames.userEditing.pushNamed(context),
                leadingIcon: const Icon(Icons.edit_rounded, size: 20),
                child: Text(Translator.editProfile(context)),
              ),
              MenuItemButton(
                onPressed: () => RouteNames.changePassword.pushNamed(context),
                leadingIcon: const Icon(Icons.password, size: 20),
                child: Text(Translator.updatePassword(context)),
              ),
            ],
            builder: (_, controller, __) => IconButton(
              onPressed: controller.open,
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: UserAppbar(user: user),
        ),
      ),
      body: Padding(
        padding: defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: UserOrderCard(
                    icon: Icons.shopping_cart,
                    onTap: () {
                      RouteNames.orders.pushNamed(context);
                    },
                    title: Translator.allOrder(context),
                    subtitle:
                        '${Translator.total(context)} : ${orderCount.toString()}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: UserOrderCard(
                    icon: Icons.trolley,
                    onTap: () {
                      RouteNames.orders.pushNamed(
                        context,
                        query: {'status': OrderStatus.shipped.name},
                      );
                    },
                    title: Translator.shippedOrder(context),
                    subtitle:
                        '${Translator.total(context)} : ${shippedOrder.length.toString()}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: UserOrderCard(
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () {
                      RouteNames.orders.pushNamed(context, query: {'tab': '1'});
                    },
                    title: Translator.digitalOrder(context),
                    subtitle: '${Translator.total(context)} : $digitalOrder',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: UserOrderCard(
                    icon: Icons.rate_review_rounded,
                    onTap: () {
                      RouteNames.orders.pushNamed(
                        context,
                        query: {'status': OrderStatus.delivered.name},
                      );
                    },
                    title: Translator.toReview(context),
                    subtitle:
                        '${Translator.total(context)} : ${toReview.length.toString()}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (userDash.orders.listData.isNotEmpty)
              OrderSliderView(userDash: userDash),
            const Spacer(),
            SubmitButton(
              onPressed: () async {
                isLogout.value = true;
                await authCtrl().logOut();
                isLogout.value = false;
              },
              width: context.width,
              isLoading: isLogout.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout),
                  const SizedBox(width: 20),
                  Text(Translator.logout(context)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
