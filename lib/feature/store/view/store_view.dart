import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/products/view/local/product_card.dart';
import 'package:e_com/feature/store/controller/shop_ctrl.dart';
import 'package:e_com/feature/store/view/local/store_loader.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../products/view/local/digital_product_card.dart';

class StoreView extends HookConsumerWidget {
  const StoreView(this.storeId, {super.key});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeDetails = ref.watch(storeDetailsCtrlProvider(storeId));
    final storeCtrl =
        useCallback(() => ref.read(storeDetailsCtrlProvider(storeId).notifier));
    final tabCtrl = useTabController(initialLength: 2);

    return storeDetails.when(
      loading: () => const StoreLoading(),
      error: (e, s) => ErrorView.reload(
        e,
        s,
        () => ref.refresh(storeDetailsCtrlProvider(storeId)),
      ),
      data: (storeData) => Scaffold(
        appBar: KAppBar(
          leading: SquareButton.backButton(
            onPressed: () => context.pop(),
          ),
          title: Text(Translator.store(context)),
          actions: [
            IconButton.outlined(
              onPressed: () async {
                await Share.shareUri(Uri.parse(storeData.store.link));
              },
              icon: const Icon(Icons.share_rounded),
            ),
            const SizedBox(width: 5)
          ],
        ),
        body: Padding(
          padding: defaultPadding,
          child: NestedScrollView(
            physics: defaultScrollPhysics,
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(
                child: StoreHeader(
                  storeData: storeData,
                  onFollowTap: () => storeCtrl().followShop(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: TabBar.secondary(
                  padding: const EdgeInsets.all(0),
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: tabCtrl,
                  tabs: [
                    Tab(
                      text: Translator.products(context),
                    ),
                    Tab(
                      text: Translator.digitals(context),
                    ),
                  ],
                ),
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TabBarView(
                controller: tabCtrl,
                children: [
                  if (storeData.products.listData.isEmpty)
                    const Center(child: NoItemsAnimation())
                  else
                    MGridViewWithFooter(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: context.onMobile ? 2 : 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      onNext: () => storeCtrl().next(true),
                      onPrevious: () => storeCtrl().previous(true),
                      pagination: storeData.products.pagination,
                      itemCount: storeData.products.listData.length,
                      builder: (context, index) => ProductCard(
                        product: storeData.products.listData[index],
                        type: CachedKeys.shops,
                      ),
                    ),
                  if (storeData.digitalProducts.listData.isEmpty)
                    const Center(child: NoItemsAnimation())
                  else
                    MGridViewWithFooter(
                      crossAxisCount: context.onMobile ? 2 : 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      onNext: () => storeCtrl().next(false),
                      onPrevious: () => storeCtrl().previous(false),
                      pagination: storeData.products.pagination,
                      itemCount: storeData.digitalProducts.listData.length,
                      builder: (context, index) => DigitalProductCard(
                        product: storeData.digitalProducts.listData[index],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StoreHeader extends HookConsumerWidget {
  const StoreHeader({
    super.key,
    required this.onFollowTap,
    required this.storeData,
  });

  final StoreDetailsModel storeData;
  final Function() onFollowTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userID =
        ref.watch(userDashProvider.select((value) => value?.user.id));
    final isFollowing = storeData.store.followers.contains(userID);
    final isLoggedIn = ref.watch(authCtrlProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colorTheme.primaryContainer
                .withOpacity(context.isDark ? 0.3 : 0.04),
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: defaultRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: const Size(2800, 700).aspectRatio,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: defaultRadiusOnlyTop,
                    image: DecorationImage(
                      image: HostedImage.provider(storeData.store.storeBanner),
                    ),
                  ),
                  child: HostedImage(storeData.store.storeBanner),
                ),
              ),
              Positioned(
                bottom: -45,
                left: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(
                          color: context.colorTheme.secondary.withOpacity(0.2),
                        ),
                        color: Colors.white,
                      ),
                      height: 70,
                      width: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: HostedImage(
                          storeData.store.storeLogo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeData.store.name,
                          style: context.textTheme.titleLarge,
                        ),
                        KRatingBar(
                          rating: storeData.store.rating.toDouble(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: defaultPadding,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 10),
                    SelectableText(
                      storeData.store.phone,
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 10),
                    SelectableText(
                      storeData.store.email,
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorTheme.secondaryContainer
                            .withOpacity(0.1),
                        borderRadius: defaultRadius,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        '${storeData.store.totalProducts} ${Translator.products(context)}',
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorTheme.secondaryContainer
                            .withOpacity(0.1),
                        borderRadius: defaultRadius,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Text(
                        '${storeData.store.followers.length} ${Translator.followers(context)}',
                      ),
                    ),
                    const Spacer(),
                    if (isLoggedIn)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          foregroundColor: isFollowing
                              ? context.colorTheme.primary
                              : context.colorTheme.onPrimary,
                          backgroundColor: isFollowing
                              ? context.colorTheme.surface
                              : context.colorTheme.primary,
                          side: isFollowing
                              ? BorderSide(
                                  color: context.colorTheme.outline,
                                )
                              : null,
                        ),
                        onPressed: onFollowTap,
                        child: Text(
                          isFollowing
                              ? Translator.unfollow(context)
                              : Translator.follow(context),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
