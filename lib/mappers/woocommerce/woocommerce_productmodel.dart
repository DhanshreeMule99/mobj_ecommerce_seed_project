import '../../models/product/productModel.dart';
import '../../utils/defaultValues.dart';

class WooCommerceProductModel implements ProductModel {
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
  // final String adminGraphqlApiId;
  @override
  final List<WooCommerceProductVariant> variants;
  // @override
  // final List<WooCommerceProductOption> options;
  // @override
  // final List<WooCommerceProductImage> images;
  // @override
  final WooCommerceProductImage image;

  WooCommerceProductModel({
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
    // required this.adminGraphqlApiId,
    required this.variants,
    // required this.options,
    // required this.images,
    required this.image,
  });

  factory WooCommerceProductModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? variationsJson = json['variations'] as List<dynamic>?;

    List<WooCommerceProductVariant> variants = [];
    if (variationsJson != null) {
      for (int variationId in variationsJson) {
        variants.add(WooCommerceProductVariant(
          id: variationId, // Set variation ID
          productId:
              json['id'] ?? DefaultValues.defaultProductId, // Set product ID
          // Set other default values or leave them as needed
          title: DefaultValues.defaultTitle,
          price: json['price'] ?? DefaultValues.defaultPrice,
          sku: DefaultValues.defaultSku,
          position: DefaultValues.defaultPosition,
          inventoryPolicy: DefaultValues.defaultInventoryPolicy,
          compareAtPrice: DefaultValues.defaultCompareAtPrice,
          fulfillmentService: DefaultValues.defaultFulfillmentService,
          inventoryManagement: DefaultValues.defaultInventoryManagement,
          option1: DefaultValues.defaultOption1,
          option2: DefaultValues.defaultOption2,
          option3: DefaultValues.defaultOption3,
          createdAt: DefaultValues.defaultCreatedAt,
          updatedAt: DefaultValues.defaultUpdatedAt,
          taxable: DefaultValues.defaultTaxable,
          barcode: DefaultValues.defaultBarcode,
          grams: DefaultValues.defaultGrams,
          imageId: DefaultValues.defaultImageId,
          weight: DefaultValues.defaultWeight,
          weightUnit: DefaultValues.defaultWeightUnit,
          inventoryItemId: DefaultValues.defaultInventoryItemId,
          inventoryQuantity:
              json['stock_quantity'] ?? DefaultValues.defaultInventoryQuantity,
          oldInventoryQuantity: DefaultValues.defaultOldInventoryQuantity,
          requiresShipping: DefaultValues.defaultRequiresShipping,
          adminGraphqlApiId: DefaultValues.defaultAdminGraphqlApiId,
        ));
      }
    }
    return WooCommerceProductModel(
        id: json['id'] ?? DefaultValues.defaultId,
        // Default value for id
        title: json['name'] ?? DefaultValues.defaultTitle,
        // Default value for title
        bodyHtml: json['description'] ?? DefaultValues.defaultBodyHtml,
        vendor: DefaultValues.defaultVendor,
        productType: json['type'] ?? DefaultValues.defaultProductType,
        createdAt: json['date_created'] ?? DefaultValues.defaultCreatedAt,
        handle: json['name'] ?? DefaultValues.defaultHandle,
        updatedAt: json['date_modified'] ?? DefaultValues.defaultUpdatedAt,
        publishedAt: json['date_created'] ?? DefaultValues.defaultPublishedAt,
        templateSuffix: DefaultValues.defaultTemplateSuffix,
        publishedScope: DefaultValues.defaultPublishedScope,
        tags: DefaultValues.defaultTags,
        status: json['status'].toString(),
        // adminGraphqlApiId:
        //     json['custom_url'][''] ?? DefaultValues.defaultAdminGraphqlApiId,
        variants: variants ??
            DefaultValues.defaultVariants.cast<WooCommerceProductVariant>(),
        // options: (json['options'] as List<dynamic>?)
        //         ?.map((optionJson) => WooCommerceProductOption.fromJson(
        //             optionJson as Map<String, dynamic>))
        //         .toList() ??
        //     DefaultValues.defaultVariants.cast<WooCommerceProductOption>(),
        // images: (json['images'] as List<dynamic>?)
        //         ?.map((imageJson) => WooCommerceProductImage.fromJson(imageJson as Map<String, dynamic>))
        //         .toList() ??
        //     DefaultValues.defaultVariants.cast<WooCommerceProductImage>(),
        image: WooCommerceProductImage(
            src: json['images'][0]["src"],
            id: json['images'][0]['id'],
            productId: json['images'][0]['id'],
            position: 0,
            createdAt: '',
            updatedAt: '',
            alt: '',
            width: 0,
            height: 0,
            variantIds: [],
            adminGraphqlApiId: ''));
    //  WooCommerceProductImage.fromJson(
    //     json['images'] as Map<String, dynamic>? ?? {}));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class WooCommerceProductImage implements ProductImage {
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

  WooCommerceProductImage({
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

  factory WooCommerceProductImage.fromJson(Map<String, dynamic> json) {
    return WooCommerceProductImage(
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

class WooCommerceProductVariant implements ProductVariant {
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

  WooCommerceProductVariant({
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

  factory WooCommerceProductVariant.fromJson(Map<String, dynamic> json) {
    return WooCommerceProductVariant(
      id: json['id'] ?? DefaultValues.defaultId,
      productId: json['product_id'] ?? DefaultValues.defaultProductId,
      title: json['title'] ?? DefaultValues.defaultTitle,
      price: json['calculated_price'].toString() ?? DefaultValues.defaultPrice,
      sku: json['sku_id'].toString() ?? DefaultValues.defaultSku,
      position: json['position'] ?? DefaultValues.defaultPosition,
      inventoryPolicy:
          json['inventory_policy'] ?? DefaultValues.defaultInventoryPolicy,
      compareAtPrice: json['retail_price'].toString() ??
          DefaultValues.defaultCompareAtPrice,
      fulfillmentService: "" ?? DefaultValues.defaultFulfillmentService,
      inventoryManagement: "" ?? DefaultValues.defaultInventoryManagement,
      option1: DefaultValues.defaultOption1
          // json['option_values'][0]['label'] ?? DefaultValues.defaultOption1
          ??
          DefaultValues.defaultOption1,
      option2: json['option2'] ?? DefaultValues.defaultOption2,
      option3: json['option3'] ?? DefaultValues.defaultOption3,
      createdAt: json['created_at'] ?? DefaultValues.defaultCreatedAt,
      updatedAt: json['updated_at'] ?? DefaultValues.defaultUpdatedAt,
      taxable: json['taxable'] ?? DefaultValues.defaultTaxable,
      barcode: json['barcode'] ?? DefaultValues.defaultBarcode,
      grams: json['grams'] ?? DefaultValues.defaultGrams,
      imageId: json['image_url'] ?? DefaultValues.defaultImageId,
      weight: json['weight'] == null
          ? DefaultValues.defaultWeight
          : json['weight'].toDouble(),
      weightUnit: json['weight_unit'] ?? DefaultValues.defaultWeightUnit,
      inventoryItemId:
          json['inventory_item_id'] ?? DefaultValues.defaultInventoryItemId,
      inventoryQuantity:
          json['inventory_level'] ?? DefaultValues.defaultInventoryQuantity,
      oldInventoryQuantity: json['old_inventory_quantity'] ??
          DefaultValues.defaultOldInventoryQuantity,
      requiresShipping:
          json['requires_shipping'] ?? DefaultValues.defaultRequiresShipping,
      adminGraphqlApiId: json['sku'] ?? DefaultValues.defaultAdminGraphqlApiId,
    );
  }
}

class WooCommerceProductOption implements ProductOption {
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

  WooCommerceProductOption({
    required this.id,
    required this.productId,
    required this.name,
    required this.position,
    required this.values,
  });

  factory WooCommerceProductOption.fromJson(Map<String, dynamic> json) {
    return WooCommerceProductOption(
      id: json['id'] ?? DefaultValues.defaultOptionId,
      productId: json['product_id'] ?? DefaultValues.defaultOptionProductId,
      name: json['name'] ?? DefaultValues.defaultOptionName,
      position: json['position'] ?? DefaultValues.defaultOptionPosition,
      values: (json['option_values'] as List<dynamic>)
              .map((optionValue) => optionValue['label'] as String)
              .toList() ??
          DefaultValues.defaultOptionValues,
    );
  }
}
