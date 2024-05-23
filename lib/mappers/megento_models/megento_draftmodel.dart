
import 'package:mobj_project/models/product/draftOrderModel.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';



class MagentoCommerceDraftOrderModel implements DraftOrderModel {
  @override
  final dynamic id;
  @override
  final String note;
  @override
  final String email;
  @override
  final bool taxesIncluded;
  @override
  final String currency;
  @override
  final String invoiceSentAt;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final bool taxExempt;
  @override
  final String completedAt;
  @override
  final String name;
  @override
  final String status;
  @override
  final List<MagentoCommerceLineItem> lineItems;
  @override
  final String shippingAddress;
  @override
  final String billingAddress;
  @override
  final String invoiceUrl;
  @override
  final String appliedDiscount;
  @override
  final int orderId;
  @override
  final String shippingLine;
  @override
  final List<MagentoCommerceTaxLine> taxLines;
  @override
  final String tags;
  @override
  final List<MagentoCommerceNoteAttribute> noteAttributes;
  @override
  late double totalPrice;
  @override
  final String subtotalPrice;
  @override
  final String totalTax;
  @override
  final String paymentTerms;
  @override
  final String adminGraphqlApiId;
  @override
  final MagentoCustomerModel customer;

  MagentoCommerceDraftOrderModel({
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

  factory MagentoCommerceDraftOrderModel.fromJson(Map<String, dynamic> json) {
    return MagentoCommerceDraftOrderModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      note: json["customer"]['firstname'] ?? DefaultValues.defaultString,
      email: json["customer"]['email'] ?? DefaultValues.defaultString,
      taxesIncluded: json['is_virtual'] ?? false,
      currency:
          json['currency']['global_currency_code'] ?? DefaultValues.defaultString,
      invoiceSentAt: json['created_at'] ?? DefaultValues.defaultString,
      createdAt: json['created_at'] ?? DefaultValues.defaultString,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultString,
      taxExempt: json['is_virtual'] ?? false,
      completedAt: json['created_at'] ?? DefaultValues.defaultString,
      name: json["customer"]['firstname'] ?? DefaultValues.defaultString,
      status: json["customer"]['lastname'] ?? DefaultValues.defaultString,
      lineItems: List<MagentoCommerceLineItem>.from(
          json['items'].map((item) => MagentoCommerceLineItem.fromJson(item))),
      shippingAddress: json['customer']["addresses"] ?? DefaultValues.defaultString,
      billingAddress: json['customer']["addresses"] ?? DefaultValues.defaultString,
      invoiceUrl: json['invoice_url'] ?? DefaultValues.defaultString,
      appliedDiscount: json['applied_discount'] ?? DefaultValues.defaultString,
      orderId: json['order_id'] ?? DefaultValues.defaultInt,
      shippingLine: json['shipping_line'] ?? DefaultValues.defaultString,
      taxLines: [MagentoCommerceTaxLine(rate: 1.00, title: "name", price: "11.0")],
      tags: json['tags'] ?? DefaultValues.defaultString,
      noteAttributes: [],
      totalPrice: double.parse(json['items']['price'].toString()) / 100 ??
          DefaultValues.defaultDouble,
      subtotalPrice: (double.parse(json['items']['price'].toString()) / 100)
              .toString() ??
          DefaultValues.defaultString,
      totalTax: json['items']['price'] ?? DefaultValues.defaultString,
      paymentTerms: json['payment_terms'] ?? DefaultValues.defaultString,
      adminGraphqlApiId:
          json['admin_graphql_api_id'] ?? DefaultValues.defaultString,
      customer: MagentoCustomerModel(
          id: 7,
          email: 'email',
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

class MagentoCommerceNoteAttribute implements NoteAttribute {
  @override
  final dynamic key;
  @override
  final dynamic value;

  MagentoCommerceNoteAttribute({
    required this.key,
    required this.value,
  });

  factory MagentoCommerceNoteAttribute.fromJson(Map<String, dynamic> json) {
    return MagentoCommerceNoteAttribute(
      key: json['key'] ?? DefaultValues.defaultString,
      value: json['value'] ?? DefaultValues.defaultString,
    );
  }
}

class MagentoCommerceLineItem implements LineItem {
  @override
  final dynamic id;
  @override
  late final int variantId;
  @override
  final int productId;
  @override
  final String title;
  @override
  final String variantTitle;
  @override
  final String sku;
  @override
  final String vendor;
  @override
  late int quantity;
  @override
  final bool requiresShipping;
  @override
  final bool taxable;
  @override
  final bool giftCard;
  @override
  final String fulfillmentService;
  @override
  final int grams;
  @override
  final List<MagentoCommerceTaxLine> taxLines;
  @override
  final dynamic appliedDiscount;
  @override
  final String name;
  @override
  final List<dynamic> properties;
  @override
  final bool custom;
  @override
  final String price;
  @override
  final String adminGraphqlApiId;

  MagentoCommerceLineItem({
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

  factory MagentoCommerceLineItem.fromJson(Map<String, dynamic> json) {
    return MagentoCommerceLineItem(
      id: json['items']['item_id'] ?? DefaultValues.defaultInt,
      variantId: json['items']['item_id'] ?? DefaultValues.defaultInt,
      productId: json['items']['item_id'] ?? DefaultValues.defaultInt,
      title: json['items']['name'] ?? DefaultValues.defaultString,
      variantTitle: json['items']['name'] ?? DefaultValues.defaultString,
      sku: json['items']['sku'] ?? DefaultValues.defaultString,
      vendor: json['items']['name'] ?? DefaultValues.defaultString,
      quantity: json['items']['qty'] ?? DefaultValues.defaultInt,
      requiresShipping: json[''] ?? false,
      taxable: json[''] ?? false,
      giftCard: json[''] ?? false,
      fulfillmentService:
          json['items']['name'] ?? DefaultValues.defaultString,
      grams: json['items']['qty'].round() ?? DefaultValues.defaultInt,
      taxLines: [MagentoCommerceTaxLine(rate: 1.00, title: "name", price: "11.0")],
      appliedDiscount: json['items']['name'] ?? DefaultValues.defaultString,
      name: json['items']['name']?? DefaultValues.defaultString,
      properties: [],
      custom: json['is_virtual'] ?? false,
      price: (double.parse(json['items']['price'].toString()) / 100).toString() ??
          DefaultValues.defaultString,
      adminGraphqlApiId: json["items"]['product_type'] ?? DefaultValues.defaultString,
    );
  }
}


class MagentoCommerceTaxLine implements TaxLine {
  @override
  final double rate;
  @override
  final String title;
  @override
  final String price;

  MagentoCommerceTaxLine({
    required this.rate,
    required this.title,
    required this.price,
  });

  factory MagentoCommerceTaxLine.fromJson(Map<String, dynamic> json) {
    return MagentoCommerceTaxLine(
      rate: json['rate'] ?? DefaultValues.defaultDouble,
      title: json['title'] ?? DefaultValues.defaultString,
      price: json['price'] ?? DefaultValues.defaultString,
    );
  }
}
class MagentoCustomerModel implements CustomerModel {
  @override
  final int id;
  @override
  final String email;
  @override
  final bool acceptsMarketing;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int ordersCount;
  @override
  final String state;
  @override
  final String totalSpent;
  @override
  final int lastOrderId;
  @override
  final dynamic note;
  @override
  final bool taxExempt;
  @override
  final String tags;
  @override
  final String lastOrderName;
  @override
  final String currency;
  @override
  final String phone;
  @override
  final String adminGraphqlApiId;

  MagentoCustomerModel({
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

  factory MagentoCustomerModel.fromJson(Map<String, dynamic> json) {
    return MagentoCustomerModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      email: json['email'] ?? DefaultValues.defaultString,
      acceptsMarketing: json['accepts_marketing'] ?? false,
      createdAt: json['created_at'] ?? DefaultValues.defaultString,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultString,
      firstName: json['firstname'] ?? DefaultValues.defaultString,
      lastName: json['lastname'] ?? DefaultValues.defaultString,
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


class MagentoDefaultAddressModel implements DefaultAddressModel {
  @override
  final int id;
  @override
  final int customerId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final dynamic address1;
  @override
  late String city;
  @override
  final String province;
  @override
  final String country;
  @override
  final String zip;
  @override
  final String phone;
  @override
  final String name;
  @override
  final String provinceCode;
  @override
  final String countryCode;
  @override
  final String countryName;
  @override
  late bool defaultAddress;

  MagentoDefaultAddressModel({
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

  factory MagentoDefaultAddressModel.fromJson(Map<String, dynamic> json) {
    return MagentoDefaultAddressModel(
      id: json['id'] ?? DefaultValues.defaultInt,
      customerId: json['id'] ?? DefaultValues.defaultInt,
      firstName: json['firstname'] ?? DefaultValues.defaultString,
      lastName: json['lastname'] ?? DefaultValues.defaultString,
      address1: json['addresses']["street"][0].toString() ?? DefaultValues.defaultString,
      city: json['addresses']['city'] ?? DefaultValues.defaultString,
      province: json['addresses']['vat_id'] ?? DefaultValues.defaultString,
      country: json['addresses']['country_id'] ?? DefaultValues.defaultString,
      zip: json['addresses']['postcode'] ?? DefaultValues.defaultString,
      phone: json['addresses']['telephone'] ?? DefaultValues.defaultString,
      name: json['firstname'] ?? DefaultValues.defaultString,
      provinceCode: json['addresses']['vat_id'] ?? DefaultValues.defaultString,
      countryCode: json['addresses']['country_id']?? DefaultValues.defaultString,
      countryName: json['addresses']['country_id']?? DefaultValues.defaultString,
      defaultAddress: json['default'] ?? false,
    );
  }
  
 
}
