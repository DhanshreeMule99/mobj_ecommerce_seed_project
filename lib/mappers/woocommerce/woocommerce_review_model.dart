import '../../models/product/productReviewWiseModel.dart';

// WooCommerceReviewProductModels reviewProductModelsFromJson(String str) =>
//     WooCommerceReviewProductModels.fromJson(json.decode(str));

// String reviewProductModelsToJson(WooCommerceReviewProductModels data) =>
//     json.encode(data.toJson());

class WooCommerceReviewProductModels implements ReviewProductModels {
  @override
  int currentPage;
  @override
  int perPage;
  @override
  List<WooCommerceReview> reviews;

  WooCommerceReviewProductModels({
    required this.currentPage,
    required this.perPage,
    required this.reviews,
  });

  factory WooCommerceReviewProductModels.fromJson(Map<String, dynamic> json) {
    return WooCommerceReviewProductModels(
     currentPage: json['rating'],
      perPage: json['rating'],
      // reviews: json['review'],
      reviews: List<WooCommerceReview>.from(
          json['review'].map((x) => WooCommerceReview.fromJson(x))),
    );
  }
}

class WooCommerceReview implements Review {
  @override
  int id;
  @override
  String title;
  @override
  String body;
  @override
  int rating;
  @override
  int productExternalId;
  @override
  WooCommerceReviewer reviewer;
  @override
  String source;
  @override
  String curated;
  @override
  bool published;
  @override
  bool hidden;
  @override
  String verified;
  @override
  bool featured;
  @override
  DateTime createdAt;
  @override
  DateTime updatedAt;
  @override
  bool hasPublishedPictures;
  @override
  bool hasPublishedVideos;
  @override
  List<dynamic> pictures;
  @override
  String ipAddress;
  @override
  String productTitle;
  @override
  String productHandle;

  WooCommerceReview({
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

  factory WooCommerceReview.fromJson(Map<String, dynamic> json) =>
      WooCommerceReview(
        id: json["id"],
        title: json["product_name"],
        body: json['review'],
        rating: json["rating"],
        productExternalId: 0,
        reviewer: WooCommerceReviewer(
            id: json["id"],
            externalId: 0,
            email: json['email'],
            name: json['name'],
            phone: 123456789,
            acceptsMarketing: true,
            unsubscribedAt: "",
            tags: ""),
        source: "",
        curated: "",
        published: true,
        hidden: true,
        verified: "",
        featured: true,
        createdAt: DateTime.parse(json["date_created"]),
        updatedAt: DateTime.parse(json["date_created_gmt"]),
        hasPublishedPictures: true,
        hasPublishedVideos: true,
        pictures: [],
        ipAddress: "",
        productTitle: "",
        productHandle: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "rating": rating,
        "product_external_id": productExternalId,
        "reviewer": reviewer.toJson(),
        "source": source,
        "curated": curated,
        "published": published,
        "hidden": hidden,
        "verified": verified,
        "featured": featured,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "has_published_pictures": hasPublishedPictures,
        "has_published_videos": hasPublishedVideos,
        "pictures": List<dynamic>.from(pictures.map((x) => x)),
        "ip_address": ipAddress,
        "product_title": productTitle,
        "product_handle": productHandle,
      };
}

class WooCommerceReviewer implements Reviewer {
  @override
  int id;
  @override
  dynamic externalId;
  @override
  String email;
  @override
  String name;
  @override
  dynamic phone;
  @override
  bool acceptsMarketing;
  @override
  dynamic unsubscribedAt;
  @override
  dynamic tags;

  WooCommerceReviewer({
    required this.id,
    required this.externalId,
    required this.email,
    required this.name,
    required this.phone,
    required this.acceptsMarketing,
    required this.unsubscribedAt,
    required this.tags,
  });

  factory WooCommerceReviewer.fromJson(Map<String, dynamic> json) =>
      WooCommerceReviewer(
        id: json["product_id"],
        externalId: 0,
        email: json["reviewer_email"],
        name: json["reviewer"],
        phone: json["rating"],
        acceptsMarketing: json["verified"],
        unsubscribedAt: json["status"],
        tags: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "external_id": externalId,
        "email": email,
        "name": name,
        "phone": phone,
        "accepts_marketing": acceptsMarketing,
        "unsubscribed_at": unsubscribedAt,
        "tags": tags,
      };
}
