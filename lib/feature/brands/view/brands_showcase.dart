import 'package:e_com/core/core.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BrandShowcase extends ConsumerWidget {
  const BrandShowcase({super.key, required this.brands});

  final List<BrandData> brands;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeCurrencyStateProvider);

    return GridView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.none,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brands.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.onMobile ? 3 : 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final brand = brands[index];
        return InkWell(
          borderRadius: defaultRadius,
          onTap: () => RouteNames.brandProducts
              .pushNamed(context, pathParams: {'id': brand.uid}),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0, color: context.colorTheme.secondaryContainer),
              borderRadius: defaultRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: context.onMobile ? 50 : 70,
                    width: context.onMobile ? 50 : 70,
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: HostedImage.provider(brand.logo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    brand.name.valueOrFirst(locale.langCode, defLocale(ref)) ??
                        '',
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
