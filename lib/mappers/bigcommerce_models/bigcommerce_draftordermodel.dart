import 'package:mobj_project/utils/appConfiguer.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../utils/defaultValues.dart';

class BigCommerceDraftOrderModel implements DraftOrderModel {
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
  final List<BigCommerceLineItem> lineItems;
  final String shippingAddress;
  final String billingAddress;
  final String invoiceUrl;
  final String appliedDiscount;
  final int orderId;
  final String shippingLine;
  final List<BigCommerceTaxLine> taxLines;
  final String tags;
  final List<BigCommerceNoteAttribute> noteAttributes;
  late double totalPrice;
  final String subtotalPrice;
  final String totalTax;
  final String paymentTerms;
  final String adminGraphqlApiId;
  final BigCommerceCustomerModel customer;

  BigCommerceDraftOrderModel({
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

  factory BigCommerceDraftOrderModel.fromJson(Map<String, dynamic> json) {
    return BigCommerceDraftOrderModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      note: json['note'] ?? DefaultValues.defaultString,
      email: json['email'] ?? DefaultValues.defaultString,
      taxesIncluded: json['taxes_included'] ?? false,
      currency: json['currency']['code'] ?? DefaultValues.defaultString,
      invoiceSentAt: json['invoice_sent_at'] ?? DefaultValues.defaultString,
      createdAt: json['created_time'] ?? DefaultValues.defaultString,
      updatedAt: json['updated_time'] ?? DefaultValues.defaultString,
      taxExempt: json['tax_exempt'] ?? false,
      completedAt: json['updated_time'] ?? DefaultValues.defaultString,
      name: json['name'] ?? DefaultValues.defaultString,
      status: json['status'] ?? DefaultValues.defaultString,
      lineItems: List<BigCommerceLineItem>.from(json['line_items']
              ['physical_items']
          .map((item) => BigCommerceLineItem.fromJson(item))),
      shippingAddress: json['shipping_address'] ?? DefaultValues.defaultString,
      billingAddress: json['billing_address'] ?? DefaultValues.defaultString,
      invoiceUrl: json['invoice_url'] ?? DefaultValues.defaultString,
      appliedDiscount:
          json['discount_amount'].toString() ?? DefaultValues.defaultString,
      orderId: json['order_id'] ?? DefaultValues.defaultInt,
      shippingLine: json['shipping_line'] ?? DefaultValues.defaultString,
      taxLines: [BigCommerceTaxLine(rate: 1.00, title: "title", price: "11.0")],
      tags: json['tags'] ?? DefaultValues.defaultString,
      noteAttributes: [],
      totalPrice: double.parse(json['cart_amount'].toString()) ??
          DefaultValues.defaultDouble,
      subtotalPrice:
          json['cart_amount'].toString() ?? DefaultValues.defaultString,
      totalTax: json['total_tax'] ?? DefaultValues.defaultString,
      paymentTerms: json['payment_terms'] ?? DefaultValues.defaultString,
      adminGraphqlApiId:
          json['admin_graphql_api_id'] ?? DefaultValues.defaultString,
      customer: BigCommerceCustomerModel(
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
          adminGraphqlApiId: "adminGraphqlApiId"),
    );
  }
}

class BigCommerceLineItem implements LineItem {
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
  final List<BigCommerceTaxLine> taxLines;
  final dynamic appliedDiscount;
  final String name;
  final List<dynamic> properties;
  final bool custom;
  final String price;
  final String adminGraphqlApiId;

  BigCommerceLineItem({
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

  factory BigCommerceLineItem.fromJson(Map<String, dynamic> json) {
    return BigCommerceLineItem(
      id: json['id'] ?? DefaultValues.defaultInt,
      variantId: json['variant_id'] ?? DefaultValues.defaultInt,
      productId: json['product_id'] ?? DefaultValues.defaultInt,
      title: json['name'] ?? DefaultValues.defaultString,
      variantTitle: json['variant_title'] ?? DefaultValues.defaultString,
      sku: json['sku'] ?? DefaultValues.defaultString,
      vendor: json['vendor'] ?? DefaultValues.defaultString,
      quantity: json['quantity'] ?? DefaultValues.defaultInt,
      requiresShipping: json['is_require_shipping'] ?? false,
      taxable: json['taxable'] ?? false,
      giftCard: json['gift_card'] ?? false,
      fulfillmentService:
          json['fulfillment_service'] ?? DefaultValues.defaultString,
      grams: json['grams'] ?? DefaultValues.defaultInt,
      taxLines: [BigCommerceTaxLine(rate: 1.00, title: "title", price: "11.0")],
      appliedDiscount: json['discount_amount'] ?? DefaultValues.defaultString,
      name: json['name'] ?? DefaultValues.defaultString,
      properties: [],
      custom: json['custom'] ?? false,
      price: json['sale_price'].toString() ?? DefaultValues.defaultString,
      adminGraphqlApiId: json['image_url'] ?? DefaultValues.defaultString,
    );
  }
}

class BigCommerceTaxLine implements TaxLine {
  final double rate;
  final String title;
  final String price;

  BigCommerceTaxLine({
    required this.rate,
    required this.title,
    required this.price,
  });

  factory BigCommerceTaxLine.fromJson(Map<String, dynamic> json) {
    return BigCommerceTaxLine(
      rate: json['rate'] ?? DefaultValues.defaultDouble,
      title: json['title'] ?? DefaultValues.defaultString,
      price: json['price'] ?? DefaultValues.defaultString,
    );
  }
}

class BigCommerceNoteAttribute implements NoteAttribute {
  final dynamic key;
  final dynamic value;

  BigCommerceNoteAttribute({
    required this.key,
    required this.value,
  });

  factory BigCommerceNoteAttribute.fromJson(Map<String, dynamic> json) {
    return BigCommerceNoteAttribute(
      key: json['key'] ?? DefaultValues.defaultString,
      value: json['value'] ?? DefaultValues.defaultString,
    );
  }
}

class BigCommerceCustomerModel implements CustomerModel {
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

  BigCommerceCustomerModel({
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

  factory BigCommerceCustomerModel.fromJson(Map<String, dynamic> json) {
    return BigCommerceCustomerModel(
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

class BigCommerceEmailMarketingConsent implements EmailMarketingConsent {
  final String state;
  final String optInLevel;
  final dynamic consentUpdatedAt;

  BigCommerceEmailMarketingConsent({
    required this.state,
    required this.optInLevel,
    required this.consentUpdatedAt,
  });

  factory BigCommerceEmailMarketingConsent.fromJson(Map<String, dynamic> json) {
    return BigCommerceEmailMarketingConsent(
      state: json['state'] ?? DefaultValues.defaultString,
      optInLevel: json['opt_in_level'] ?? DefaultValues.defaultString,
      consentUpdatedAt:
          json['consent_updated_at'] ?? DefaultValues.defaultString,
    );
  }
}

class BigCommerceSmsMarketingConsent implements SmsMarketingConsent {
  final String state;
  final String optInLevel;
  final dynamic consentUpdatedAt;
  final String consentCollectedFrom;

  BigCommerceSmsMarketingConsent({
    required this.state,
    required this.optInLevel,
    required this.consentUpdatedAt,
    required this.consentCollectedFrom,
  });

  factory BigCommerceSmsMarketingConsent.fromJson(Map<String, dynamic> json) {
    return BigCommerceSmsMarketingConsent(
      state: json['state'] ?? DefaultValues.defaultString,
      optInLevel: json['opt_in_level'] ?? DefaultValues.defaultString,
      consentUpdatedAt:
          json['consent_updated_at'] ?? DefaultValues.defaultString,
      consentCollectedFrom:
          json['consent_collected_from'] ?? DefaultValues.defaultString,
    );
  }
}

class BigCommerceDefaultAddressModel implements DefaultAddressModel {
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

  BigCommerceDefaultAddressModel({
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

  factory BigCommerceDefaultAddressModel.fromJson(Map<String, dynamic> json) {
    return BigCommerceDefaultAddressModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      customerId: json['customer_id'] ?? DefaultValues.defaultInt,
      firstName: json['first_name'] ?? DefaultValues.defaultString,
      lastName: json['last_name'] ?? DefaultValues.defaultString,
      address1: json['address1'] ?? DefaultValues.defaultString,
      city: json['city'] ?? DefaultValues.defaultString,
      province: json['state_or_province'] ?? DefaultValues.defaultString,
      country: json['country'] ?? DefaultValues.defaultString,
      zip: json['postal_code'] ??
          DefaultValues.defaultString ??
          DefaultValues.defaultString,
      phone: json['phone'] ?? DefaultValues.defaultString,
      name: json['name'] ?? DefaultValues.defaultString,
      provinceCode: json['province_code'] ?? DefaultValues.defaultString,
      countryCode: json['country_code'] ?? DefaultValues.defaultString,
      countryName: json['country'] ??
          DefaultValues.defaultString ??
          DefaultValues.defaultString,
      defaultAddress: json['default'] ?? false,
    );
  }
}
