import 'package:mobj_project/utils/appConfiguer.dart';

import '../../../utils/defaultValues.dart';

class DraftOrderModel {
  final dynamic id;
  final String note;
  final String email;
  final bool taxesIncluded;
  final String currency;
  final String invoiceSentAt;
  final String createdAt;
  final String updatedAt;
  final bool taxExempt;
  final String completedAt;
  final String name;
  final String status;
  final List<LineItem> lineItems;
  final String shippingAddress;
  final String billingAddress;
  final String invoiceUrl;
  final String appliedDiscount;
  final int orderId;
  final String shippingLine;
  final List<TaxLine> taxLines;
  final String tags;
  final List<NoteAttribute> noteAttributes;
  late double totalPrice;
  final String subtotalPrice;
  final String totalTax;
  final String paymentTerms;
  final String adminGraphqlApiId;
  final CustomerModel customer;

  DraftOrderModel({
    required this.id,
    required this.note,
    required this.email,
    required this.taxesIncluded,
    required this.currency,
    required this.invoiceSentAt,
    required this.createdAt,
    required this.updatedAt,
    required this.taxExempt,
    required this.completedAt,
    required this.name,
    required this.status,
    required this.lineItems,
    required this.shippingAddress,
    required this.billingAddress,
    required this.invoiceUrl,
    required this.appliedDiscount,
    required this.orderId,
    required this.shippingLine,
    required this.taxLines,
    required this.tags,
    required this.noteAttributes,
    required this.totalPrice,
    required this.subtotalPrice,
    required this.totalTax,
    required this.paymentTerms,
    required this.adminGraphqlApiId,
    required this.customer,
  });

  factory DraftOrderModel.fromJson(Map<String, dynamic> json) {
    return DraftOrderModel(
      id: AppConfigure.bigCommerce
          ? json['id']
          : json['id'] ?? DefaultValues.defaultInt,
      note: json['note'] ?? DefaultValues.defaultString,
      email: json['email'] ?? DefaultValues.defaultString,
      taxesIncluded: json['taxes_included'] ?? false,
      currency: AppConfigure.bigCommerce
          ? json['currency']['code']
          : json['currency'] ?? DefaultValues.defaultString,
      invoiceSentAt: json['invoice_sent_at'] ?? DefaultValues.defaultString,
      createdAt: AppConfigure.bigCommerce
          ? json['created_time']
          : json['created_at'] ?? DefaultValues.defaultString,
      updatedAt: AppConfigure.bigCommerce
          ? json['updated_time']
          : json['updated_at'] ?? DefaultValues.defaultString,
      taxExempt: json['tax_exempt'] ?? false,
      completedAt: AppConfigure.bigCommerce
          ? json['updated_time']
          : json['completed_at'] ?? DefaultValues.defaultString,
      name: json['name'] ?? DefaultValues.defaultString,
      status: json['status'] ?? DefaultValues.defaultString,
      lineItems: AppConfigure.bigCommerce
          ? List<LineItem>.from(json['line_items']['physical_items']
              .map((item) => LineItem.fromJson(item)))
          : List<LineItem>.from(
              json['line_items'].map((item) => LineItem.fromJson(item))),
      shippingAddress: json['shipping_address'] ?? DefaultValues.defaultString,
      billingAddress: json['billing_address'] ?? DefaultValues.defaultString,
      invoiceUrl: json['invoice_url'] ?? DefaultValues.defaultString,
      appliedDiscount: AppConfigure.bigCommerce
          ? json['discount_amount'].toString()
          : json['applied_discount'] ?? DefaultValues.defaultString,
      orderId: json['order_id'] ?? DefaultValues.defaultInt,
      shippingLine: json['shipping_line'] ?? DefaultValues.defaultString,
      taxLines: AppConfigure.bigCommerce
          ? [TaxLine(rate: 1.00, title: "title", price: "11.0")]
          : List<TaxLine>.from(
              json['tax_lines'].map((item) => TaxLine.fromJson(item))),
      tags: json['tags'] ?? DefaultValues.defaultString,
      noteAttributes: AppConfigure.bigCommerce
          ? []
          : List<NoteAttribute>.from(json['note_attributes']
              .map((item) => NoteAttribute.fromJson(item))),
      totalPrice: AppConfigure.bigCommerce
          ? double.parse(json['cart_amount'].toString())
          : double.parse(json['total_price'].toString()) ??
              DefaultValues.defaultDouble,
      subtotalPrice: AppConfigure.bigCommerce
          ? json['cart_amount'].toString()
          : json['subtotal_price'] ?? DefaultValues.defaultString,
      totalTax: json['total_tax'] ?? DefaultValues.defaultString,
      paymentTerms: json['payment_terms'] ?? DefaultValues.defaultString,
      adminGraphqlApiId:
          json['admin_graphql_api_id'] ?? DefaultValues.defaultString,
      customer: AppConfigure.bigCommerce
          ? CustomerModel(
              id: 7,
              email: 'cyberpunk7099@gmail.com',
              acceptsMarketing: true,
              createdAt: "createdAt",
              updatedAt: "updatedAt",
              firstName: "firstName",
              lastName: "lastName",
              ordersCount: 2,
              state: "state",
              totalSpent: "totalSpent",
              lastOrderId: 123,
              note: "note",
              taxExempt: true,
              tags: "tags",
              lastOrderName: "lastOrderName",
              currency: "INR",
              phone: "7378646221",
              adminGraphqlApiId: "adminGraphqlApiId")
          : CustomerModel.fromJson(json['customer']),
    );
  }
}

class LineItem {
  final dynamic id;
  late final int variantId;
  final int productId;
  final String title;
  final String variantTitle;
  final String sku;
  final String vendor;
  late int quantity;
  final bool requiresShipping;
  final bool taxable;
  final bool giftCard;
  final String fulfillmentService;
  final int grams;
  final List<TaxLine> taxLines;
  final dynamic appliedDiscount;
  final String name;
  final List<dynamic> properties;
  final bool custom;
  final String price;
  final String adminGraphqlApiId;

  LineItem({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.title,
    required this.variantTitle,
    required this.sku,
    required this.vendor,
    required this.quantity,
    required this.requiresShipping,
    required this.taxable,
    required this.giftCard,
    required this.fulfillmentService,
    required this.grams,
    required this.taxLines,
    required this.appliedDiscount,
    required this.name,
    required this.properties,
    required this.custom,
    required this.price,
    required this.adminGraphqlApiId,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'] ?? DefaultValues.defaultInt,
      variantId: json['variant_id'] ?? DefaultValues.defaultInt,
      productId: json['product_id'] ?? DefaultValues.defaultInt,
      title: AppConfigure.bigCommerce
          ? json['name']
          : json['title'] ?? DefaultValues.defaultString,
      variantTitle: json['variant_title'] ?? DefaultValues.defaultString,
      sku: json['sku'] ?? DefaultValues.defaultString,
      vendor: json['vendor'] ?? DefaultValues.defaultString,
      quantity: json['quantity'] ?? DefaultValues.defaultInt,
      requiresShipping: AppConfigure.bigCommerce
          ? json['is_require_shipping']
          : json['requires_shipping'] ?? false,
      taxable: json['taxable'] ?? false,
      giftCard: json['gift_card'] ?? false,
      fulfillmentService:
          json['fulfillment_service'] ?? DefaultValues.defaultString,
      grams: json['grams'] ?? DefaultValues.defaultInt,
      taxLines: AppConfigure.bigCommerce
          ? [TaxLine(rate: 1.00, title: "title", price: "11.0")]
          : List<TaxLine>.from(
              json['tax_lines'].map((item) => TaxLine.fromJson(item))),
      appliedDiscount: AppConfigure.bigCommerce
          ? json['discount_amount']
          : json['applied_discount'] ?? DefaultValues.defaultString,
      name: json['name'] ?? DefaultValues.defaultString,
      properties: AppConfigure.bigCommerce
          ? []
          : List<dynamic>.from(json['properties'].map((item) => item)),
      custom: json['custom'] ?? false,
      price: AppConfigure.bigCommerce
          ? json['sale_price'].toString()
          : json['price'] ?? DefaultValues.defaultString,
      adminGraphqlApiId: AppConfigure.bigCommerce
          ? json['image_url']
          : json['admin_graphql_api_id'] ?? DefaultValues.defaultString,
    );
  }
}

class TaxLine {
  final double rate;
  final String title;
  final String price;

  TaxLine({
    required this.rate,
    required this.title,
    required this.price,
  });

  factory TaxLine.fromJson(Map<String, dynamic> json) {
    return TaxLine(
      rate: json['rate'] ?? DefaultValues.defaultDouble,
      title: json['title'] ?? DefaultValues.defaultString,
      price: json['price'] ?? DefaultValues.defaultString,
    );
  }
}

class NoteAttribute {
  final dynamic key;
  final dynamic value;

  NoteAttribute({
    required this.key,
    required this.value,
  });

  factory NoteAttribute.fromJson(Map<String, dynamic> json) {
    return NoteAttribute(
      key: json['key'] ?? DefaultValues.defaultString,
      value: json['value'] ?? DefaultValues.defaultString,
    );
  }
}

class CustomerModel {
  final int id;
  final String email;
  final bool acceptsMarketing;
  final String createdAt;
  final String updatedAt;
  final String firstName;
  final String lastName;
  final int ordersCount;
  final String state;
  final String totalSpent;
  final int lastOrderId;
  final dynamic note;
  final bool taxExempt;
  final String tags;
  final String lastOrderName;
  final String currency;
  final String phone;
  final String adminGraphqlApiId;

  CustomerModel({
    required this.id,
    required this.email,
    required this.acceptsMarketing,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.ordersCount,
    required this.state,
    required this.totalSpent,
    required this.lastOrderId,
    required this.note,
    required this.taxExempt,
    required this.tags,
    required this.lastOrderName,
    required this.currency,
    required this.phone,
    required this.adminGraphqlApiId,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      email: json['email'] ?? DefaultValues.defaultString,
      acceptsMarketing: json['accepts_marketing'] ?? false,
      createdAt: json['created_at'] ?? DefaultValues.defaultString,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultString,
      firstName: json['first_name'] ?? DefaultValues.defaultString,
      lastName: json['last_name'] ?? DefaultValues.defaultString,
      ordersCount: json['orders_count'] ?? DefaultValues.defaultInt,
      state: json['state'] ?? DefaultValues.defaultString,
      totalSpent: json['total_spent'] ?? DefaultValues.defaultString,
      lastOrderId: json['last_order_id'] ?? DefaultValues.defaultInt,
      note: json['note'] ?? DefaultValues.defaultString,
      taxExempt: json['tax_exempt'] ?? false,
      tags: json['tags'] ?? DefaultValues.defaultString,
      lastOrderName: json['last_order_name'] ?? DefaultValues.defaultString,
      currency: json['currency'] ?? DefaultValues.defaultString,
      phone: json['phone'] ?? DefaultValues.defaultString,
      adminGraphqlApiId:
          json['admin_graphql_api_id'] ?? DefaultValues.defaultString,
    );
  }
}

class EmailMarketingConsent {
  final String state;
  final String optInLevel;
  final dynamic consentUpdatedAt;

  EmailMarketingConsent({
    required this.state,
    required this.optInLevel,
    required this.consentUpdatedAt,
  });

  factory EmailMarketingConsent.fromJson(Map<String, dynamic> json) {
    return EmailMarketingConsent(
      state: json['state'] ?? DefaultValues.defaultString,
      optInLevel: json['opt_in_level'] ?? DefaultValues.defaultString,
      consentUpdatedAt:
          json['consent_updated_at'] ?? DefaultValues.defaultString,
    );
  }
}

class SmsMarketingConsent {
  final String state;
  final String optInLevel;
  final dynamic consentUpdatedAt;
  final String consentCollectedFrom;

  SmsMarketingConsent({
    required this.state,
    required this.optInLevel,
    required this.consentUpdatedAt,
    required this.consentCollectedFrom,
  });

  factory SmsMarketingConsent.fromJson(Map<String, dynamic> json) {
    return SmsMarketingConsent(
      state: json['state'] ?? DefaultValues.defaultString,
      optInLevel: json['opt_in_level'] ?? DefaultValues.defaultString,
      consentUpdatedAt:
          json['consent_updated_at'] ?? DefaultValues.defaultString,
      consentCollectedFrom:
          json['consent_collected_from'] ?? DefaultValues.defaultString,
    );
  }
}

class DefaultAddressModel {
  final int id;
  final int customerId;
  final String firstName;
  final String lastName;
  final String address1;
  late String city;
  final String province;
  final String country;
  final String zip;
  final String phone;
  final String name;
  final String provinceCode;
  final String countryCode;
  final String countryName;
  late bool defaultAddress;

  DefaultAddressModel({
    required this.id,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.province,
    required this.country,
    required this.zip,
    required this.phone,
    required this.name,
    required this.provinceCode,
    required this.countryCode,
    required this.countryName,
    required this.defaultAddress,
  });

  factory DefaultAddressModel.fromJson(Map<String, dynamic> json) {
    return DefaultAddressModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      customerId: json['customer_id'] ?? DefaultValues.defaultInt,
      firstName: json['first_name'] ?? DefaultValues.defaultString,
      lastName: json['last_name'] ?? DefaultValues.defaultString,
      address1: json['address1'] ?? DefaultValues.defaultString,
      city: json['city'] ?? DefaultValues.defaultString,
      province: AppConfigure.bigCommerce
          ? json['state_or_province'] ?? DefaultValues.defaultString
          : json['province'] ?? DefaultValues.defaultString,
      country: json['country'] ?? DefaultValues.defaultString,
      zip: AppConfigure.bigCommerce
          ? json['postal_code'] ?? DefaultValues.defaultString
          : json['zip'] ?? DefaultValues.defaultString,
      phone: json['phone'] ?? DefaultValues.defaultString,
      name: json['name'] ?? DefaultValues.defaultString,
      provinceCode: json['province_code'] ?? DefaultValues.defaultString,
      countryCode: json['country_code'] ?? DefaultValues.defaultString,
      countryName: AppConfigure.bigCommerce
          ? json['country'] ?? DefaultValues.defaultString
          : json['country_name'] ?? DefaultValues.defaultString,
      defaultAddress: json['default'] ?? false,
    );
  }
}
