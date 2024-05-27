import 'package:mobj_project/models/product/productModel.dart';

import '../../utils/defaultValues.dart';
import '../bigcommerce_models/bigcommerce_proudct_model.dart';

class MengentoProductModel implements ProductModel {
  @override
  final int id;
  final int price;
  final String sku;
  final int attribute_set_id;
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
  final List<MegentoProductVariant> variants;
  @override
  final List<BigCommerceProductOption> options;
  @override
  final List<MegentoProductImage> images;
  @override
  final MegentoProductImage image;

  MengentoProductModel({
    required this.id,
    required this.price,
    required this.title,
    required this.bodyHtml,
    required this.vendor,
    required this.productType,
    required this.createdAt,
    required this.handle,
    required this.updatedAt,
    required this.publishedAt,
    required this.templateSuffix,
    required this.publishedScope,
    required this.tags,
    required this.status,
    required this.adminGraphqlApiId,
    required this.variants,
    required this.options,
    required this.images,
    required this.image,
    required this.sku,
    required this.attribute_set_id,
  });

  factory MengentoProductModel.fromJson(Map<String, dynamic> json) {
    return MengentoProductModel(
        id: json['id'] ?? DefaultValues.defaultId,
        price: json['price'] ?? DefaultValues.defaultId,
        sku: json['sku'] ?? DefaultValues.defaultSku,
        attribute_set_id: json['attribute_set_id'] ?? DefaultValues.defaultId,
        title: json['name'] ?? DefaultValues.defaultTitle,
        bodyHtml: json['custom_attributes'][0]['value'] ??
            DefaultValues.defaultBodyHtml,
        vendor: DefaultValues.defaultVendor,
        productType: json[''] ?? DefaultValues.defaultProductType,
        createdAt: json['created_at'] ?? DefaultValues.defaultCreatedAt,
        handle: json[''] ?? DefaultValues.defaultHandle,
        updatedAt: json['updated_at'] ?? DefaultValues.defaultUpdatedAt,
        publishedAt: json['updated_at'] ?? DefaultValues.defaultPublishedAt,
        templateSuffix: DefaultValues.defaultTemplateSuffix,
        publishedScope: DefaultValues.defaultPublishedScope,
        tags: DefaultValues.defaultTags,
        status: json['status'].toString(),
        adminGraphqlApiId: json[''] ?? DefaultValues.defaultAdminGraphqlApiId,
        //  variants: (json['variants'] as List<dynamic>?)
        //         ?.map((variantJson) => BigCommerceProductVariant.fromJson(
        //             variantJson as Map<String, dynamic>))
        //         .toList() ??
        //     DefaultValues.defaultVariants.cast<BigCommerceProductVariant>(),
        variants: json['extension_attributes']
                .map((variantJson) => MegentoProductVariant.fromJson(
                    variantJson as Map<String, dynamic>))
                .toList() ??
            DefaultValues.defaultVariants.cast<MegentoProductVariant>(),
        // variants: DefaultValues.defaultVariants.cast<MegentoProductVariant>(),
        options: (json[''] as List<dynamic>?)
                ?.map((optionJson) => BigCommerceProductOption.fromJson(
                    optionJson as Map<String, dynamic>))
                .toList() ??
            DefaultValues.defaultVariants.cast<BigCommerceProductOption>(),
        images: (json['media_gallery_entries'] as List<dynamic>?)
                ?.map((imageJson) => MegentoProductImage.fromJson(imageJson))
                .toList() ??
            DefaultValues.defaultImagesMegento.cast<MegentoProductImage>(),
        image:
            MegentoProductImage.fromJson(json[''] as Map<String, dynamic>? ?? {}));
  }
}

class MegentoProductImage implements ProductImage {
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

  MegentoProductImage({
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

  factory MegentoProductImage.fromJson(Map<String, dynamic> json) {
    return MegentoProductImage(
      id: json[''] ?? DefaultValues.defaultImagesId,
      productId: json[''] ?? DefaultValues.defaultImagesProductId,
      position: json[''] ?? DefaultValues.defaultImagesPosition,
      createdAt: json[''] ?? DefaultValues.defaultImagesCreatedAt,
      updatedAt: json[''] ?? DefaultValues.defaultImagesUpdatedAt,
      alt: json[''] ?? DefaultValues.defaultImagesAlt,
      width: json[''] ?? DefaultValues.defaultImagesWidth,
      height: json[''] ?? DefaultValues.defaultImagesHeight,
      src: json['file'] ?? DefaultValues.defaultImagesSrc,
      variantIds:
          (json[''] as List<dynamic>?)?.map((id) => id as int).toList() ??
              DefaultValues.defaultImagesVariantIds,
      adminGraphqlApiId:
          json[''] ?? DefaultValues.defaultImagesAdminGraphqlApiId,
    );
  }
}

class MegentoProductVariant implements ProductVariant {
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

  MegentoProductVariant({
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

  factory MegentoProductVariant.fromJson(Map<String, dynamic> json) {
    return MegentoProductVariant(
      id: json[''] ?? DefaultValues.defaultId,
      productId: json[''] ?? DefaultValues.defaultProductId,
      title: json[''] ?? DefaultValues.defaultTitle,
      price: json[''].toString() ?? DefaultValues.defaultPrice,
      sku: json[''].toString() ?? DefaultValues.defaultSku,
      position: json[''] ?? DefaultValues.defaultPosition,
      inventoryPolicy: json[''] ?? DefaultValues.defaultInventoryPolicy,
      compareAtPrice:
          json[''].toString() ?? DefaultValues.defaultCompareAtPrice,
      fulfillmentService: "" ?? DefaultValues.defaultFulfillmentService,
      inventoryManagement: "" ?? DefaultValues.defaultInventoryManagement,
      option1: DefaultValues.defaultOption1
          // json['option_values'][0]['label'] ?? DefaultValues.defaultOption1
          ??
          DefaultValues.defaultOption1,
      option2: json[''] ?? DefaultValues.defaultOption2,
      option3: json[''] ?? DefaultValues.defaultOption3,
      createdAt: json[''] ?? DefaultValues.defaultCreatedAt,
      updatedAt: json[''] ?? DefaultValues.defaultUpdatedAt,
      taxable: json[''] ?? DefaultValues.defaultTaxable,
      barcode: json[''] ?? DefaultValues.defaultBarcode,
      grams: json[''] ?? DefaultValues.defaultGrams,
      imageId: json[''] ?? DefaultValues.defaultImageId,
      weight:
          json[''] == null ? DefaultValues.defaultWeight : json[''].toDouble(),
      weightUnit: json[''] ?? DefaultValues.defaultWeightUnit,
      inventoryItemId: json[''] ?? DefaultValues.defaultInventoryItemId,
      inventoryQuantity: json['extension_attributes']['stock_item']['qty'] ??
          DefaultValues.defaultInventoryQuantity,
      oldInventoryQuantity:
          json[''] ?? DefaultValues.defaultOldInventoryQuantity,
      requiresShipping: json[''] ?? DefaultValues.defaultRequiresShipping,
      adminGraphqlApiId: json[''] ?? DefaultValues.defaultAdminGraphqlApiId,
    );
  }
}
