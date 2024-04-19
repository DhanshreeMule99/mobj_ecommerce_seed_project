
import '../../models/product/productReviewWiseModel.dart';

// BigCommerceReviewProductModels reviewProductModelsFromJson(String str) =>
//     BigCommerceReviewProductModels.fromJson(json.decode(str));

// String reviewProductModelsToJson(BigCommerceReviewProductModels data) =>
//     json.encode(data.toJson());

class BigCommerceReviewProductModels implements ReviewProductModels {
  @override
  int currentPage;
  @override
  int perPage;
  @override
  List<BigCommerceReview> reviews;

  BigCommerceReviewProductModels({
    required this.currentPage,
    required this.perPage,
    required this.reviews,
  });

  factory BigCommerceReviewProductModels.fromJson(Map<String, dynamic> json) {
    return BigCommerceReviewProductModels(
      currentPage: json['meta']['pagination']['current_page'],
      perPage: json['meta']['pagination']['per_page'],
      reviews: List<BigCommerceReview>.from(
          json['data'].map((x) => BigCommerceReview.fromJson(x))),
    );
  }
}

class BigCommerceReview implements Review {
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
  BigCommerceReviewer reviewer;
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

  BigCommerceReview({
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

  factory BigCommerceReview.fromJson(Map<String, dynamic> json) =>
      BigCommerceReview(
        id: json["id"],
        title: json["title"],
        body: json['text'],
        rating: json["rating"],
        productExternalId: 0,
        reviewer: BigCommerceReviewer(
            id: json["id"],
            externalId: json["id"],
            email: json['email'],
            name: json['name'],
            phone: 123456789,
            acceptsMarketing: true,
            unsubscribedAt: "unsubscribedAt",
            tags: "tags"),
        source: "",
        curated: "",
        published: true,
        hidden: true,
        verified: "",
        featured: true,
        createdAt: DateTime.parse(json["date_created"]),
        updatedAt: DateTime.parse(json["date_modified"]),
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

class BigCommerceReviewer implements Reviewer {
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

  BigCommerceReviewer({
    required this.id,
    required this.externalId,
    required this.email,
    required this.name,
    required this.phone,
    required this.acceptsMarketing,
    required this.unsubscribedAt,
    required this.tags,
  });

  factory BigCommerceReviewer.fromJson(Map<String, dynamic> json) =>
      BigCommerceReviewer(
        id: json["id"],
        externalId: json["external_id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        acceptsMarketing: json["accepts_marketing"],
        unsubscribedAt: json["unsubscribed_at"],
        tags: json["tags"],
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
