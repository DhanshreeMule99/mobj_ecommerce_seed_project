// To parse this JSON data, do
//
//     final reviewProductModels = reviewProductModelsFromJson(jsonString);

import 'dart:convert';

ReviewProductModels reviewProductModelsFromJson(String str) => ReviewProductModels.fromJson(json.decode(str));

String reviewProductModelsToJson(ReviewProductModels data) => json.encode(data.toJson());

class ReviewProductModels {
    int currentPage;
    int perPage;
    List<Review> reviews;

    ReviewProductModels({
        required this.currentPage,
        required this.perPage,
        required this.reviews,
    });

    factory ReviewProductModels.fromJson(Map<String, dynamic> json) => ReviewProductModels(
        currentPage: json["current_page"],
        perPage: json["per_page"],
        reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "per_page": perPage,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    };
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
        body: json["body"],
        rating: json["rating"],
        productExternalId: json["product_external_id"],
        reviewer: Reviewer.fromJson(json["reviewer"]),
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
