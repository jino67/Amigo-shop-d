import 'package:e_com/models/settings/payment_model.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentMethodCard extends ConsumerWidget {
  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
  });
  final PaymentData paymentMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: HostedImage(paymentMethod.image),
            ),
            Text(
              paymentMethod.name,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
