import '../../mappers/bigcommerce_models/bigcommerce_proudct_review_model.dart';
import '../../mappers/shopify_models/shopify_product_review_model.dart';
import '../../mappers/woocommerce/woocommerce_review_model.dart';
import '../../utils/appConfiguer.dart';

class ReviewProductModels {
  final int currentPage;
  final int perPage;
  final List<Review> reviews;

  ReviewProductModels({
    required this.currentPage,
    required this.perPage,
    required this.reviews,
  });

  factory ReviewProductModels.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.wooCommerce) {
      return WooCommerceReviewProductModels.fromJson(json);
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceReviewProductModels.fromJson(json);
    } else {
      return ShopifyReviewProductModels.fromJson(json);
    }
  }
//   factory ReviewProductModels.fromJson(dynamic json) {
//   if (json is List) {
//     // If the response is a list, handle it accordingly
//     return ReviewProductModels(
//       currentPage: 0, // Set appropriate values
//       perPage: 0, // Set appropriate values
//       reviews: json,
//     );
//   } else if (json is Map<String, dynamic>) {
//     // If the response is a map, handle it accordingly
//     if (AppConfigure.wooCommerce) {
//       return WooCommerceReviewProductModels.fromJson(json);
//     } else if (AppConfigure.bigCommerce) {
//       return BigCommerceReviewProductModels.fromJson(json);
//     } else {
//       return ShopifyReviewProductModels.fromJson(json);
//     }
//   } else {
//     // Handle other cases or throw an error
//     throw Exception('Invalid JSON format');
//   }
// }

}

class Review {
  final int id;
  final String title;
  final String body;
  final int rating;
  final int productExternalId;
  final Reviewer reviewer;
  final String source;
  final String curated;
  final bool published;
  final bool hidden;
  final String verified;
  final bool featured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasPublishedPictures;
  final bool hasPublishedVideos;
  final List<dynamic> pictures;
  final String ipAddress;
  final String productTitle;
  final String productHandle;

  Review({
    required this.id,
    required this.title,
    required this.body,
    required this.rating,
    required this.productExternalId,
    required this.reviewer,
    required this.source,
    required this.curated,
    required this.published,
    required this.hidden,
    required this.verified,
    required this.featured,
    required this.createdAt,
    required this.updatedAt,
    required this.hasPublishedPictures,
    required this.hasPublishedVideos,
    required this.pictures,
    required this.ipAddress,
    required this.productTitle,
    required this.productHandle,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.wooCommerce) {
      return WooCommerceReview.fromJson(json);
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceReview.fromJson(json);
    } else {
      return ShopifyReview.fromJson(json);
    }
  }
}

class Reviewer {
  final int id;
  final dynamic externalId;
  final String email;
  final String name;
  final dynamic phone;
  final bool acceptsMarketing;
  final dynamic unsubscribedAt;
  final dynamic tags;

  Reviewer({
    required this.id,
    required this.externalId,
    required this.email,
    required this.name,
    required this.phone,
    required this.acceptsMarketing,
    required this.unsubscribedAt,
    required this.tags,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.wooCommerce) {
      return WooCommerceReviewer.fromJson(json);
    }
    if (AppConfigure.bigCommerce) {
      return BigCommerceReviewer.fromJson(json);
    } else {
      return ShopifyReviewer.fromJson(json);
    }
  }
}
