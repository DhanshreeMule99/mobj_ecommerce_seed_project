class WishlistProductModel {
  final String id;
  final int entityId;
  final String name;
  final Prices prices;
  final DefaultImage defaultImage;

  WishlistProductModel({
    required this.id,
    required this.entityId,
    required this.name,
    required this.prices,
    required this.defaultImage,
  });

  factory WishlistProductModel.fromJson(Map<String, dynamic> json) {
    return WishlistProductModel(
      id: json['id'],
      entityId: json['entityId'],
      name: json['name'],
      prices: Prices.fromJson(json['prices']),
      defaultImage: DefaultImage.fromJson(json['defaultImage']),
    );
  }
}

class Prices {
  final Price price;
  final Price? salePrice;
  final Price basePrice;
  final Price? retailPrice;

  Prices({
    required this.price,
    this.salePrice,
    required this.basePrice,
    this.retailPrice,
  });

  factory Prices.fromJson(Map<String, dynamic> json) {
    return Prices(
      price: Price.fromJson(json['price']),
      salePrice: json['salePrice'] != null ? Price.fromJson(json['salePrice']) : null,
      basePrice: Price.fromJson(json['basePrice']),
      retailPrice: json['retailPrice'] != null ? Price.fromJson(json['retailPrice']) : null,
    );
  }
}

class Price {
  final String currencyCode;
  final double value;

  Price({
    required this.currencyCode,
    required this.value,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currencyCode: json['currencyCode'],
      value: json['value'].toDouble(),
    );
  }
}

class DefaultImage {
  final String url;
  final String urlOriginal;
  final String altText;
  final bool isDefault;

  DefaultImage({
    required this.url,
    required this.urlOriginal,
    required this.altText,
    required this.isDefault,
  });

  factory DefaultImage.fromJson(Map<String, dynamic> json) {
    return DefaultImage(
      url: json['url'],
      urlOriginal: json['urlOriginal'],
      altText: json['altText'],
      isDefault: json['isDefault'],
    );
  }
}



