// productRepository

import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  List<ProductModel> empty = [];

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await ApiManager.get(AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.product);
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
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      final response = await ApiManager.get(
          "$BASE_URL${APIConstants.productDetails}/$pid.json");
      if (response.statusCode == APIConstants.successCode) {
        final userData = json.decode(response.body)['product'];
        return ProductModel.fromJson(userData);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
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

  Future<List<ReviewProductModel>> getProductReview(String pid) async {
    try {
      String BASE_URL = AppConfigure.feraUrl;
      final response = await ApiManager.get(
          "${BASE_URL}products/$pid/${APIConstants.reviewProduct}");
      if (response.statusCode == APIConstants.successCode) {
        final List result = jsonDecode(response.body)['data'];
        return result.map((e) => ReviewProductModel.fromJson(e)).toList();
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
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
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
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

  addProductReview(Map<String, dynamic> reqBody) async {
    String exceptionString = "";
    var body = jsonEncode(reqBody);
    String BASE_URL = AppConfigure.feraUrl;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.post(
            "$BASE_URL/${APIConstants.reviewProduct}", body);
        var data = jsonDecode(response.body);

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
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          await SharedPreferenceManager().setDraftId("");
          var service = await getPaymentDetails(paymentId);
          var gateWayMethod = service["method"];
          return AppString.success;
        }
      }
    } catch (error) {
      exceptionString = AppString.oops;
      return exceptionString;
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

  Future<List<OrderModel>> getOrder() async {
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

final productsProvider =
    Provider<ProductRepository>((ref) => ProductRepository());
