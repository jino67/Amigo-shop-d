import 'package:e_com/core/core.dart';
import 'package:e_com/feature/products/view/local/product_card.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final didScrollAnimationEnded = StateProvider<bool>((ref) {
  return false;
});

class ProductShowcase extends HookConsumerWidget {
  const ProductShowcase({
    super.key,
    required this.products,
    required this.type,
  });
  final String? type;
  final List<ProductsData> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
    final didAnimationEnd = ref.watch(didScrollAnimationEnded);

    Future<void> animateScroll() async {
      if (didAnimationEnd) return;
      await controller.animateTo(
        50,
        duration: 500.milliseconds,
        curve: Curves.easeInQuart,
      );
      await controller.animateTo(
        0,
        duration: 500.milliseconds,
        curve: Curves.easeOutQuad,
      );
      ref.read(didScrollAnimationEnded.notifier).update((_) => true);
    }

    useEffect(() {
      Future.delayed(0.ms, () => animateScroll());
      return null;
    }, const []);

    return SingleChildScrollView(
      controller: controller,
      physics: defaultScrollPhysics,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ProductCard(
                product: product,
                height: 200,
                type: type,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
