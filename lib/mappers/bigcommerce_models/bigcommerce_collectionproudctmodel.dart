// collectionProductModel

import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../models/product/collectionProductModel.dart';

class BigCommerceProductCollectionModel implements ProductCollectionModel {
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

  BigCommerceProductCollectionModel({
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

  factory BigCommerceProductCollectionModel.fromJson(Map<String, dynamic> json) {
    return BigCommerceProductCollectionModel(
      handle: json['handle'] ?? DefaultValues.defaultHandle,
      title: json['name'] ?? DefaultValues.defaultTitle,
      description: json['description'] ?? DefaultValues.defaultTitle,
      featuredImage:
          json['defaultImage']['urlOriginal'] ?? DefaultValues.defaultTitle,
      minPrice:
          json['prices']['price']['value'] ?? DefaultValues.defaultMinPrice,
      maxPrice:
 json['prices']['price']['value']
 ??
              DefaultValues.defaultMinPrice,
      currencyCode: json['prices']['price']['currencyCode']
           ??
              DefaultValues.defaultTitle,
      id:  json['entityId'].toString()
           ?? DefaultValues.defaultTitle,
      imageUrls: [json['defaultImage']['urlOriginal']]
          ,
    );
  }
}
