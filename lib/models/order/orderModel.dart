import 'package:mobj_project/mappers/woocommerce/woocommerce_order_model.dart';
import 'package:mobj_project/utils/appConfiguer.dart';

import '../../mappers/bigcommerce_models/bigcommerce_ordemodel.dart';
import '../../mappers/shopify_models/shopify_ordermodel.dart';
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
  final String? firstname;
  final String? lastname;
  final String? phone;
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
    required this.currentTotalTax,
    required this.totalPrice,
    required this.customer,
    required this.lineItems,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.wooCommerce) {
      return WooCommerceOrderModel.fromJson(json);
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceOrderModel.fromJson(json);
    } else {
      return ShopifyOrderModel.fromJson(json);
    }
  }
}
