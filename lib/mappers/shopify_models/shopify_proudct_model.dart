import 'package:mobj_project/utils/defaultValues.dart';

import '../../models/product/productModel.dart';

class ShopifyProductModel implements ProductModel {
  @override
  final int id;
  @override
  final String title;
  @override
  final String bodyHtml;
  @override
  final String vendor;
  @override
  final String productType;
  @override
  final String createdAt;
  @override
  final String handle;
  @override
  final String updatedAt;
  @override
  final String publishedAt;
  @override
  final String templateSuffix;
  @override
  final String publishedScope;
  @override
  final String tags;
  @override
  final String status;
  @override
  final String adminGraphqlApiId;
  @override
  final List<ShopifyProductVariant> variants;
  @override
  final List<ShopifyProductOption> options;
  @override
  final List<ShopifyProductImage> images;
  @override
  final ShopifyProductImage image;

  ShopifyProductModel({
    required this.id,
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

  factory ShopifyProductModel.fromJson(Map<String, dynamic> json) {
    return ShopifyProductModel(
      id: json['id'] ?? DefaultValues.defaultId,
      // Default value for id
      title: json['title'] ?? DefaultValues.defaultTitle,
      // Default value for title
      bodyHtml: json['body_html'] ?? DefaultValues.defaultBodyHtml,
      vendor: json['vendor'] ?? DefaultValues.defaultVendor,
      productType: json['product_type'] ?? DefaultValues.defaultProductType,
      createdAt: json['created_at'] ?? DefaultValues.defaultCreatedAt,
      handle: json['handle'] ?? DefaultValues.defaultHandle,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultUpdatedAt,
      publishedAt: json['published_at'] ?? DefaultValues.defaultPublishedAt,
      templateSuffix:
          json['template_suffix'] ?? DefaultValues.defaultTemplateSuffix,
      publishedScope:
          json['published_scope'] ?? DefaultValues.defaultPublishedScope,
      tags: json['tags'] ?? DefaultValues.defaultTags,
      status: json['status'] ?? DefaultValues.defaultStatus,
      adminGraphqlApiId: json['admin_graphql_api_id'] ??
          DefaultValues.defaultAdminGraphqlApiId,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((variantJson) => ShopifyProductVariant.fromJson(
                  variantJson as Map<String, dynamic>))
              .toList() ??
          DefaultValues.defaultVariants.cast<ShopifyProductVariant>(),
      options: (json['options'] as List<dynamic>?)
              ?.map((optionJson) => ShopifyProductOption.fromJson(
                  optionJson as Map<String, dynamic>))
              .toList() ??
          DefaultValues.defaultOptions.cast<ShopifyProductOption>(),
      images: (json['images'] as List<dynamic>?)
              ?.map((imageJson) => ShopifyProductImage.fromJson(
                  imageJson as Map<String, dynamic>))
              .toList() ??
          DefaultValues.defaultImages.cast<ShopifyProductImage>(),
      image: ShopifyProductImage.fromJson(
          json['image'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  // TODO: implement price
  int get price => throw UnimplementedError();
}

class ShopifyProductVariant implements ProductVariant {
  @override
  final int id;
  @override
  final int productId;
  @override
  final String title;
  @override
  final String price;
  @override
  final String sku;
  @override
  final int position;
  @override
  final String inventoryPolicy;
  @override
  final String compareAtPrice;
  @override
  final String fulfillmentService;
  @override
  final String inventoryManagement;
  @override
  final String option1;
  @override
  final String option2;
  @override
  final String option3;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final bool taxable;
  @override
  final String barcode;
  @override
  final int grams;
  @override
  var imageId;
  @override
  final double weight;
  @override
  final String weightUnit;
  @override
  final int inventoryItemId;
  @override
  final int inventoryQuantity;
  @override
  final int oldInventoryQuantity;
  @override
  final bool requiresShipping;
  @override
  final String adminGraphqlApiId;

  ShopifyProductVariant({
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

  factory ShopifyProductVariant.fromJson(Map<String, dynamic> json) {
    return ShopifyProductVariant(
      id: json['id'] ?? DefaultValues.defaultId,
      productId: json['product_id'] ?? DefaultValues.defaultProductId,
      title: json['title'] ?? DefaultValues.defaultTitle,
      price: json['price'] ?? DefaultValues.defaultPrice,
      sku: json['sku'] ?? DefaultValues.defaultSku,
      position: json['position'] ?? DefaultValues.defaultPosition,
      inventoryPolicy:
          json['inventory_policy'] ?? DefaultValues.defaultInventoryPolicy,
      compareAtPrice:
          json['compare_at_price'] ?? DefaultValues.defaultCompareAtPrice,
      fulfillmentService: json['fulfillment_service'] ??
          DefaultValues.defaultFulfillmentService,
      inventoryManagement: json['inventory_management'] ??
          DefaultValues.defaultInventoryManagement,
      option1: json['option1'] ?? DefaultValues.defaultOption1,
      option2: json['option2'] ?? DefaultValues.defaultOption2,
      option3: json['option3'] ?? DefaultValues.defaultOption3,
      createdAt: json['created_at'] ?? DefaultValues.defaultCreatedAt,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultUpdatedAt,
      taxable: json['taxable'] ?? DefaultValues.defaultTaxable,
      barcode: json['barcode'] ?? DefaultValues.defaultBarcode,
      grams: json['grams'] ?? DefaultValues.defaultGrams,
      imageId: json['image_id'] ?? DefaultValues.defaultImageId,
      weight: json['weight'] ?? DefaultValues.defaultWeight,
      weightUnit: json['weight_unit'] ?? DefaultValues.defaultWeightUnit,
      inventoryItemId:
          json['inventory_item_id'] ?? DefaultValues.defaultInventoryItemId,
      inventoryQuantity:
          json['inventory_quantity'] ?? DefaultValues.defaultInventoryQuantity,
      oldInventoryQuantity: json['old_inventory_quantity'] ??
          DefaultValues.defaultOldInventoryQuantity,
      requiresShipping:
          json['requires_shipping'] ?? DefaultValues.defaultRequiresShipping,
      adminGraphqlApiId: json['admin_graphql_api_id'] ??
          DefaultValues.defaultAdminGraphqlApiId,
    );
  }
}

class ShopifyProductOption implements ProductOption {
  @override
  final int id;
  @override
  final int productId;
  @override
  final String name;
  @override
  final int position;
  @override
  final List<String> values;

  ShopifyProductOption({
    required this.id,
    required this.productId,
    required this.name,
    required this.position,
    required this.values,
  });

  factory ShopifyProductOption.fromJson(Map<String, dynamic> json) {
    return ShopifyProductOption(
      id: json['id'] ?? DefaultValues.defaultOptionId,
      productId: json['product_id'] ?? DefaultValues.defaultOptionProductId,
      name: json['name'] ?? DefaultValues.defaultOptionName,
      position: json['position'] ?? DefaultValues.defaultOptionPosition,
      values: (json['values'] as List<dynamic>?)
              ?.map((value) => value.toString())
              .toList() ??
          DefaultValues.defaultOptionValues,
    );
  }
}

class ShopifyProductImage implements ProductImage {
  @override
  final int id;
  @override
  final int productId;
  @override
  final int position;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String alt;
  @override
  final int width;
  @override
  final int height;
  @override
  final String src;
  @override
  final List<int> variantIds;
  @override
  final String adminGraphqlApiId;

  ShopifyProductImage({
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

  factory ShopifyProductImage.fromJson(Map<String, dynamic> json) {
    return ShopifyProductImage(
      id: json['id'] ?? DefaultValues.defaultImagesId,
      productId: json['product_id'] ?? DefaultValues.defaultImagesProductId,
      position: json['position'] ?? DefaultValues.defaultImagesPosition,
      createdAt: json['created_at'] ?? DefaultValues.defaultImagesCreatedAt,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultImagesUpdatedAt,
      alt: json['alt'] ?? DefaultValues.defaultImagesAlt,
      width: json['width'] ?? DefaultValues.defaultImagesWidth,
      height: json['height'] ?? DefaultValues.defaultImagesHeight,
      src: json['src'] ?? DefaultValues.defaultImagesSrc,
      variantIds: (json['variant_ids'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          DefaultValues.defaultImagesVariantIds,
      adminGraphqlApiId: json['admin_graphql_api_id'] ??
          DefaultValues.defaultImagesAdminGraphqlApiId,
    );
  }
}
