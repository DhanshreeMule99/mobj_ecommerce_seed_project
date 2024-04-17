import 'dart:convert';
import 'dart:developer';
// import 'dart:math';
import 'package:flutter/foundation.dart';

import '../../../utils/appConfiguer.dart';

ReviewProductModels reviewProductModelsFromJson(String str) =>
    ReviewProductModels.fromJson(json.decode(str));

String reviewProductModelsToJson(ReviewProductModels data) =>
    json.encode(data.toJson());

class ReviewProductModels {
  int currentPage;
  int perPage;
  List<Review> reviews;

  ReviewProductModels({
    required this.currentPage,
    required this.perPage,
    required this.reviews,
  });

  factory ReviewProductModels.fromJson(Map<String, dynamic> json) =>
      ReviewProductModels(
        currentPage: AppConfigure.bigCommerce == true
            ? json['meta']['pagination']['current_page']
            : json['current_page'],
        perPage: AppConfigure.bigCommerce == true
            ? json['meta']['pagination']['per_page']
            : json['per_page'],
        reviews: AppConfigure.bigCommerce == true
            ? List<Review>.from(json['data'].map((x) => Review.fromJson(x)))
            : List<Review>.from(json['reviews'].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "per_page": perPage,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };

  // logReviews() {
  //   log('Reviews:');
  //   for (var review in reviews) {
  //     log('Review ID: ${review.id}');
  //     log('Title: ${review.title}');
  //     log('Rating: ${review.rating}');
  //     log('Body: ${review.body}');
  //     // Add more fields as needed
  //     log('---------------------');
  //   }
  // }
}

class Review {
  int id;
  String title;
  String body;
  int rating;
  int productExternalId;
  Reviewer reviewer;
  String source;
  String curated;
  bool published;
  bool hidden;
  String verified;
  bool featured;
  DateTime createdAt;
  DateTime updatedAt;
  bool hasPublishedPictures;
  bool hasPublishedVideos;
  List<dynamic> pictures;
  String ipAddress;
  String productTitle;
  String productHandle;

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

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        title: json["title"],
        body: AppConfigure.bigCommerce ? json['text'] : json["body"],
        rating: json["rating"],
        productExternalId:
            AppConfigure.bigCommerce ? 0 : json["product_external_id"],
        reviewer: AppConfigure.bigCommerce
            ? Reviewer(
                id: json["id"],
                externalId: json["id"],
                email: json['email'],
                name: json['name'],
                phone: 123456789,
                acceptsMarketing: true,
                unsubscribedAt: "unsubscribedAt",
                tags: "tags")
            : Reviewer.fromJson(json["reviewer"]),
        source: AppConfigure.bigCommerce ? "" : json["source"],
        curated: AppConfigure.bigCommerce ? "" : json["curated"],
        published: AppConfigure.bigCommerce ? true : json["published"],
        hidden: AppConfigure.bigCommerce ? true : json["hidden"],
        verified: AppConfigure.bigCommerce ? "" : json["verified"],
        featured: AppConfigure.bigCommerce ? true : json["featured"],
        createdAt: AppConfigure.bigCommerce
            ? DateTime.parse(json["date_created"])
            : DateTime.parse(json["created_at"]),
        updatedAt: AppConfigure.bigCommerce
            ? DateTime.parse(json["date_modified"])
            : DateTime.parse(json["updated_at"]),
        hasPublishedPictures:
            AppConfigure.bigCommerce ? true : json["has_published_pictures"],
        hasPublishedVideos:
            AppConfigure.bigCommerce ? true : json["has_published_videos"],
        pictures: AppConfigure.bigCommerce
            ? []
            : List<dynamic>.from(json["pictures"].map((x) => x)),
        ipAddress: AppConfigure.bigCommerce ? "" : json["ip_address"],
        productTitle: AppConfigure.bigCommerce ? "" : json["product_title"],
        productHandle: AppConfigure.bigCommerce ? "" : json["product_handle"],
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

class Reviewer {
  int id;
  dynamic externalId;
  String email;
  String name;
  dynamic phone;
  bool acceptsMarketing;
  dynamic unsubscribedAt;
  dynamic tags;

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

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
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
