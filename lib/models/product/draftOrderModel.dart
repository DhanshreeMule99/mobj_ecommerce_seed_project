import 'package:mobj_project/utils/appConfiguer.dart';

import '../../mappers/bigcommerce_models/bigcommerce_draftordermodel.dart';
import '../../mappers/shopify_models/shopify_draftoderdermodel.dart';
import '../../mappers/woocommerce/woocommerce_draftmodel.dart';
import '../../utils/defaultValues.dart';

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
    if (AppConfigure.bigCommerce) {
      return BigCommerceDraftOrderModel.fromJson(json);
    } else {
      return ShopifyDraftOrderModel.fromJson(json);
    }
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
    // if(AppConfigure.wooCommerce){

    // }
    if (AppConfigure.bigCommerce) {
      return BigCommerceLineItem.fromJson(json);
    } else {
      return ShopifyLineItem.fromJson(json);
    }
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
  final dynamic id;
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
    if (AppConfigure.bigCommerce) {
      return BigCommerceCustomerModel.fromJson(json);
    } else if (AppConfigure.wooCommerce) {
      return WooCustomerModel.fromJson(json);
    } else {
      return ShopifyCustomerModel.fromJson(json);
    }
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
    if (AppConfigure.bigCommerce) {
      return BigCommerceEmailMarketingConsent.fromJson(json);
    } else {
      return ShopifyEmailMarketingConsent.fromJson(json);
    }
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
    if (AppConfigure.bigCommerce) {
      return BigCommerceSmsMarketingConsent.fromJson(json);
    } else {
      return ShopifySmsMarketingConsent.fromJson(json);
    }
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
    if (AppConfigure.bigCommerce) {
      return BigCommerceDefaultAddressModel.fromJson(json);
    } else {
      return ShopifyDefaultAddressModel.fromJson(json);
    }
  }
}
