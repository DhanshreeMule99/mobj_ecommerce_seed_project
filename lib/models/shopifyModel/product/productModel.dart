import 'package:mobj_project/utils/defaultValues.dart';

class ProductModel {
  final int id;
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

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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
          ?.map((variantJson) => ProductVariant.fromJson(variantJson as Map<String, dynamic>))
          .toList() ??
          DefaultValues.defaultVariants,
      options: (json['options'] as List<dynamic>?)
          ?.map((optionJson) => ProductOption.fromJson(optionJson as Map<String, dynamic>))
          .toList() ??
          DefaultValues.defaultOptions,
      images: (json['images'] as List<dynamic>?)
          ?.map((imageJson) => ProductImage.fromJson(imageJson as Map<String, dynamic>))
          .toList() ??
          DefaultValues.defaultImages,
      image: ProductImage.fromJson(json['image'] as Map<String, dynamic>? ?? {}),
    );
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
  final int imageId;
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
    return ProductVariant(
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
    return ProductOption(
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
    return ProductImage(
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
