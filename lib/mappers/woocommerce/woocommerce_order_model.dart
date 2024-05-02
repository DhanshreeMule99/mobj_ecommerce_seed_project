import 'package:mobj_project/models/product/draftOrderModel.dart';

import '../../models/order/orderModel.dart';
import '../../utils/defaultValues.dart';

class WooCommerceOrderModel implements OrderModel {
  @override
  final int id;
  @override
  final String adminGraphqlApiId;
  @override
  final int appId;
  @override
  final String browserIp;
  @override
  final bool buyerAcceptsMarketing;
  @override
  final String? cancelReason;
  @override
  final String? cancelledAt;
  @override
  final String? cartToken;
  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? phone;
  @override
  final int checkoutId;
  @override
  final String checkoutToken;
  @override
  final bool confirmed;
  @override
  final String contactEmail;
  @override
  final String createdAt;
  @override
  final String currency;
  @override
  final String currentSubtotalPrice;
  @override
  final String totalPrice;
  @override
  final String currentTotalTax;

  WooCommerceOrderModel({
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
    required this.currentTotalTax,
    required this.totalPrice,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  factory WooCommerceOrderModel.fromJson(Map<String, dynamic> json) {
    return WooCommerceOrderModel(
      firstname: json['first_name'] ?? DefaultValues.stringDefault,
      lastname: json['last_name'] ?? DefaultValues.stringDefault,
      phone: json[0] ?? DefaultValues.stringDefault,
      id: json['id'] ?? DefaultValues.intDefault,
      adminGraphqlApiId: DefaultValues.stringDefault,
      appId: json['customer_id'] ?? DefaultValues.intDefault,
      browserIp: DefaultValues.stringDefault,
      buyerAcceptsMarketing: DefaultValues.boolDefault,
      cancelReason: json[''],
      cancelledAt: json[''],
      cartToken: json['number'],
      checkoutId: DefaultValues.intDefault,
      checkoutToken: json['number'] ?? DefaultValues.stringDefault,
      confirmed: DefaultValues.boolDefault,
      contactEmail: json['billing']['email'] ?? DefaultValues.stringDefault,
      createdAt: json['date_created_gmt'] ?? DefaultValues.stringDefault,
      currency: json['currency_symbol'] ?? DefaultValues.stringDefault,
      currentSubtotalPrice: json['total'] ?? DefaultValues.stringDefault,
      totalPrice: json['total'] ?? DefaultValues.stringDefault,
      currentTotalTax: json['total_tax'] ??
          DefaultValues.stringDefault, // Ensure it's a List<LineItem>
    );
  }

  @override
  // TODO: implement customer
  CustomerModel get customer => throw UnimplementedError();

  @override
  // TODO: implement lineItems
  List<LineItem> get lineItems => throw UnimplementedError();
}
