// collectionProductModel

import 'package:mobj_project/models/product/collectionProductModel.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class ShopifyProductCollectionModel implements ProductCollectionModel {
  @override
  final String handle;
  @override
  final String title;
  @override
  final String description;
  @override
  final String featuredImage;
  @override
  final double minPrice;
  @override
  final double maxPrice;
  @override
  final String currencyCode;
  @override
  final List<String> imageUrls;
  @override
  final String id;

  ShopifyProductCollectionModel({
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

  factory ShopifyProductCollectionModel.fromJson(Map<String, dynamic> json) {
    final priceRange = json['priceRange'];
    var imageEdges = json['images']['edges'] as List;
    List<String> imageUrlList =  imageEdges
            ?.map((edge) => edge?['node']['url'] ?? "")
            .cast<String>()
            .toList() ??
        [];
    return ShopifyProductCollectionModel(
      handle: json['handle'] ?? DefaultValues.defaultHandle,
      title:  json['title'] ?? DefaultValues.defaultTitle,
      description: json['description'] ?? DefaultValues.defaultTitle,
      featuredImage: json['featuredImage'] != null
              ? json['featuredImage']['src']
              : DefaultValues.defaultTitle,
      minPrice: double.parse(priceRange['minVariantPrice']['amount']) ??
              DefaultValues.defaultMinPrice,
      maxPrice:  double.parse(priceRange['maxVariantPrice']['amount']) ??
              DefaultValues.defaultMinPrice,
      currencyCode:  priceRange['minVariantPrice']['currencyCode'] ??
              DefaultValues.defaultTitle,
      id: json['id'] ?? DefaultValues.defaultTitle,
      imageUrls:  imageUrlList,
    );
  }
}
