
import 'package:mobj_project/models/product/draftOrderModel.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class MegentoCustomerModel implements CustomerModel {
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

  MegentoCustomerModel({
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

  factory MegentoCustomerModel.fromJson(Map<String, dynamic> json) {
    return MegentoCustomerModel(
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
