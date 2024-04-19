// productRepository

import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:mobj_project/utils/api.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  List<ProductModel> empty = [];
  API api = API();

  Future<List<ProductModel>> getProducts() async {
    try {
      debugPrint('calling api');
      final response = await ApiManager.get(AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.product);

      // final response = await ApiManager.get(
      //     '${AppConfigure.bigcommerceUrl}/catalog/products?include=images,variants,options');

      if (response.statusCode == APIConstants.successCode) {
        final List result = AppConfigure.bigCommerce == true
            ? jsonDecode(response.body)['data']
            : jsonDecode(response.body)['products'];

        return result.map((e) => ProductModel.fromJson(e)).toList();
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        debugPrint("empty data here");
        throw (AppString.noDataError);
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        debugPrint("empty data here unauthorized");
        throw AppString.unAuthorized;
      } else {
        return empty;
      }
    } catch (error, stackTrace) {
      debugPrint("error is this $error $stackTrace");
      throw error;
    }
  }

  Future<ProductVariant> getProductsByVariantId(String vid, String pid) async {
    try {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      final response = await ApiManager.get(
          "$BASE_URL${APIConstants.productDetails}/$pid/${APIConstants.variants}/$vid.json");
      if (response.statusCode == APIConstants.successCode) {
        final result = jsonDecode(response.body)['variant'];
        return ProductVariant.fromJson(result);
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        throw (AppString.noDataError);
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        throw AppString.unAuthorized;
      } else {
        throw AppString.oops;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<ProductModel> getProductInfo(String pid) async {
    try {
      String BASE_URL = AppConfigure.bigCommerce == true
          ? AppConfigure.baseUrl +
              APIConstants.apiForAdminURL +
              APIConstants.apiURL
          : AppConfigure.baseUrl +
              APIConstants.apiForAdminURL +
              APIConstants.apiURL;
      debugPrint(BASE_URL + pid);
      final response = AppConfigure.bigCommerce == true
          ? await ApiManager.get(
              "$BASE_URL/products/$pid?include=images,variants,options,images")
          : await ApiManager.get(
              "$BASE_URL${APIConstants.productDetails}/$pid.json");
      if (response.statusCode == APIConstants.successCode) {
        final userData = AppConfigure.bigCommerce == true
            ? jsonDecode(response.body)['data']
            : jsonDecode(response.body)['product'];
        return ProductModel.fromJson(userData);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error, stackTrace) {
      print("$error + $stackTrace");
      throw error;
    }
  }

  Future<ProductRatingModel> getProductRating(String pid) async {
    try {
      String BASE_URL = AppConfigure.feraUrl;

      final response = await ApiManager.get(
          "${BASE_URL}products/$pid/${APIConstants.ratingProduct}");

      if (response.statusCode == APIConstants.successCode) {
        final userData = json.decode(response.body);
        return ProductRatingModel.fromJson(userData);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<ReviewProductModels> getProductReviews(String pid) async {
    API api = API();

    try {
      Response response = await api.sendRequest.get(
        AppConfigure.bigCommerce
            ? '${AppConfigure.bigcommerceUrl}/catalog/products/$pid/reviews'
            : "https://judge.me/api/v1/reviews?external_id=$pid&api_token=m44Byd6k-flMjTk63lQHuhkPsFs&shop_domain=b8507f-9a.myshopify.com",
      );
      if (response.statusCode == APIConstants.successCode) {
        var result = response.data;
        return ReviewProductModels.fromJson(result);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error, stackTrace) {
      debugPrint('print error is this $error $stackTrace');
      throw error;
    }
  }

  Future<List<ProductImage>> getProductImage(String pid) async {
    try {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      final response = await ApiManager.get(
          "$BASE_URL${APIConstants.productDetails}/$pid/${APIConstants.images}");
      if (response.statusCode == APIConstants.successCode) {
        final List result = jsonDecode(response.body)['images'];
        return result.map((e) => ProductImage.fromJson(e)).toList();
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<RecommendedProductModel>> getRecommendedProductInfo(
      String pid) async {
    try {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      final response = await ApiManager.get(
          "${AppConfigure.baseUrl}${APIConstants.recommendations}/${APIConstants.product}?product_id=$pid");
      if (response.statusCode == APIConstants.successCode) {
        final List result = jsonDecode(response.body)['products'];
        return result.map((e) => RecommendedProductModel.fromJson(e)).toList();
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<ProductModel>> getProductsByCollection(
      String colllectionId) async {
    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiForAdminURL;
      final response = await ApiManager.get(
          "$BASE_URL${APIConstants.collectionProduct}/$colllectionId/${APIConstants.product}");
      if (response.statusCode == APIConstants.successCode) {
        final List result = jsonDecode(response.body)['products'];
        return result.map((e) => ProductModel.fromJson(e)).toList();
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        throw (AppString.noDataError);
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        throw AppString.unAuthorized;
      } else {
        return empty;
      }
    } catch (error) {
      throw error;
    }
  }

  addToCart(String variantId, String quantity) async {
    String exceptionString = "";
    String uid = await SharedPreferenceManager().getUserId();
    debugPrint('$uid $variantId');

    var body = jsonEncode({
      "draft_order": {
        "line_items": [
          {"variant_id": variantId, "quantity": quantity}
        ],
        "customer": {"id": uid}
      }
    });
    var decodedBody = jsonDecode(body);
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    debugPrint(BASE_URL + '${APIConstants.draftProduct}');
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        debugPrint('darftId is this $draftId');
        var response;
        if (draftId == "") {
          response = await ApiManager.post(
              "$BASE_URL${APIConstants.draftProduct}", body);
        } else {
          var value = await getCartDetails(); // await the result here
          if (value.toString() != AppString.error ||
              value.toString() != AppString.noDataError) {
            if (value.lineItems.isNotEmpty) {
              final lineItemsList = value.lineItems;
              debugPrint('values lineItemslist is this $lineItemsList');
              for (int i = 0; i <= value.lineItems.length - 1; i++) {
                decodedBody["draft_order"]["line_items"].add({
                  "variant_id": lineItemsList[i].variantId,
                  "quantity": lineItemsList[i].quantity
                });
              }
              final lineItems = decodedBody['draft_order']['line_items'];
              final uniqueVariants = {};
              lineItems.forEach((item) {
                int variantId = int.parse(item['variant_id'].toString());
                int quantity = int.parse(item['quantity'].toString());
                //
                if (uniqueVariants.containsKey(variantId)) {
                  // If the variant ID already exists, add the quantity
                  uniqueVariants[variantId] =
                      uniqueVariants[variantId]! + quantity;
                } else {
                  // If the variant ID is new, add it to the map
                  uniqueVariants[variantId] = quantity;
                }
              });
              // // Clear the original line items
              lineItems.clear();
              uniqueVariants.forEach((variantId, quantity) {
                lineItems.add({
                  'variant_id': variantId,
                  'quantity': quantity,
                });
              });
            }

            body = jsonEncode(decodedBody);
            response = await ApiManager.put(
                "$BASE_URL${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId.json",
                body);
            debugPrint('add to cart response is this $response');
          }
        }
        var data = jsonDecode(response.body);

        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          if (draftId == "") {
            await SharedPreferenceManager()
                .setDraftId(data["draft_order"]["id"].toString());
          }
          return AppString.success;
        } else {
          exceptionString = AppString.oops;
          return exceptionString;
        }
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
    }
  }

  addToCartBigcommerce(String variantId, String quantity, String name,
      String price, String productId) async {
    String exceptionString = "";
    String uid = await SharedPreferenceManager().getUserId();
    debugPrint('$uid $variantId');

    var body = jsonEncode({
      "customer_id": int.parse(uid),
      "line_items": [
        {
          "quantity": int.parse(quantity),
          "product_id": int.parse(productId),
          "list_price": int.parse(price),
          "name": name,
          "variant_id": int.parse(variantId)
        }
      ],
      "currency": {"code": "INR"},
      "locale": "en-US"
    });
    var decodedBody = jsonDecode(body);
    String BASE_URL = AppConfigure.baseUrl;
    debugPrint(BASE_URL + '${APIConstants.draftProduct}');
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        debugPrint('darftId is this $draftId');
        var response;
        if (draftId == "") {
          response = await ApiManager.post("$BASE_URL/carts", body);
        } else {
          response =
              await ApiManager.post("$BASE_URL/carts/$draftId/items", body);
        }
        var data = jsonDecode(response.body);
        debugPrint('add to cart data is this $data');

        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          if (draftId == "") {
            await SharedPreferenceManager()
                .setDraftId(data["data"]["id"].toString());
            debugPrint(
                'cart id is this bigcommerce ${data["data"]["id"].toString()}');
          }
          return AppString.success;
        } else {
          exceptionString = AppString.oops;
          return exceptionString;
        }
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
    }
  }

  repeatOrder(Map<String, dynamic> reqBody) async {
    String exceptionString = "";

    var body = jsonEncode(reqBody);
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        var response;
        response = await ApiManager.post(
            "$BASE_URL${APIConstants.draftProduct}", body);

        body = jsonEncode(body);
        var data = jsonDecode(response.body);

        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          return data["draft_order"]["id"].toString();
        } else {
          exceptionString = AppString.oops;
          return exceptionString;
        }
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
    }
  }

  addProductReview(addReviewBody, String pid) async {
    String exceptionString = "";
    API api = API();

    //if (AppConfigure.bigCommerce) {
    debugPrint("adding review for products");
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await api.sendRequest.post(
          "/catalog/products/$pid/reviews",
          data: addReviewBody,
        );

        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          return AppString.success;
        } else if (response.statusCode == APIConstants.alreadyExistCode) {
          return AppString.alreadyReview;
        } else {
          exceptionString = AppString.oops;
          return exceptionString;
        }
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
    }
    // }
    //  else {
    //   var body = jsonEncode(addReviewBody);
    //   String BASE_URL = AppConfigure.feraUrl;
    //   try {
    //     if (await ConnectivityUtils.isNetworkConnected()) {
    //       print("$BASE_URL/${APIConstants.reviewProduct}");
    //       final response = await ApiManager.post(
    //           "$BASE_URL/${APIConstants.reviewProduct}", body);
    //       var data = jsonDecode(response.body);

    //       if (response.statusCode == APIConstants.successCode ||
    //           response.statusCode == APIConstants.successCreateCode) {
    //         return AppString.success;
    //       } else if (response.statusCode == APIConstants.alreadyExistCode) {
    //         return AppString.alreadyReview;
    //       } else {
    //         exceptionString = AppString.oops;
    //         return exceptionString;
    //       }
    //     }
    //   } catch (error) {
    //     exceptionString = AppString.oops;
    //     return exceptionString;
    //   }
    // }
  }

  updateCart(List<dynamic> reqBody) async {
    String exceptionString = "";
    String draftId = await SharedPreferenceManager().getDraftId();
    String uid = await SharedPreferenceManager().getUserId();
    var body = jsonEncode({
      "draft_order": {
        "line_items": reqBody,
        "customer": {"id": uid}
      }
    });
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        var response;
        response = await ApiManager.put(
            "$BASE_URL${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId.json",
            body);

        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          if (draftId != "") {
            await SharedPreferenceManager()
                .setDraftId(data["draft_order"]["id"].toString());
          }

          return AppString.success;
        }
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
    }
  }

  checkoutTransaction(String orderId, String paymentMethod) async {
    String exceptionString = "";
    final body = {
      "transaction": {
        "kind": "sale",
        "gateway": paymentMethod,
        "status": "success",
        "source": "external"
      }
    };

    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        var response;
        response = await ApiManager.put(
            "$baseUrl${APIConstants.order}/$orderId/${APIConstants.transaction}",
            body);
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {}
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
    }
  }

  checkout(String paymentId) async {
    if (AppConfigure.bigCommerce) {
      String exceptionString = "";
      String draftId = await SharedPreferenceManager().getDraftId();
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          var response;
          response = await ApiManager.post(
              "${AppConfigure.bigcommerceUrl}/checkouts/$draftId/orders", {});
          var data = jsonDecode(response.body);
          debugPrint("${response.body} ${response.statusCode}");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            await SharedPreferenceManager().setDraftId("");
            var service = await getPaymentDetails(paymentId);
            var gateWayMethod = service["method"];
            return AppString.success;
          }
        }
      } catch (error) {
        debugPrint('error is this $error');
        exceptionString = AppString.oops;
        return exceptionString;
      }
    } else {
      String exceptionString = "";
      String draftId = await SharedPreferenceManager().getDraftId();
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          var response;
          response = await ApiManager.put(
              "$BASE_URL${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId/${APIConstants.complete}.json",
              {});
          var data = jsonDecode(response.body);
          debugPrint("${response.body} ${response.statusCode}");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            await SharedPreferenceManager().setDraftId("");
            var service = await getPaymentDetails(paymentId);
            var gateWayMethod = service["method"];
            return AppString.success;
          }
        }
      } catch (error) {
        debugPrint('error is this $error');
        exceptionString = AppString.oops;
        return exceptionString;
      }
    }
  }

  getPaymentDetails(String paymentId) async {
    String apiKey = AppConfigure.razorPayId;
    String apiSecret = AppConfigure.razorPaySecreteKey;
    // Concatenate API key and API secret with a colon
    String credentials = "$apiKey:$apiSecret";
    // Base64 encode the concatenated string
    String encodedCredentials = base64.encode(utf8.encode(credentials));
    final response = await http.get(
      Uri.parse('${APIConstants.razorPayPaymentDetails}$paymentId'),
      headers: {
        'Authorization': "Basic $encodedCredentials",
        // Use your Razorpay API key
      },
    );
    if (response.statusCode == APIConstants.successCode) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payment details');
    }
  }

  Future<DraftOrderModel> getCartDetails() async {
    if (AppConfigure.bigCommerce) {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          String draftId = await SharedPreferenceManager().getDraftId();

          final response = await ApiManager.get(
              "${AppConfigure.bigcommerceUrl}/carts/$draftId");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            debugPrint("${response.body}");
            final result = jsonDecode(response.body)['data'];
            debugPrint("result is this ${result}");

            return DraftOrderModel.fromJson(result);
          } else {
            throw (AppString.noDataError);
          }
        } else {
          throw (AppString.error);
        }
      } catch (error, stackTrace) {
        debugPrint('error is this $error $stackTrace');
        throw (error);
      }
    } else {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          String draftId = await SharedPreferenceManager().getDraftId();

          final response = await ApiManager.get(
              "$BASE_URL${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId.json");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            final result = jsonDecode(response.body)['draft_order'];
            return DraftOrderModel.fromJson(result);
          } else {
            throw (AppString.noDataError);
          }
        } else {
          throw (AppString.error);
        }
      } catch (error) {
        throw (error);
      }
    }
  }

  Future<DraftOrderModel> getRepeatOrderDetails(String oId) async {
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.get(
            "$BASE_URL${APIConstants.draftProduct.replaceAll(".json", "")}/$oId.json");
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          final result = jsonDecode(response.body)['draft_order'];
          return DraftOrderModel.fromJson(result);
        } else {
          throw (AppString.noDataError);
        }
      } else {
        throw (AppString.error);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<OrderModel> getOrderInfo(String pid) async {
    final uid = await SharedPreferenceManager().getUserId();
    API api = API();
    if (AppConfigure.bigCommerce) {
      try {
        final response = await api.sendRequest.get(
          "https://api.bigcommerce.com/stores/05vrtqkend/v2/orders/$pid",
          options: Options(headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"
          }),
        );
        if (response.statusCode == APIConstants.successCode) {
          final userData = response.data;
          return OrderModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (error) {
        throw error;
      }
    } else {
      try {
        String BASE_URL = AppConfigure.baseUrl +
            APIConstants.apiForAdminURL +
            APIConstants.apiURL;
        final response =
            await ApiManager.get("$BASE_URL/${APIConstants.order}/$pid.json");
        if (response.statusCode == APIConstants.successCode) {
          final userData = json.decode(response.body)['order'];
          return OrderModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (error) {
        throw error;
      }
    }
  }

  Future<List<OrderModel>> getOrder() async {
    API api = API();
    if (AppConfigure.bigCommerce) {
      final uid = await SharedPreferenceManager().getUserId();
      try {
        final response = await api.sendRequest.get(
          "https://api.bigcommerce.com/stores/05vrtqkend/v2/orders?customer_id=$uid",
          options: Options(headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"
          }),
        );
        if (response.statusCode == APIConstants.successCode) {
          final List result = response.data;
          if (result.isEmpty || result.toString() == "[]") {
            throw (AppString.noDataError);
          } else {
            return result.map((e) => OrderModel.fromJson(e)).toList();
          }
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          throw (AppString.noDataError);
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          // throw AppString.unAuthorized;
          throw (AppString.noDataError);
        } else {
          // throw AppString.serverError;
          throw (AppString.noDataError);
        }
      } catch (error, stackTrace) {
        debugPrint("error is this: $stackTrace");
        debugPrint("error is this: $error");
        rethrow;
      }
    } else {
      final uid = await SharedPreferenceManager().getUserId();
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.customer;
      try {
        final response =
            await ApiManager.get("$BASE_URL$uid/${APIConstants.order}.json");
        if (response.statusCode == APIConstants.successCode) {
          final List result = jsonDecode(response.body)['orders'];
          if (result.isEmpty || result.toString() == "[]") {
            throw (AppString.noDataError);
          } else {
            return result.map((e) => OrderModel.fromJson(e)).toList();
          }
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          throw (AppString.noDataError);
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          throw AppString.unAuthorized;
        } else {
          throw AppString.serverError;
        }
      } catch (error) {
        rethrow;
      }
    }
  }
}

final productsProvider =
    Provider<ProductRepository>((ref) => ProductRepository());
