// collectionProductModel

import 'package:mobj_project/utils/cmsConfigue.dart';

class ProductCollectionModel {
  final String handle;
  final String title;
  final String description;
  final String featuredImage;
  final double minPrice;
  final double maxPrice;
  final String currencyCode;
  final List<String> imageUrls;
  final String id;

  ProductCollectionModel({
    required this.handle,
    required this.title,
    required this.description,
    required this.featuredImage,
    required this.minPrice,
    required this.maxPrice,
    required this.currencyCode,
    required this.id,
    required this.imageUrls,
  });

  factory ProductCollectionModel.fromJson(Map<String, dynamic> json) {
    final priceRange = json['priceRange'];
    var imageEdges = json['images']['edges'] as List;
    List<String> imageUrlList = imageEdges
            .map((edge) => edge?['node']['url'] ?? "")
            .cast<String>()
            .toList() ??
        [];
    return ProductCollectionModel(
      handle: json['handle'] ?? DefaultValues.defaultHandle,
      title: json['title'] ?? DefaultValues.defaultTitle,
      description: json['description'] ?? DefaultValues.defaultTitle,
      featuredImage: json['featuredImage']!=null?json['featuredImage']['src']: DefaultValues.defaultTitle,
      minPrice: double.parse(priceRange['minVariantPrice']['amount']) ??
          DefaultValues.defaultMinPrice,
      maxPrice: double.parse(priceRange['maxVariantPrice']['amount']) ??
          DefaultValues.defaultMinPrice,
      currencyCode: priceRange['minVariantPrice']['currencyCode'] ??
          DefaultValues.defaultTitle,
      id: json['id'] ?? DefaultValues.defaultTitle,
      imageUrls: imageUrlList,
    );
  }
}
