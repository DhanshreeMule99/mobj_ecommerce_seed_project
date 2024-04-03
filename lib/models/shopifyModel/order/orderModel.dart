import '../../../utils/defaultValues.dart';
import '../product/draftOrderModel.dart';

class OrderModel {
  final int id;
  final String adminGraphqlApiId;
  final int appId;
  final String browserIp;
  final bool buyerAcceptsMarketing;
  final String? cancelReason;
  final String? cancelledAt;
  final String? cartToken;
  final int checkoutId;
  final String checkoutToken;
  final bool confirmed;
  final String contactEmail;
  final String createdAt;
  final String currency;
  final String currentSubtotalPrice;
  final String totalPrice;
  final String currentTotalTax;

  // Add other attributes as needed

  final CustomerModel customer;
  final List<LineItem> lineItems;

  OrderModel({
    required this.id,
    required this.adminGraphqlApiId,
    required this.appId,
    required this.browserIp,
    required this.buyerAcceptsMarketing,
    required this.cancelReason,
    required this.cancelledAt,
    required this.cartToken,
    required this.checkoutId,
    required this.checkoutToken,
    required this.confirmed,
    required this.contactEmail,
    required this.createdAt,
    required this.currency,
    required this.currentSubtotalPrice,
    required this.currentTotalTax, required this.totalPrice,
    required this.customer,
    required this.lineItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? DefaultValues.intDefault,
      adminGraphqlApiId:
      json['admin_graphql_api_id'] ?? DefaultValues.stringDefault,
      appId: json['app_id'] ?? DefaultValues.intDefault,
      browserIp: json['browser_ip'] ?? DefaultValues.stringDefault,
      buyerAcceptsMarketing:
      json['buyer_accepts_marketing'] ?? DefaultValues.boolDefault,
      cancelReason: json['cancel_reason'],
      cancelledAt: json['cancelled_at'],
      cartToken: json['cart_token'],
      checkoutId: json['checkout_id'] ?? DefaultValues.intDefault,
      checkoutToken: json['checkout_token'] ?? DefaultValues.stringDefault,
      confirmed: json['confirmed'] ?? DefaultValues.boolDefault,
      contactEmail: json['contact_email'] ?? DefaultValues.stringDefault,
      createdAt: json['created_at'] ?? DefaultValues.stringDefault,
      currency: json['currency'] ?? DefaultValues.stringDefault,
      currentSubtotalPrice:
      json['current_subtotal_price'] ?? DefaultValues.stringDefault,
      // Add other attributes as needed

      customer: CustomerModel.fromJson(json['customer'] ?? {}),
      lineItems: (json['line_items'] as List<dynamic>?)
          ?.map((item) => LineItem.fromJson(item))
          .toList() ??
          [],
      totalPrice: json['current_total_price'] ??"",
      currentTotalTax: json['current_total_tax'] ??
          DefaultValues.stringDefault, // Ensure it's a List<LineItem>
    );
  }
}
