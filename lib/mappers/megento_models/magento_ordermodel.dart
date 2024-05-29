import 'package:mobj_project/mappers/megento_models/megento_draftmodel.dart';

import '../../models/order/orderModel.dart';
import '../../utils/defaultValues.dart';

class MagentoCommerceOrderModel implements OrderModel {
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
  final double currentSubtotalPrice;
  @override
  final double totalPrice;
  @override
  final double currentTotalTax;

  // Add other attributes as needed

  @override
  final MagentoCustomerModel customer;
  @override
  final List<MagentoCommerceLineItem> lineItems;

  MagentoCommerceOrderModel({
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
    required this.customer,
    required this.lineItems,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  factory MagentoCommerceOrderModel.fromJson(Map<String, dynamic> json) {
    return MagentoCommerceOrderModel(
      firstname:
          json['items'][0]['customer_firstname'] ?? DefaultValues.stringDefault,
      lastname:
          json['items'][0]['customer_lastname'] ?? DefaultValues.stringDefault,
      phone: json['items'][0]['increment_id'] ?? DefaultValues.stringDefault,
      id: json['items'][0]['customer_id'] ?? DefaultValues.intDefault,
      adminGraphqlApiId:
          json['items'][0]['billing_address_id'] ?? DefaultValues.stringDefault,
      appId: json['items'][0]['billing_address_id'] ?? DefaultValues.intDefault,
      browserIp:
          json['items'][0]['protect_code'] ?? DefaultValues.stringDefault,
      buyerAcceptsMarketing: json[''] ?? DefaultValues.boolDefault,
      cancelReason: json['items'][0]['shipping_description'],
      cancelledAt: json['items'][0]['updated_at'],
      cartToken: json['items'][0]['shipping_description'],
      checkoutId: json['items'][0]['quote_id'] ?? DefaultValues.intDefault,
      checkoutToken: json['items'][0]['shipping_description'] ??
          DefaultValues.stringDefault,
      confirmed: json[''] ?? DefaultValues.boolDefault,
      contactEmail:
          json['items'][0]['customer_email'] ?? DefaultValues.stringDefault,
      // contactEmail: json['contact_email'] ?? DefaultValues.stringDefault,
      createdAt: json['items'][0]['created_at'] ?? DefaultValues.stringDefault,
      // createdAt: json['date_created'] ?? DefaultValues.stringDefault,
      currency: json['items'][0]['global_currency_code'] ??
          DefaultValues.stringDefault,
      currentSubtotalPrice:
          json['items'][0]['base_total_due'] ?? DefaultValues.doubleDefault,
      // Add other attributes as needed

      customer: MagentoCustomerModel.fromJson(
          json['items'][0]['billing_address'] ?? {}),
      lineItems: (json['items'][0]['items'] as List<dynamic>?)
              ?.map((item) => MagentoCommerceLineItem.fromJson(item))
              .toList() ??
          [],
      // totalPrice: json['current_total_price'] ??"",
      totalPrice:
          json['items'][0]['base_subtotal'] ?? DefaultValues.doubleDefault,
      // totalPrice: json['current_total_price'] ?? DefaultValues.stringDefault,
      currentTotalTax: json['items'][0]['base_tax_amount'] ??
          DefaultValues.doubleDefault, // Ensure it's a List<LineItem>
    );
  }
}
