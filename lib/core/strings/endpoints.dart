class Endpoints {
  Endpoints._();
  static String? betaBaseUrl;

  // base url
  static const String baseUrl = "https://amigo-shop.goaicorporation.org/api";

  static final String baseApiUrl = betaBaseUrl ?? baseUrl;

  // connectTimeout
  static const Duration connectionTimeout = Duration(milliseconds: 25000);

  // receiveTimeout
  static const Duration receiveTimeout = Duration(milliseconds: 25000);

  static const String login = '/login';
  static const String signUp = '/register';
  static const String verifyOTP = '/verify-otp';
  static const String forgetPass = '/forgot-password';
  static const String passwordResetVerify = '/reset/password/verify';
  static const String passwordReset = '/reset-password';
  static const String logOut = '/logout';
  static const String updatePass = '/password/update';
  static const String home = '/home';
  static const String config = '/config';
  static const String wishlistAdd = '/add/wishlist';
  static const String wishlistDelete = '/delete/wishlist';
  static const String cartAdd = '/add/cart';
  static const String cartDelete = '/delete/cart';
  static const String cartUpdate = '/update/cart';
  static const String orderTrack = '/track/order';
  static const String userDash = '/dashboard';
  static const String checkout = '/checkout';
  static const String digitalCheckout = '/digital/checkout';

  static const String userProfileUpdate = '/profile/update';
  static const String review = '/review';
  static const String shop = '/shop';
  static String shopDetails(String id) => '/shop/visit/$id';

  static String productDetails(String uid, [String? campaignId]) =>
      campaignId == null ? '/product/$uid' : '/product/$uid/$campaignId';

  static String orderDetails(String uid) => '/order/details/$uid';
  static String payNow(String uid, int mUid) => '/pay/now/$uid/$mUid';
  static String shopFollow(String uid) => '/shop/flow/$uid';
  static String digitalProductDetails(String uid) => '/digital-product/$uid';
  static String categoryProducts(String uid) => '/category/products/$uid';
  static String brandProducts(String uid) => '/brand/products/$uid';
  static String campaignDetails(String uid) => '/campaigns/$uid';
  static const String addressAdd = '/address/store';
  static const String addressUpdate = '/address/update';
  static String addressDelete(String key) => '/address/delete/$key';

  static String searchProduct(String name, [String? category, String? brand]) {
    String base = '/product-search?name=$name';
    if (category != null) base = '$base&category_uid=$category';
    if (brand != null) base = '$base&brand_uid=$brand';

    return base;
  }

  static const String tickets = '/support/tickets';
  static const String ticketStore = '/support/ticket/store';

  static String ticket(String ticketNumber) => '/support/ticket/$ticketNumber';
  static String closeTicket(String ticketId) => '/closed/ticket/$ticketId';
  static String ticketReply(String ticketId) => '/ticket/reply/$ticketId';
  static String ticketFileDownload(String id) =>
      '/support/ticket/file/download/$id';
}

const List<String> ticketFileTypes = [
  'pdf',
  'doc',
  'exel',
  'jpg',
  'jpeg',
  'png',
  'jfif',
  'webp'
];
