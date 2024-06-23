import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

//* all supported language. When adding new language file add a local here
//! this should always valid `ISO 639 language codes`
class SupportedLanguage {
  static List<String> languages = locales.map((e) => e.languageCode).toList();
  static List<Locale> locales = [
    const Locale('en'),
    const Locale('bn'),
  ];
}

/// keys from the localized json
class Translator {
  static String home(BuildContext context) =>
      const LocaleKey('home').translate(context);

  static String profile(BuildContext context) =>
      const LocaleKey('profile').translate(context);

  static String shippingCharge(BuildContext context) =>
      const LocaleKey('shipping_charge').translate(context);

  static String subTotal(BuildContext context) =>
      const LocaleKey('sub_total').translate(context);

  static String total(BuildContext context) =>
      const LocaleKey('total').translate(context);

  static String discount(BuildContext context) =>
      const LocaleKey('discount').translate(context);

  static String shopping(BuildContext context) =>
      const LocaleKey('shopping').translate(context);

  static String wishlist(BuildContext context) =>
      const LocaleKey('wishlist').translate(context);

  static String all(BuildContext context) =>
      const LocaleKey('all').translate(context);

  static String allOrder(BuildContext context) =>
      const LocaleKey('all-order').translate(context);

  static String shippedOrder(BuildContext context) =>
      const LocaleKey('shipped-order').translate(context);

  static String followedStores(BuildContext context) =>
      const LocaleKey('followed-store').translate(context);

  static String toReview(BuildContext context) =>
      const LocaleKey('to-review').translate(context);

  static String category(BuildContext context) =>
      const LocaleKey('category').translate(context);

  static String suggestProduct(BuildContext context) =>
      const LocaleKey('suggest_product').translate(context);

  static String store(BuildContext context) =>
      const LocaleKey('store').translate(context);

  static String allProduct(BuildContext context) =>
      const LocaleKey('all-product').translate(context);

  static String flashProduct(BuildContext context) =>
      const LocaleKey('flash-product').translate(context);

  static String dealDay(BuildContext context) =>
      const LocaleKey('deal_of_the_day').translate(context);

  static String campaign(BuildContext context) =>
      const LocaleKey('campaign').translate(context);

  static String featured(BuildContext context) =>
      const LocaleKey('featured_products').translate(context);

  static String newArrivals(BuildContext context) =>
      const LocaleKey('new_arrivals').translate(context);

  static String digitals(BuildContext context) =>
      const LocaleKey('digital_products').translate(context);

  static String brands(BuildContext context) =>
      const LocaleKey('brands').translate(context);

  static String visitStore(BuildContext context) =>
      const LocaleKey('visit_store').translate(context);

  static String follow(BuildContext context) =>
      const LocaleKey('follow').translate(context);

  static String unfollow(BuildContext context) =>
      const LocaleKey('unfollow').translate(context);

  static String followers(BuildContext context) =>
      const LocaleKey('followers').translate(context);

  static String writeReview(BuildContext context) =>
      const LocaleKey('write_a_review').translate(context);

  static String thereNoReview(BuildContext context) =>
      const LocaleKey('there_no_review').translate(context);

  static String submit(BuildContext context) =>
      const LocaleKey('submit').translate(context);

  static String trackOrder(BuildContext context) =>
      const LocaleKey('track_order').translate(context);

  static String myOrder(BuildContext context) =>
      const LocaleKey('my_order').translate(context);

  static String welcome(BuildContext context) =>
      const LocaleKey('Welcome').translate(context);

  static String help(BuildContext context) =>
      const LocaleKey('help').translate(context);

  static String settings(BuildContext context) =>
      const LocaleKey('settings').translate(context);

  static String logout(BuildContext context) =>
      const LocaleKey('logout').translate(context);

  static String hello(BuildContext context) =>
      const LocaleKey('hello').translate(context);

  static String orderDetails(BuildContext context) =>
      const LocaleKey('order_details').translate(context);

  static String nothingToShow(BuildContext context) =>
      const LocaleKey('nothing_to_show').translate(context);

  static String region(BuildContext context) =>
      const LocaleKey('region').translate(context);

  static String shoppingCart(BuildContext context) =>
      const LocaleKey('shopping_cart').translate(context);

  static String submitOrder(BuildContext context) =>
      const LocaleKey('submit_order').translate(context);

  static String subtotal(BuildContext context) =>
      const LocaleKey('subtotal').translate(context);

  static String productDetails(BuildContext context) =>
      const LocaleKey('product_details').translate(context);

  static String description(BuildContext context) =>
      const LocaleKey('description').translate(context);

  static String shortDescription(BuildContext context) =>
      const LocaleKey('short_description').translate(context);

  static String review(BuildContext context) =>
      const LocaleKey('review').translate(context);

  static String shoppingMethod(BuildContext context) =>
      const LocaleKey('shipping_method').translate(context);

  static String tapTo(BuildContext context) =>
      const LocaleKey('tap_to').translate(context);

  static String seeDetails(BuildContext context) =>
      const LocaleKey('see_details').translate(context);

  static String relatedProduct(BuildContext context) =>
      const LocaleKey('related_product').translate(context);

  static String addToCart(BuildContext context) =>
      const LocaleKey('add_to_cart').translate(context);

  static String orderPlaceSuccessfully(BuildContext context) =>
      const LocaleKey('order_place_successfully').translate(context);

  static String orderHistory(BuildContext context) =>
      const LocaleKey('order_history').translate(context);

  static String continueShopping(BuildContext context) =>
      const LocaleKey('continue_shopping').translate(context);

  static String haveQuestion(BuildContext context) =>
      const LocaleKey('have_question').translate(context);

  static String customerSupport(BuildContext context) =>
      const LocaleKey('customer_support').translate(context);

  static String orderConfirm(BuildContext context) =>
      const LocaleKey('order_confirm').translate(context);

  static String paymentFailed(BuildContext context) =>
      const LocaleKey('payment_failed').translate(context);

  static String paymentSuccess(BuildContext context) =>
      const LocaleKey('payment_success').translate(context);

  static String paymentFailedMassage(BuildContext context) =>
      const LocaleKey('payment_failed_massage').translate(context);

  static String paymentSuccessMassage(BuildContext context) =>
      const LocaleKey('payment_success_massage').translate(context);

  static String returnHHome(BuildContext context) =>
      const LocaleKey('return_home').translate(context);

  static String cart(BuildContext context) =>
      const LocaleKey('cart').translate(context);

  static String selectShippingMethod(BuildContext context) =>
      const LocaleKey('Select_shipping_method').translate(context);

  static String noShippingInfo(BuildContext context) =>
      const LocaleKey('No_Shipping_information_to_Show').translate(context);

  static String standardDelivery(BuildContext context) =>
      const LocaleKey('standard_delivery').translate(context);

  static String somethingWentWrong(BuildContext context) =>
      const LocaleKey('something_went_wrong').translate(context);

  static String checkout(BuildContext context) =>
      const LocaleKey('checkout').translate(context);

  static String shippingDetails(BuildContext context) =>
      const LocaleKey('shipping_details').translate(context);

  static String nextPay(BuildContext context) =>
      const LocaleKey('next_pay').translate(context);

  static String fullName(BuildContext context) =>
      const LocaleKey('full_name').translate(context);

  static String phone(BuildContext context) =>
      const LocaleKey('phone').translate(context);

  static String email(BuildContext context) =>
      const LocaleKey('email').translate(context);

  static String address(BuildContext context) =>
      const LocaleKey('address').translate(context);

  static String stateName(BuildContext context) =>
      const LocaleKey('state_name').translate(context);

  static String cityName(BuildContext context) =>
      const LocaleKey('city_name').translate(context);

  static String zipCode(BuildContext context) =>
      const LocaleKey('zip_code').translate(context);

  static String editProfile(BuildContext context) =>
      const LocaleKey('edit_profile').translate(context);

  static String shippingAddress(BuildContext context) =>
      const LocaleKey('shipping_address').translate(context);

  static String couponCode(BuildContext context) =>
      const LocaleKey('coupon_code').translate(context);

  static String yourCoupon(BuildContext context) =>
      const LocaleKey('your_coupon').translate(context);

  static String apply(BuildContext context) =>
      const LocaleKey('apply').translate(context);

  static String selectPaymentMethod(BuildContext context) =>
      const LocaleKey('select_payment_method').translate(context);

  static String orderSuccessful(BuildContext context) =>
      const LocaleKey('order_successful').translate(context);

  static String yourOderPWSuccessful(BuildContext context) =>
      const LocaleKey('your_order_placement_was_successful').translate(context);

  static String payNow(BuildContext context) =>
      const LocaleKey('pay_now').translate(context);

  static String orderPage(BuildContext context) =>
      const LocaleKey('order_page').translate(context);

  static String backToHome(BuildContext context) =>
      const LocaleKey('Back_to_home').translate(context);

  static String loginToContinue(BuildContext context) =>
      const LocaleKey('login_to_continue').translate(context);

  static String notAuthorized(BuildContext context) =>
      const LocaleKey('not_authorized').translate(context);

  static String trackingInfo(BuildContext context) =>
      const LocaleKey('tracking_info').translate(context);

  static String trackingId(BuildContext context) =>
      const LocaleKey('tracking_id').translate(context);

  static String trackNow(BuildContext context) =>
      const LocaleKey('track_now').translate(context);

  static String orderTimeline(BuildContext context) =>
      const LocaleKey('order_timeline').translate(context);

  static String orderInfo(BuildContext context) =>
      const LocaleKey('order_info').translate(context);

  static String orderId(BuildContext context) =>
      const LocaleKey('order_id').translate(context);

  static String orderPlacement(BuildContext context) =>
      const LocaleKey('order_placement').translate(context);

  static String shippingBy(BuildContext context) =>
      const LocaleKey('shipping_by').translate(context);

  static String status(BuildContext context) =>
      const LocaleKey('status').translate(context);

  static String billingInfo(BuildContext context) =>
      const LocaleKey('billing_info').translate(context);

  static String paymentInfo(BuildContext context) =>
      const LocaleKey('payment_info').translate(context);

  static String transactions(BuildContext context) =>
      const LocaleKey('transactions').translate(context);

  static String paymentMethod(BuildContext context) =>
      const LocaleKey('payment_method').translate(context);

  static String paymentStatus(BuildContext context) =>
      const LocaleKey('payment_status').translate(context);

  static String totalAmount(BuildContext context) =>
      const LocaleKey('total_amount').translate(context);

  static String amount(BuildContext context) =>
      const LocaleKey('amount').translate(context);

  static String readyForPayment(BuildContext context) =>
      const LocaleKey('ready_for_payment').translate(context);

  static String yourOrderReadyPayment(BuildContext context) =>
      const LocaleKey('your_order_ready_for_payment').translate(context);

  static String charge(BuildContext context) =>
      const LocaleKey('charge').translate(context);

  static String payable(BuildContext context) =>
      const LocaleKey('payable').translate(context);

  static String searchForProduct(BuildContext context) =>
      const LocaleKey('search_for_product').translate(context);

  static String update(BuildContext context) =>
      const LocaleKey('update').translate(context);

  static String languageCurrency(BuildContext context) =>
      const LocaleKey('language_and_currency').translate(context);

  static String searchCategories(BuildContext context) =>
      const LocaleKey('search_categories').translate(context);

  static String searchBrands(BuildContext context) =>
      const LocaleKey('search_brands').translate(context);

  static String select(BuildContext context) =>
      const LocaleKey('select').translate(context);

  static String language(BuildContext context) =>
      const LocaleKey('language').translate(context);

  static String currency(BuildContext context) =>
      const LocaleKey('currency').translate(context);

  static String login(BuildContext context) =>
      const LocaleKey('login').translate(context);

  static String loginToAccount(BuildContext context) =>
      const LocaleKey('login_to_account').translate(context);

  static String donotHaveAccount(BuildContext context) =>
      const LocaleKey('donot_have_account').translate(context);

  static String registerNow(BuildContext context) =>
      const LocaleKey('register_now').translate(context);

  static String password(BuildContext context) =>
      const LocaleKey('password').translate(context);

  static String registration(BuildContext context) =>
      const LocaleKey('registration').translate(context);

  static String alreadyHaveAccount(BuildContext context) =>
      const LocaleKey('already_have_account').translate(context);

  static String loginNow(BuildContext context) =>
      const LocaleKey('login_now').translate(context);

  static String enterName(BuildContext context) =>
      const LocaleKey('enter_name').translate(context);

  static String confirmPassword(BuildContext context) =>
      const LocaleKey('confirm_password').translate(context);

  static String completePayment(BuildContext context) =>
      const LocaleKey('complete_payment').translate(context);

  static String digitalOrder(BuildContext context) =>
      const LocaleKey('digital_order').translate(context);

  static String orders(BuildContext context) =>
      const LocaleKey('orders').translate(context);

  static String buyNow(BuildContext context) =>
      const LocaleKey('buy_now').translate(context);

  static String chooseAttributes(BuildContext context) =>
      const LocaleKey('choose_attributes').translate(context);

  static String attributes(BuildContext context) =>
      const LocaleKey('attributes').translate(context);

  static String products(BuildContext context) =>
      const LocaleKey('products').translate(context);

  static String selectItemDigital(BuildContext context) =>
      const LocaleKey('select_item_digital').translate(context);

  static String cantBeEmpty(BuildContext context) =>
      const LocaleKey('cant_be_empty').translate(context);

  static String enterValidName(BuildContext context) =>
      const LocaleKey('enter_valid_Name').translate(context);

  static String enterValidEmail(BuildContext context) =>
      const LocaleKey('enter_valid_email').translate(context);

  static String filters(BuildContext context) =>
      const LocaleKey('filters').translate(context);

  static String flashDeals(BuildContext context) =>
      const LocaleKey('flash_deals').translate(context);

  static String flashSub(BuildContext context) =>
      const LocaleKey('flash_sub').translate(context);

  static String sortWithPrice(BuildContext context) =>
      const LocaleKey("sort_with_price").translate(context);

  static String min(BuildContext context) =>
      const LocaleKey("min").translate(context);

  static String max(BuildContext context) =>
      const LocaleKey("max").translate(context);

  static String sortOrder(BuildContext context) =>
      const LocaleKey("sort_order").translate(context);

  static String lowToHigh(BuildContext context) =>
      const LocaleKey("low_to_high").translate(context);

  static String highToLow(BuildContext context) =>
      const LocaleKey("high_to_low").translate(context);

  static String reset(BuildContext context) =>
      const LocaleKey("reset").translate(context);

  static String stockOut(BuildContext context) =>
      const LocaleKey("stock_out").translate(context);

  static String inStock(BuildContext context) =>
      const LocaleKey("in_stock").translate(context);

  static String stockInfo(BuildContext context, bool condition) =>
      condition ? inStock(context) : stockOut(context);

  static String support(BuildContext context) =>
      const LocaleKey("support").translate(context);

  static String helpline(BuildContext context) =>
      const LocaleKey("helpline").translate(context);

  static String helplineSubtitle(BuildContext context) =>
      const LocaleKey("helpline_subtitle").translate(context);

  static String location(BuildContext context) =>
      const LocaleKey("location").translate(context);

  static String getInTouch(BuildContext context) =>
      const LocaleKey("get_in_touch").translate(context);

  static String noProductFound(BuildContext context) =>
      const LocaleKey("no_item_found").translate(context);

  static String enterCoupon(BuildContext context) =>
      const LocaleKey("enter_coupon").translate(context);

  static String supportTicket(BuildContext context) =>
      const LocaleKey("support_ticket").translate(context);

  static String contact(BuildContext context) =>
      const LocaleKey("contact").translate(context);

  static String createTicket(BuildContext context) =>
      const LocaleKey("create_ticket").translate(context);

  static String loginSubtitle(BuildContext context) =>
      const LocaleKey("login_subtitle").translate(context);

  static String createAccount(BuildContext context) =>
      const LocaleKey("create_account").translate(context);

  static String regSubtitle(BuildContext context) =>
      const LocaleKey("reg_subtitle").translate(context);

  static String closeTicket(BuildContext context) =>
      const LocaleKey("close_ticket").translate(context);

  static String areYouSure(BuildContext context) =>
      const LocaleKey("are_you_sure").translate(context);

  static String yes(BuildContext context) =>
      const LocaleKey("yes").translate(context);

  static String no(BuildContext context) =>
      const LocaleKey("no").translate(context);

  static String typeAMessage(BuildContext context) =>
      const LocaleKey("type_a_message").translate(context);

  static String ticketIsClosed(BuildContext context) =>
      const LocaleKey("ticket_is_closed").translate(context);

  static String files(BuildContext context) =>
      const LocaleKey("files").translate(context);

  static String message(BuildContext context) =>
      const LocaleKey("message").translate(context);

  static String subject(BuildContext context) =>
      const LocaleKey("subject").translate(context);

  static String shipNBill(BuildContext context) =>
      const LocaleKey("ship_n_bill").translate(context);

  static String package(BuildContext context) =>
      const LocaleKey("package").translate(context);

  static String invalidId(BuildContext context) =>
      const LocaleKey("invalid_id").translate(context);

  static String fieldRequired(BuildContext context) =>
      const LocaleKey("field_required").translate(context);

  static String invalidPhone(BuildContext context) =>
      const LocaleKey("invalid_phone").translate(context);

  static String invalidEmail(BuildContext context) =>
      const LocaleKey("invalid_email").translate(context);

  static String change(BuildContext context) =>
      const LocaleKey("change").translate(context);

  static String checkInternet(BuildContext context) =>
      const LocaleKey("check_internet").translate(context);

  static String backOnline(BuildContext context) =>
      const LocaleKey("back_online").translate(context);

  static String maintenance(BuildContext context) =>
      const LocaleKey("maintenance").translate(context);

  static String inconvenience(BuildContext context) =>
      const LocaleKey("inconvenience").translate(context);

  static String notInstalled(BuildContext context) =>
      const LocaleKey("not_installed").translate(context);

  static String contactProvider(BuildContext context) =>
      const LocaleKey("contact_provider").translate(context);

  static String previous(BuildContext context) =>
      const LocaleKey("previous").translate(context);

  static String next(BuildContext context) =>
      const LocaleKey("next").translate(context);

  static String morning(BuildContext context) =>
      const LocaleKey("morning").translate(context);

  static String noon(BuildContext context) =>
      const LocaleKey("noon").translate(context);

  static String evening(BuildContext context) =>
      const LocaleKey("evening").translate(context);

  static String night(BuildContext context) =>
      const LocaleKey("night").translate(context);

  static String helloGuest(BuildContext context) =>
      const LocaleKey("hello_guest").translate(context);

  static String guest(BuildContext context) =>
      const LocaleKey("guest").translate(context);

  static String summery(BuildContext context) =>
      const LocaleKey("summary").translate(context);

//
  static String selectBilling(BuildContext context) =>
      const LocaleKey("select_billing").translate(context);

  static String registerWithEmail(BuildContext context) =>
      const LocaleKey("register_with_email").translate(context);

  static String submitWithoutAccountWarn(BuildContext context) =>
      const LocaleKey("submit_without_account_warn").translate(context);

  static String notLoggedInOrderWarn(BuildContext context) =>
      const LocaleKey("not_logged_in_order_warn").translate(context);

  static String chooseAddress(BuildContext context) =>
      const LocaleKey("choose_address").translate(context);

  static String updatePassword(BuildContext context) =>
      const LocaleKey("update_password").translate(context);

  static String skip(BuildContext context) =>
      const LocaleKey("skip").translate(context);

  static String basicInfo(BuildContext context) =>
      const LocaleKey("basic_info").translate(context);

  static String firstName(BuildContext context) =>
      const LocaleKey("first_name").translate(context);

  static String lastName(BuildContext context) =>
      const LocaleKey("last_name").translate(context);

  static String addAddress(BuildContext context) =>
      const LocaleKey("add_address").translate(context);

  static String estimated(BuildContext context) =>
      const LocaleKey("estimate_time").translate(context);

  static String success(BuildContext context) =>
      const LocaleKey("success").translate(context);

  static String updated(BuildContext context) =>
      const LocaleKey("updated").translate(context);

  static String addressDeleted(BuildContext context) =>
      const LocaleKey("deleted").translate(context);

  static String createBilling(BuildContext context) =>
      const LocaleKey("create_billing").translate(context);

  static String addressName(BuildContext context) =>
      const LocaleKey("address_name").translate(context);

  static String applyAtCheckout(BuildContext context) =>
      const LocaleKey("apply_at_checkout").translate(context);

  static String enterTrackingId(BuildContext context) =>
      const LocaleKey("enter_tracking_id").translate(context);

  static String totalOrders(BuildContext context) =>
      const LocaleKey("total_orders").translate(context);

  static String exitPayment(BuildContext context) =>
      const LocaleKey("exit_payment").translate(context);

  static String appreciateRating(BuildContext context) =>
      const LocaleKey("appreciate_rating").translate(context);

  static String noThanks(BuildContext context) =>
      const LocaleKey("no_thanks").translate(context);

  static String canBeEmpty(BuildContext context) =>
      const LocaleKey("can_be_empty").translate(context);

  static String currentPass(BuildContext context) =>
      const LocaleKey("current_pass").translate(context);

  static String newPass(BuildContext context) =>
      const LocaleKey("new_pass").translate(context);

  static String passNotMatch(BuildContext context) =>
      const LocaleKey("pass_not_match").translate(context);

  static String hey(BuildContext context) =>
      const LocaleKey("hey").translate(context);

  static String sureToExit(BuildContext context) =>
      const LocaleKey("sure_to_exit").translate(context);

  static String exit(BuildContext context) =>
      const LocaleKey("exit").translate(context);

  static String retry(BuildContext context) =>
      const LocaleKey("retry").translate(context);

  static String fullDetails(BuildContext context) =>
      const LocaleKey("full_details").translate(context);

  static String noAttribute(BuildContext context) =>
      const LocaleKey("no_attribute").translate(context);

  static String iAccept(BuildContext context) =>
      const LocaleKey("i_accept").translate(context);
  static String tnc(BuildContext context) =>
      const LocaleKey("tnc").translate(context);

  static String verifyOTP(BuildContext context) =>
      const LocaleKey('verify_otp').translate(context);

  static String otp(BuildContext context) =>
      const LocaleKey('otp').translate(context);

  static String forgetPass(BuildContext context) =>
      const LocaleKey('forgetPass').translate(context);

  static String resetPass(BuildContext context) =>
      const LocaleKey('resetPass').translate(context);

  static String sendOTP(BuildContext context) =>
      const LocaleKey('sendOTP').translate(context);

  static String cancel(BuildContext context) =>
      const LocaleKey('cancel').translate(context);

  static String sendToEmailText(BuildContext context) =>
      const LocaleKey('sendToEmailText').translate(context);

  static String confirmCancel(BuildContext context) =>
      const LocaleKey('confirmCancel').translate(context);

  static String userAddress(BuildContext context) =>
      const LocaleKey('userAddress').translate(context);
}

/// stores the key
class LocaleKey {
  const LocaleKey(this.key);

  final String key;

  String translate(BuildContext context) =>
      AppLocalization.of(context)!.translate(key);
}
