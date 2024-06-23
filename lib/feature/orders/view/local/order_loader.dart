import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OrderLoader extends StatelessWidget {
  const OrderLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          KShimmer.card(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
          ),
          KShimmer.card(
            height: 70,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
          ),
          KShimmer.card(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
          ),
          KShimmer.card(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
          ),
          KShimmer.card(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
          ),
        ],
      ),
    );
  }
}
