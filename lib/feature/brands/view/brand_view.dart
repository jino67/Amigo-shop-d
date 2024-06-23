import 'package:e_com/core/core.dart';
import 'package:e_com/feature/brands/provider/brand_provider.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/app_bar.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:e_com/widgets/buttons/square_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BrandsView extends ConsumerWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(brandListProvider);
    final locale = ref.watch(localeCurrencyStateProvider);

    return Scaffold(
      appBar: KAppBar(
        title: Text(Translator.brands(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: context.onMobile
            ? defaultPadding
            : const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.onMobile ? 3 : 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          physics: defaultScrollPhysics,
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];

            return InkWell(
              borderRadius: defaultRadius,
              onTap: () => RouteNames.brandProducts
                  .goNamed(context, pathParams: {'id': brand.uid}),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: context.colorTheme.secondaryContainer,
                    ),
                    borderRadius: defaultRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HostedImage(
                          brand.logo,
                          height: context.onMobile ? 50 : 70,
                          width: context.onMobile ? 50 : 70,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          brand.name.valueOrFirst(
                                  locale.langCode, defLocale(ref)) ??
                              '',
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
