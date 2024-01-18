import 'dart:convert';

class ReviewProductModel {
  final String id;
  final String subject;
  final bool isVerified;
  final String externalProductId;
  final String productId;
  final String externalCustomerId;
  final String customerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final String heading;
  final String body;
  final bool isAnonymous;
  final String customerEditLinkUrl;
  final bool canBeEditedByCustomer;
  final RatingDetails ratingDetails; // Added property for rating details

  ReviewProductModel({
    required this.id,
    required this.subject,
    required this.isVerified,
    required this.externalProductId,
    required this.productId,
    required this.externalCustomerId,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
    required this.rating,
    required this.heading,
    required this.body,
    required this.isAnonymous,
    required this.customerEditLinkUrl,
    required this.canBeEditedByCustomer,
    required this.ratingDetails,
  });

  factory ReviewProductModel.fromJson(Map<String, dynamic> json) {
    return ReviewProductModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      isVerified: json['is_verified'] ?? false,
      externalProductId: json['external_product_id'] ?? '',
      productId: json['product_id'] ?? '',
      externalCustomerId: json['external_customer_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      rating: json['rating']?.toDouble() ?? 0.0,
      heading: json['heading'] ?? '',
      body: json['body'] ?? '',
      isAnonymous: json['is_anonymous'] ?? false,
      customerEditLinkUrl: json['customer_edit_link_url'] ?? '',
      canBeEditedByCustomer: json['can_be_edited_by_customer'] ?? false,
      ratingDetails: RatingDetails.fromJson(json['product']['rating']),
    );
  }

  static List<ReviewProductModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ReviewProductModel.fromJson(json)).toList();
  }
}

class RatingDetails {
  final double average;
  final int count;
  final List<int> counts;

  RatingDetails({
    required this.average,
    required this.count,
    required this.counts,
  });

  factory RatingDetails.fromJson(Map<String, dynamic> json) {
    return RatingDetails(
      average: json['average']?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
      counts: List<int>.from(json['counts'] ?? []),
    );
  }
}
