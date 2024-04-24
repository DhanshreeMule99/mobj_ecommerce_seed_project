// collectionProductModel

import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../mappers/bigcommerce_models/bigcommerce_collectionproudctmodel.dart';
import '../../mappers/shopify_models/shopify_collectionproudctmode.dart';

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
    if (AppConfigure.bigCommerce) {
      return BigCommerceProductCollectionModel.fromJson(json);
    } else {
      return ShopifyProductCollectionModel.fromJson(json);
    }
  }
}
