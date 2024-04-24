import 'package:mobj_project/models/product/productReviewWiseModel.dart';


class ShopifyReviewProductModels implements ReviewProductModels {
  @override
  int currentPage;
  @override
  int perPage;
  @override
  List<ShopifyReview> reviews;

  ShopifyReviewProductModels({
    required this.currentPage,
    required this.perPage,
    required this.reviews,
  });

  factory ShopifyReviewProductModels.fromJson(Map<String, dynamic> json) =>
      ShopifyReviewProductModels(
        currentPage: json['current_page'],
        perPage: json['per_page'],
        reviews: List<ShopifyReview>.from(
            json['reviews'].map((x) => ShopifyReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "per_page": perPage,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class ShopifyReview implements Review {
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
  ShopifyReviewer reviewer;
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

  ShopifyReview({
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

  factory ShopifyReview.fromJson(Map<String, dynamic> json) => ShopifyReview(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        rating: json["rating"],
        productExternalId: json["product_external_id"],
        reviewer: ShopifyReviewer.fromJson(json["reviewer"]),
        source: json["source"],
        curated: json["curated"],
        published: json["published"],
        hidden: json["hidden"],
        verified: json["verified"],
        featured: json["featured"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        hasPublishedPictures: json["has_published_pictures"],
        hasPublishedVideos: json["has_published_videos"],
        pictures: List<dynamic>.from(json["pictures"].map((x) => x)),
        ipAddress: json["ip_address"],
        productTitle: json["product_title"],
        productHandle: json["product_handle"],
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

class ShopifyReviewer implements Reviewer {
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

  ShopifyReviewer({
    required this.id,
    required this.externalId,
    required this.email,
    required this.name,
    required this.phone,
    required this.acceptsMarketing,
    required this.unsubscribedAt,
    required this.tags,
  });

  factory ShopifyReviewer.fromJson(Map<String, dynamic> json) =>
      ShopifyReviewer(
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
