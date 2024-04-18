import '../../utils/defaultValues.dart';

class RecommendedProductModel {
  final int id;
  final String title;
  final String handle;
  final String description;
  final String publishedAt;
  final String createdAt;
  final String vendor;
  final String type;
  final List<String> tags;
  final double price;
  final double priceMin;
  final double priceMax;
  final bool available;
  final bool priceVaries;
  final List<RecommendedProductVariant> variants;
  final List<String> images;
  final String featuredImage;
  final List<Map<String, dynamic>> options;
  final String url;
  final List<Map<String, dynamic>> media;

  RecommendedProductModel({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.publishedAt,
    required this.createdAt,
    required this.vendor,
    required this.type,
    required this.tags,
    required this.price,
    required this.priceMin,
    required this.priceMax,
    required this.available,
    required this.priceVaries,
    required this.variants,
    required this.images,
    required this.featuredImage,
    required this.options,
    required this.url,
    required this.media,
  });

  factory RecommendedProductModel.fromJson(Map<String, dynamic> json) {
    return RecommendedProductModel(
      id: json['id'] as int? ?? DefaultValues.idDefault,
      title: json['title'] as String? ?? DefaultValues.stringDefault,
      handle: json['handle'] as String? ?? DefaultValues.stringDefault,
      description:
          json['description'] as String? ?? DefaultValues.stringDefault,
      publishedAt:
          json['published_at'] as String? ?? DefaultValues.stringDefault,
      createdAt: json['created_at'] as String? ?? DefaultValues.stringDefault,
      vendor: json['vendor'] as String? ?? DefaultValues.stringDefault,
      type: json['type'] as String? ?? DefaultValues.stringDefault,
      tags: List<String>.from(
          json['tags'] as List? ?? DefaultValues.listStringDefault),
      price: (json['price'] as num? ?? DefaultValues.doubleDefault).toDouble(),
      priceMin:
          (json['price_min'] as num? ?? DefaultValues.doubleDefault).toDouble(),
      priceMax:
          (json['price_max'] as num? ?? DefaultValues.doubleDefault).toDouble(),
      available: json['available'] as bool? ?? DefaultValues.boolDefault,
      priceVaries: json['price_varies'] as bool? ?? DefaultValues.boolDefault,
      variants: List<RecommendedProductVariant>.from(json['variants'].map(
          (variant) => RecommendedProductVariant.fromJson(
              variant as Map<String, dynamic>))),
      images: List<String>.from(
          json['images'] as List? ?? DefaultValues.listStringDefault),
      featuredImage:
          json['featured_image'] as String? ?? DefaultValues.stringDefault,
      options: List<Map<String, dynamic>>.from(
          json['options'] as List? ?? DefaultValues.listMapDefault),
      url: json['url'] as String? ?? DefaultValues.stringDefault,
      media: List<Map<String, dynamic>>.from(
          json['media'] as List? ?? DefaultValues.listMapDefault),
    );
  }
}

class RecommendedProductVariant {
  final int id;
  final String title;
  final String sku;
  final bool requiresShipping;
  final bool taxable;
  final bool available;
  final String name;
  final String publicTitle;
  final List<String> options;
  final double price;
  final double weight;
  final String inventoryManagement;
  final String barcode;

  RecommendedProductVariant({
    required this.id,
    required this.title,
    required this.sku,
    required this.requiresShipping,
    required this.taxable,
    required this.available,
    required this.name,
    required this.publicTitle,
    required this.options,
    required this.price,
    required this.weight,
    required this.inventoryManagement,
    required this.barcode,
  });

  factory RecommendedProductVariant.fromJson(Map<String, dynamic> json) {
    return RecommendedProductVariant(
      id: json['id'] as int? ?? DefaultValues.idDefault,
      title: json['title'] as String? ?? DefaultValues.stringDefault,
      sku: json['sku'] as String? ?? DefaultValues.stringDefault,
      requiresShipping:
          json['requires_shipping'] as bool? ?? DefaultValues.boolDefault,
      taxable: json['taxable'] as bool? ?? DefaultValues.boolDefault,
      available: json['available'] as bool? ?? DefaultValues.boolDefault,
      name: json['name'] as String? ?? DefaultValues.stringDefault,
      publicTitle:
          json['public_title'] as String? ?? DefaultValues.stringDefault,
      options: List<String>.from(
          json['options'] as List? ?? DefaultValues.listStringDefault),
      price: (json['price'] as num? ?? DefaultValues.doubleDefault).toDouble(),
      weight:
          (json['weight'] as num? ?? DefaultValues.doubleDefault).toDouble(),
      inventoryManagement: json['inventory_management'] as String? ??
          DefaultValues.stringDefault,
      barcode: json['barcode'] as String? ?? DefaultValues.stringDefault,
    );
  }
}
