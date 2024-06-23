class UiSectionModel {
  UiSectionModel({
    required this.heading,
    required this.subHeading,
  });

  factory UiSectionModel.fromMap(Map<String, dynamic> map) {
    return UiSectionModel(
      heading: map['heading']?['value'],
      subHeading: map['sub_heading']?['value'],
    );
  }

  final String? subHeading;
  final String heading;

  Map<String, dynamic> toMap() {
    return {
      'heading': {'value': heading},
      'sub_heading': {'value': subHeading},
    };
  }
}

class FrontendSection {
  FrontendSection({
    required this.todaysDeal,
    required this.flashSale,
    required this.campaign,
    required this.bestSelling,
    required this.newArrivals,
    required this.digitalProducts,
  });

  final UiSectionModel? bestSelling;
  final UiSectionModel? campaign;
  final UiSectionModel? digitalProducts;
  final UiSectionModel? flashSale;
  final UiSectionModel? newArrivals;
  final UiSectionModel? todaysDeal;

  static const String _slugBestSelling = 'best-selling-products'; // featured
  static const String _slugCampaign = 'campaign';
  static const String _slugDigitalProducts = 'digital-products';
  static const String _slugFlashSale = 'flash-deals';
  static const String _slugNewArrivals = 'new-arrivals';
  static const String _slugTodaysDeal = 'todays-deals'; //deals of the day

  factory FrontendSection.fromMap(Map<String, dynamic> map) {
    return FrontendSection(
      bestSelling: _parseFrontEnd(map, _slugBestSelling),
      campaign: _parseFrontEnd(map, _slugCampaign),
      digitalProducts: _parseFrontEnd(map, _slugDigitalProducts),
      flashSale: _parseFrontEnd(map, _slugFlashSale),
      newArrivals: _parseFrontEnd(map, _slugNewArrivals),
      todaysDeal: _parseFrontEnd(map, _slugTodaysDeal),
    );
  }

  static UiSectionModel? _parseFrontEnd(Map<String, dynamic> map, String slug) {
    final frontEndData = List<Map<String, dynamic>>.from(map['data']);
    final parsed = frontEndData.firstWhere(
      (map) => map['slug'] == slug,
      orElse: () => {slug: 404},
    );
    if (parsed[slug] == 404) return null;

    return parsed['value'] == null
        ? null
        : UiSectionModel.fromMap(parsed['value']);
  }

  List<Map<String, dynamic>> toMappedList() {
    return [
      {
        'slug': _slugBestSelling,
        'value': bestSelling?.toMap(),
      },
      {
        'slug': _slugCampaign,
        'value': campaign?.toMap(),
      },
      {
        'slug': _slugDigitalProducts,
        'value': digitalProducts?.toMap(),
      },
      {
        'slug': _slugFlashSale,
        'value': flashSale?.toMap(),
      },
      {
        'slug': _slugNewArrivals,
        'value': newArrivals?.toMap(),
      },
      {
        'slug': _slugTodaysDeal,
        'value': todaysDeal?.toMap(),
      },
    ];
  }
}
