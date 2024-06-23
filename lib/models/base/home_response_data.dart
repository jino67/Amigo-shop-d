import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';

class HomeResponseData {
  HomeResponseData({
    required this.banners,
    required this.categories,
    required this.brands,
    required this.todayDeals,
    required this.newArrival,
    required this.bestSelling,
    required this.campaigns,
    required this.digitalProducts,
    required this.suggestedProducts,
    required this.stores,
    required this.flash,
    required this.dynamicCategory,
  });

  factory HomeResponseData.fromJson(String source) =>
      HomeResponseData.fromMap(json.decode(source));

  factory HomeResponseData.fromMap(Map<String, dynamic> map) {
    return HomeResponseData(
      banners: Banners.fromMap(map['banners']),
      categories: CategoriesBase.fromMap(map['categories']),
      brands: Brands.fromMap(map['brands']),
      todayDeals: ItemListWithPageData<ProductsData>.fromMap(
          map['today_deals'], (x) => ProductsData.fromMap(x)),
      newArrival: ItemListWithPageData<ProductsData>.fromMap(
          map['new_arrival'], (x) => ProductsData.fromMap(x)),
      bestSelling: ItemListWithPageData<ProductsData>.fromMap(
          map['best_selling'], (x) => ProductsData.fromMap(x)),
      campaigns: ItemListWithPageData<CampaignModel>.fromMap(
          map['campaigns'], (x) => CampaignModel.fromMap(x)),
      digitalProducts: ItemListWithPageData<DigitalProduct>.fromMap(
          map['digital_product'], (x) => DigitalProduct.fromMap(x)),
      suggestedProducts: ItemListWithPageData<ProductsData>.fromMap(
          map['suggested_products'], (x) => ProductsData.fromMap(x)),
      stores: ItemListWithPageData<StoreModel>.fromMap(
          map['shops'], (x) => StoreModel.fromMap(x)),
      flash: map['flash_deals'] == null || map['flash_deals'].isEmpty
          ? null
          : FlashDeal.fromMap(map['flash_deals']),
      dynamicCategory: map['home_category'] == null
          ? []
          : List<CategoryDetails>.from(map['home_category']['data']
              .map((x) => CategoryDetails.fromMap(x))),
    );
  }

  final Banners banners;
  final Brands brands;
  final CategoriesBase categories;
  final FlashDeal? flash;
  final ItemListWithPageData<CampaignModel> campaigns;
  final ItemListWithPageData<ProductsData> bestSelling;
  final ItemListWithPageData<DigitalProduct> digitalProducts;
  final ItemListWithPageData<ProductsData> newArrival;
  final ItemListWithPageData<ProductsData> todayDeals;
  final ItemListWithPageData<ProductsData> suggestedProducts;
  final ItemListWithPageData<StoreModel> stores;
  final List<CategoryDetails> dynamicCategory;

  Map<String, dynamic> toMap() => {
        'banners': banners.toMap(),
        'categories': categories.toMap(),
        'brands': brands.toMap(),
        'today_deals': todayDeals.toMap((data) => data.toMap()),
        'new_arrival': newArrival.toMap((data) => data.toMap()),
        'best_selling': bestSelling.toMap((data) => data.toMap()),
        'campaigns': campaigns.toMap((data) => data.toMap()),
        'digital_product': digitalProducts.toMap((data) => data.toMap()),
        'suggested_products': suggestedProducts.toMap((data) => data.toMap()),
        'shops': stores.toMap((data) => data.toMap()),
        'flash_deals': flash?.toMap(),
        'home_category': {'data': dynamicCategory.map((data) => data.toMap())},
      };

  ItemListWithPageData? mappedForPaging(String? key) {
    final map = {
      CachedKeys.todaysProducts: todayDeals,
      CachedKeys.newProducts: newArrival,
      CachedKeys.bestSaleProducts: bestSelling,
      CachedKeys.campaigns: campaigns,
      CachedKeys.digitalProducts: digitalProducts,
      CachedKeys.suggestedProducts: suggestedProducts,
      CachedKeys.shops: stores,
    };
    return map[key];
  }

  bool get isTodaysDealNotEmpty => todayDeals.listData.isNotEmpty;
  bool get isNewArrivalNotEmpty => newArrival.listData.isNotEmpty;
  bool get isBestSellingNotEmpty => bestSelling.listData.isNotEmpty;
  bool get isCampaignsNotEmpty => campaigns.listData.isNotEmpty;
  bool get isDigitalProductsNotEmpty => digitalProducts.listData.isNotEmpty;
  bool get isSuggestedProductsNotEmpty => suggestedProducts.listData.isNotEmpty;
  bool get isStoresNotEmpty => stores.listData.isNotEmpty;
  bool get isSliderNotEmpty => banners.bannersData.isNotEmpty;
  bool get isCategoriesNotEmpty => categories.categoriesData.isNotEmpty;
  bool get isBrandsNotEmpty => brands.brandsData.isNotEmpty;
  bool get isFlashNotEmpty => flash != null;
}
