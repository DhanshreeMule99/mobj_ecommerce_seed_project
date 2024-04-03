class ProductRatingModel {
  final String subject;
  final String externalProductId;
  final String productId;
  final double average;
  final int count;
  final double ungroupedAverage;
  final int ungroupedCount;
  final int verifiedCount;

  ProductRatingModel({
    required this.subject,
    required this.externalProductId,
    required this.productId,
    required this.average,
    required this.count,
    required this.ungroupedAverage,
    required this.ungroupedCount,
    required this.verifiedCount,
  });

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingModel(
      subject: json['subject'] ?? '',
      externalProductId: json['external_product_id'] ?? '',
      productId: json['product_id'] ?? '',
      average: (json['average'] as num).toDouble(),
      count: json['count'] ?? 0,
      ungroupedAverage: (json['ungrouped_average'] as num).toDouble(),
      ungroupedCount: json['ungrouped_count'] ?? 0,
      verifiedCount: json['verified_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'external_product_id': externalProductId,
      'product_id': productId,
      'average': average,
      'count': count,
      'ungrouped_average': ungroupedAverage,
      'ungrouped_count': ungroupedCount,
      'verified_count': verifiedCount,
    };
  }
}
