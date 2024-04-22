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
    final priceRange = AppConfigure.bigCommerce ? "" : json['priceRange'];
    var imageEdges =AppConfigure.bigCommerce ? [] : json['images']['edges'] as List;
    List<String> imageUrlList =AppConfigure.bigCommerce ? [""] : imageEdges
            ?.map((edge) => edge?['node']['url'] ?? "")
            .cast<String>()
            ?.toList() ??
        [];
    return ProductCollectionModel(
      handle: json['handle'] ?? DefaultValues.defaultHandle,
      title: AppConfigure.bigCommerce
          ? json['name']
          : json['title'] ?? DefaultValues.defaultTitle,
      description: json['description'] ?? DefaultValues.defaultTitle,
      featuredImage: AppConfigure.bigCommerce
          ? json['defaultImage']['urlOriginal']
          : json['featuredImage'] != null
              ? json['featuredImage']['src']
              : DefaultValues.defaultTitle,
      minPrice: AppConfigure.bigCommerce
          ? json['prices']['price']['value']
          : double.parse(priceRange['minVariantPrice']['amount']) ??
              DefaultValues.defaultMinPrice,
      maxPrice: AppConfigure.bigCommerce
          ? json['prices']['price']['value']
          : double.parse(priceRange['maxVariantPrice']['amount']) ??
              DefaultValues.defaultMinPrice,
      currencyCode: AppConfigure.bigCommerce
          ? json['prices']['price']['currencyCode']
          : priceRange['minVariantPrice']['currencyCode'] ??
              DefaultValues.defaultTitle,
      id: AppConfigure.bigCommerce
          ? json['entityId'].toString()
          : json['id'] ?? DefaultValues.defaultTitle,
      imageUrls:AppConfigure.bigCommerce? [json['defaultImage']['urlOriginal']]
      :  imageUrlList,
    );
  }
}
