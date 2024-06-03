import 'dart:developer';

import 'package:mobj_project/mappers/bigcommerce_models/bigcommerce_proudct_model.dart';
import 'package:mobj_project/mappers/shopify_models/shopify_proudct_model.dart';
import 'package:mobj_project/utils/appConfiguer.dart';

import '../../mappers/megento_models/megentoProductModel.dart';
import '../../mappers/woocommerce/woocommerce_productmodel.dart';

class ProductModel {
  final int id;
  final String sku;
  final int attribute_set_id;
  final int price;
  final String title;
  final String bodyHtml;
  final String vendor;
  final String productType;
  final String createdAt;
  final String handle;
  final String updatedAt;
  final String publishedAt;
  final String templateSuffix;
  final String publishedScope;
  final String tags;
  final String status;
  final String adminGraphqlApiId;
  final List<ProductVariant> variants;
  final List<ProductOption> options;
  final List<ProductImage> images;
  final ProductImage image;

  ProductModel(
    this.sku,
    this.attribute_set_id, {
    required this.id,
    required this.price,
    required this.title,
    required this.bodyHtml, // Default value for bodyHtml
    required this.vendor,
    required this.productType, // Default value for productType
    required this.createdAt,
    required this.handle,
    required this.updatedAt,
    required this.publishedAt,
    required this.templateSuffix, // Default value for templateSuffix
    required this.publishedScope,
    required this.tags,
    required this.status,
    required this.adminGraphqlApiId,
    required this.variants,
    required this.options,
    required this.images,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.megentoCommerce) {
      try {
        log('megentoCommerce model');
        return MengentoProductModel.fromJson(json);
      } catch (e) {
        log('Error is :$e');
        rethrow;
      }
    } else if (AppConfigure.wooCommerce) {
      try {
        log('WooCommerce model');
        return WooCommerceProductModel.fromJson(json);
      } catch (e) {
        log('Error is :$e');
        rethrow;
      }
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceProductModel.fromJson(json);
    } else {
      return ShopifyProductModel.fromJson(json);
    }
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String title;
  final String price;
  final String sku;
  final int position;
  final String inventoryPolicy;
  final String compareAtPrice;
  final String fulfillmentService;
  final String inventoryManagement;
  final String option1;
  final String option2;
  final String option3;
  final String createdAt;
  final String updatedAt;
  final bool taxable;
  final String barcode;
  final int grams;
  var imageId;
  final double weight;
  final String weightUnit;
  final int inventoryItemId;
  final int inventoryQuantity;
  final int oldInventoryQuantity;
  final bool requiresShipping;
  final String adminGraphqlApiId;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.sku,
    required this.position,
    required this.inventoryPolicy,
    required this.compareAtPrice,
    required this.fulfillmentService,
    required this.inventoryManagement,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.createdAt,
    required this.updatedAt,
    required this.taxable,
    required this.barcode,
    required this.grams,
    required this.imageId,
    required this.weight,
    required this.weightUnit,
    required this.inventoryItemId,
    required this.inventoryQuantity,
    required this.oldInventoryQuantity,
    required this.requiresShipping,
    required this.adminGraphqlApiId,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.megentoCommerce) {
      log('MegentoVareient model');
      return MegentoProductVariant.fromJson(json);
    } else if (AppConfigure.wooCommerce) {
      log('WooCommerce model');
      return WooCommerceProductVariant.fromJson(json);
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceProductVariant.fromJson(json);
    } else {
      return ShopifyProductVariant.fromJson(json);
    }
  }
}

class ProductOption {
  final int id;
  final int productId;
  final String name;
  final int position;
  final List<String> values;

  ProductOption({
    required this.id,
    required this.productId,
    required this.name,
    required this.position,
    required this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.wooCommerce) {
      log('WooCommerce model');
      return WooCommerceProductOption.fromJson(json);
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceProductOption.fromJson(json);
    } else {
      return ShopifyProductOption.fromJson(json);
    }
  }
}

class ProductImage {
  final int id;
  final int productId;
  final int position;
  final String createdAt;
  final String updatedAt;
  final String alt;
  final int width;
  final int height;
  final String src;
  final List<int> variantIds;
  final String adminGraphqlApiId;

  ProductImage({
    required this.id,
    required this.productId,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.alt,
    required this.width,
    required this.height,
    required this.src,
    required this.variantIds,
    required this.adminGraphqlApiId,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    if (AppConfigure.megentoCommerce) {
      log('MegentoProductImage model');
      return MegentoProductImage.fromJson(json);
    } else if (AppConfigure.wooCommerce) {
      log('WooCommerce model');
      return WooCommerceProductImage.fromJson(json);
    } else if (AppConfigure.bigCommerce) {
      return BigCommerceProductImage.fromJson(json);
    } else {
      return ShopifyProductImage.fromJson(json);
    }
  }
}
