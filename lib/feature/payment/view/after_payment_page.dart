import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AfterPaymentView extends HookConsumerWidget {
  const AfterPaymentView(this.status, {super.key});

  final String? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future(() {
        if (ref.read(authCtrlProvider)) {
          ref.read(userDashCtrlProvider.notifier).reload();
        }
      });
      return null;
    }, const []);

    final isSuccess = status == 's';

    return Scaffold(
      body: Padding(
        padding: defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Assets.illustration.payment.path,
              height: 300,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: isSuccess
                    ? context.colorTheme.errorContainer.withOpacity(0.1)
                    : context.colorTheme.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  isSuccess ? Icons.done : Icons.close,
                  size: 20,
                  color: isSuccess
                      ? context.colorTheme.errorContainer
                      : context.colorTheme.error,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Text(
              isSuccess
                  ? Translator.paymentSuccess(context)
                  : Translator.paymentFailed(context),
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              isSuccess
                  ? Translator.paymentSuccessMassage(context)
                  : Translator.paymentFailedMassage(context),
              style: context.textTheme.bodyLarge,
            ),
            if (ref.watch(authCtrlProvider))
              GestureDetector(
                onTap: () => RouteNames.orders.pushNamed(context),
                child: Text(
                  Translator.orderHistory(context),
                  style: context.textTheme.bodyLarge!.copyWith(
                    decorationColor: context.colorTheme.primary,
                    fontWeight: FontWeight.bold,
                    color: context.colorTheme.primary,
                  ),
                ),
              ),
            const SizedBox(height: 30),
            SubmitButton(
              onPressed: () => RouteNames.home.goNamed(context),
              child: Text(Translator.continueShopping(context)),
            ),
            const Spacer(),
            Text(
              Translator.haveQuestion(context),
              style: context.textTheme.bodyLarge,
            ),
            GestureDetector(
              onTap: () => RouteNames.supportTicket.pushNamed(context),
              child: Text(
                Translator.customerSupport(context),
                style: context.textTheme.bodyLarge?.copyWith(
                  decorationColor: context.colorTheme.primary,
                  fontWeight: FontWeight.bold,
                  color: context.colorTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
