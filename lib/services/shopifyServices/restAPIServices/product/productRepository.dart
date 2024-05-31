// productRepository

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mobj_project/mappers/bigcommerce_models/bicommerce_wishlistModel.dart';
import 'package:mobj_project/mappers/megento_models/megento_draftmodel.dart';
import 'package:mobj_project/utils/api.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../main.dart';

class ProductRepository {
  List<ProductModel> empty = [];
  API api = API();

  Future<List<ProductModel>> getProducts(String currentPage) async {
    if (AppConfigure.megentoCommerce) {
      try {
        log('megentoCommerce api');
        String accessToken = AppConfigure.megentoCunsumerAccessToken;
        final response = await api.sendRequest.get(
          'https://hp.geexu.org/rest/default/V1/products?searchCriteria[currentPage]=$currentPage&searchCriteria[pageSize]=10',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          }),
        );

        if (response.statusCode == APIConstants.successCode) {
          log("product details: $response");
          var data = response.data['items'];

          List<dynamic> result = data;

          // log(response.data);

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
        rethrow;
      }
    } else if (AppConfigure.wooCommerce) {
      try {
        log('calling api by wooCommerce');
        String productUrl = AppConfigure.woocommerceUrl +
            APIConstants.apiForAdminURL +
            APIConstants.apiURL +
            APIConstants.product;
        final response = await ApiManager.get(
            'https://ttf.setoo.org/wp-json/wc/v3/products?consumer key=${AppConfigure.consumerkey}&consumer secret=${AppConfigure.consumersecret}&page=$currentPage&per_page=10');

        // final response = await ApiManager.get(
        //     'https://api.bigcommerce.com/stores/05vrtqkend/v3/catalog/products?include=images,variants,options');

        if (response.statusCode == APIConstants.successCode) {
          // log("product details: $response");
          final List result = AppConfigure.wooCommerce == true
              ? jsonDecode(response.body)
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
        rethrow;
      }
    } else {
      try {
        log('calling api');
        String productUrl = AppConfigure.baseUrl +
            APIConstants.apiForAdminURL +
            APIConstants.apiURL +
            APIConstants.product;

        if (AppConfigure.bigCommerce) {
          productUrl = productUrl + "&page=$currentPage&limit=10";
        }
        log(productUrl);

        final response = await ApiManager.get(productUrl);

        // final response = await ApiManager.get(
        //     'https://api.bigcommerce.com/stores/05vrtqkend/v3/catalog/products?include=images,variants,options');

        if (response.statusCode == APIConstants.successCode) {
          // log("product details: $response");
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
        rethrow;
      }
    }
    return empty;
  }

  Future<ProductVariant> getProductsByVariantId(String vid, String pid) async {
    try {
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      final response = await ApiManager.get(
          "$baseUrl${APIConstants.productDetails}/$pid/${APIConstants.variants}/$vid.json");
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
      rethrow;
    }
  }

  Future<ProductModel> getProductInfo(String pid) async {
    API api = API();
    if (AppConfigure.megentoCommerce) {
      try {
        log("Logging product $pid");
        // debugPrint(baseUrl + pid);
        String accessToken = AppConfigure.megentoCunsumerAccessToken;
        final response = await api.sendRequest.get(
          "products/$pid",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          }),
        );
        // log(response.data);
        if (response.statusCode == APIConstants.successCode) {
          final userData = response.data;
          return ProductModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (e, stackTrace) {
        log("magento product details error is this ${e.toString()} $stackTrace");

        rethrow;
      }
    } else if (AppConfigure.wooCommerce) {
      try {
        String baseUrl =
            "https://ttf.setoo.org/wp-json/wc/v3/products/$pid?consumer key=ck_db1d729eb2978c28ae46451d36c1ca02da112cb3&consumer secret=cs_c5cc06675e8ffa375b084acd40987fec142ec8cf";
        debugPrint(baseUrl + pid);
        final response = await ApiManager.get(baseUrl);
        // log(response.body);
        if (response.statusCode == APIConstants.successCode) {
          final userData = jsonDecode(response.body);
          return ProductModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        String baseUrl = AppConfigure.bigCommerce == true
            ? AppConfigure.baseUrl +
                APIConstants.apiForAdminURL +
                APIConstants.apiURL
            : AppConfigure.baseUrl +
                APIConstants.apiForAdminURL +
                APIConstants.apiURL;
        debugPrint(baseUrl + pid);
        final response = AppConfigure.bigCommerce == true
            ? await ApiManager.get(
                "$baseUrl/products/$pid?include=images,variants,options,images")
            : await ApiManager.get(
                "$baseUrl${APIConstants.productDetails}/$pid.json");
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
        rethrow;
      }
    }
    // throw Exception('Unexpected error occurred while fetching product info.');
  }

  Future<ProductRatingModel> getProductRating(String pid) async {
    try {
      String baseUrl = AppConfigure.feraUrl;

      final response = await ApiManager.get(
          "${baseUrl}products/$pid/${APIConstants.ratingProduct}");

      if (response.statusCode == APIConstants.successCode) {
        final userData = json.decode(response.body);
        return ProductRatingModel.fromJson(userData);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<ReviewProductModels> getProductReviews(String pid) async {
    API api = API();
    if (AppConfigure.wooCommerce) {
      log("WooCommerce product reviews");
      try {
        Response response = await api.sendRequest.get(
            'https://ttf.setoo.org/wp-json/wc/v3/products/reviews?product=$pid&consumer key=ck_db1d729eb2978c28ae46451d36c1ca02da112cb3&consumer secret=cs_c5cc06675e8ffa375b084acd40987fec142ec8cf');
        if (response.statusCode == APIConstants.successCode) {
          List result = response.data;
          // log(result.runtimeType.toString());
          return ReviewProductModels(
              currentPage: 1,
              perPage: 1,
              reviews: result
                  .map((e) => Review(
                        id: e['id'],
                        title: e['product_name'],
                        body: e['review'],
                        rating: e['rating'],
                        productExternalId: 0,
                        reviewer: Reviewer(
                            id: 0,
                            externalId: 0,
                            email: e['reviewer_email'],
                            name: e['reviewer'],
                            phone: 1234567898,
                            acceptsMarketing: true,
                            unsubscribedAt: 'unsubscribedAt',
                            tags: 'tags'),
                        source: '',
                        curated: '',
                        published: true,
                        hidden: true,
                        verified: '',
                        featured: true,
                        createdAt: DateTime(2024),
                        updatedAt: DateTime(2024),
                        hasPublishedPictures: false,
                        hasPublishedVideos: false,
                        pictures: [],
                        ipAddress: '',
                        productTitle: '',
                        productHandle: '',
                      ))
                  .toList());
          // return [ReviewProductModels(currentPage: response.data['rating'], perPage: response.data['rating'], reviews: response.data['review'])];
        } else {
          throw (AppString.noDataError);
        }
      } catch (error, stackTrace) {
        debugPrint('print error is this $error $stackTrace');
        rethrow;
      }
    } else {
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
        rethrow;
      }
    }
  }

  Future<List<ProductImage>> getProductImage(String pid) async {
    try {
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      final response = await ApiManager.get(
          "$baseUrl${APIConstants.productDetails}/$pid/${APIConstants.images}");
      if (response.statusCode == APIConstants.successCode) {
        final List result = jsonDecode(response.body)['images'];
        return result.map((e) => ProductImage.fromJson(e)).toList();
      } else {
        throw (AppString.noDataError);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<RecommendedProductModel>> getRecommendedProductInfo(
      String pid) async {
    try {
      String baseUrl = AppConfigure.baseUrl +
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
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCollection(
      String colllectionId) async {
    try {
      String baseUrl = AppConfigure.baseUrl + APIConstants.apiForAdminURL;
      final response = await ApiManager.get(
          "$baseUrl${APIConstants.collectionProduct}/$colllectionId/${APIConstants.product}");
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
      rethrow;
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
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    debugPrint(baseUrl + APIConstants.draftProduct);
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        debugPrint('darftId is this $draftId');
        var response;
        if (draftId == "") {
          response = await ApiManager.post(
              "$baseUrl${APIConstants.draftProduct}", body);
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
                "$baseUrl${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId.json",
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

  CrateCartmagentoCommerce(String quantity, String sku) async {
    String exceptionString = "";
    String uid = await SharedPreferenceManager().getUserId();
    // debugPrint('$uid $variantId');
    String draftId = await SharedPreferenceManager().getDraftId();

    String baseUrl = AppConfigure.baseUrl;
    debugPrint(baseUrl + APIConstants.draftProduct);
    try {
      API api = API();
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        String userToken = await SharedPreferenceManager().getToken();
        debugPrint('darftId is this $draftId');
        log("sku is ...........$sku........$quantity");
        final response;
        if (draftId == "") {
          response = await api.sendRequest.post(
            "carts/mine",
            options: Options(headers: {
              "Authorization": "Bearer $userToken",
            }),
          );

          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            final int data = response.data;
            await SharedPreferenceManager().setDraftId(data.toString());
            debugPrint('cart id is this bigcommerce.... $data');
            String draftId = await SharedPreferenceManager().getDraftId();

            debugPrint('draft id ...cart id is this bigcommerce.... $draftId');

            String accessToken = AppConfigure.megentoCunsumerAccessToken;
            final create = await api.sendRequest.post(
              "carts/mine/items",
              data: {
                "cart_item": {
                  "quote_id": draftId,
                  "sku": sku,
                  "qty": int.parse(quantity),
                }
              },
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }),
            );
            if (create.statusCode == APIConstants.successCode ||
                create.statusCode == APIConstants.successCreateCode) {
              var data = create.data;

              cartcount++;
              debugPrint('cart id is this bigcommerce.... $draftId');
              return AppString.success;
            } else {
              exceptionString = AppString.oops;
              return exceptionString;
            }
          } else {
            exceptionString = AppString.oops;
            return exceptionString;
          }
        } else {
          String accessToken = AppConfigure.megentoCunsumerAccessToken;
          response = await api.sendRequest.post(
            "carts/mine/items",
            data: {
              "cart_item": {
                "quote_id": draftId,
                "sku": sku,
                "qty": int.parse(quantity),
              }
            },
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
            }),
          );

          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            var data = response.data;

            //   await SharedPreferenceManager().setDraftId(data.toString());
            //   // debugPrint(
            //   //     'cart id is this bigcommerce.... $data');
            //   String draftId = await SharedPreferenceManager().getDraftId();

            //   debugPrint('cart id is this bigcommerce.... $draftId');

            cartcount++;
            // debugPrint('cart id is this bigcommerce.... $draftId');
            return AppString.success;
          } else {
            exceptionString = AppString.oops;
            return exceptionString;
          }
        }
      }
    } catch (error, stackTrace) {
      print("add to cart $error $stackTrace");
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
      "currency": {"code": "USD"},
      "locale": "en-US"
    });
    var decodedBody = jsonDecode(body);
    String baseUrl = AppConfigure.baseUrl;
    debugPrint(baseUrl + APIConstants.draftProduct);
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        debugPrint('darftId is this $draftId');
        http.Response response;
        if (draftId == "") {
          response = await ApiManager.post("$baseUrl/carts", body);
        } else {
          response =
              await ApiManager.post("$baseUrl/carts/$draftId/items", body);
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
          cartcount++;
          return AppString.success;
        } else {
          exceptionString = AppString.oops;
          return exceptionString;
        }
      }
    } catch (error, stackTrace) {
      print("add to cart $error $stackTrace");
      exceptionString = AppString.oops;
      return exceptionString;
    }
  }

  addToCartWooCommerce(String quantity, String productId) async {
    String exceptionString = "";
    String uid = await SharedPreferenceManager().getUserId();
    //  debugPrint('$uid $variantId');

    var body = jsonEncode({"id": productId, "quantity": quantity});
    var decodedBody = jsonDecode(body);
    String baseUrl = AppConfigure.baseUrl;
    debugPrint(baseUrl);
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String email = await SharedPreferenceManager().getemail();

        var uuid = const Uuid();
        String cartkey = await SharedPreferenceManager().getCartToken();
        if (cartkey == "") {
          cartkey = uuid.v4();
          await SharedPreferenceManager().setCartToken(cartkey);
        }
        debugPrint('email is this $email');
        http.Response response;

        response = await ApiManager.post(
            "$baseUrl/wp-json/cocart/v2/cart/add-item?cart_key=$cartkey", body);

        var data = jsonDecode(response.body);
        debugPrint('add to cart data is this $data');

        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
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

  //   addToCartmegentocommerce() async {
  //       API api = API();
  //   String exceptionString = "";
  //   String uid = await SharedPreferenceManager().getUserId();
  //   //  debugPrint('$uid $variantId');

  //   // var body = jsonEncode({"id": productId, "quantity": quantity,});
  //   // var decodedBody = jsonDecode(body);
  //   String baseUrl = AppConfigure.baseUrl;
  //   debugPrint(baseUrl);
  //   try {
  //     if (await ConnectivityUtils.isNetworkConnected()) {
  //       String email = await SharedPreferenceManager().getemail();
  // String userToken  = await SharedPreferenceManager().getToken();
  //       var uuid = const Uuid();
  //       String cartkey = await SharedPreferenceManager().getCartToken();
  //       if (cartkey == "") {
  //         cartkey = uuid.v4();
  //         await SharedPreferenceManager().setCartToken(cartkey);
  //       }
  //       debugPrint('email is this $email');
  //      final response;

  //       response = await api.sendRequest.post(
  //           "carts/mine/items",
  //             options: Options(headers: {
  //           "Authorization": "Bearer $userToken",
  //         }),
  //           );

  //       var data = jsonDecode(response.body);
  //       debugPrint('add to cart data is this $data');

  //       if (response.statusCode == APIConstants.successCode ||
  //           response.statusCode == APIConstants.successCreateCode) {

  //         return AppString.success;
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

  repeatOrder(Map<String, dynamic> reqBody) async {
    String exceptionString = "";

    var body = jsonEncode(reqBody);
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        String draftId = await SharedPreferenceManager().getDraftId();
        http.Response response;
        response =
            await ApiManager.post("$baseUrl${APIConstants.draftProduct}", body);

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
    if (AppConfigure.wooCommerce) {
      log("Adding review to wooCommerce api...");
      log(pid);
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          final response = await api.sendRequest.post(
            "${AppConfigure.woocommerceUrl}wp-json/wc/v3/products/reviews?consumer key=${AppConfigure.consumerkey}&consumer secret=${AppConfigure.consumersecret}",
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
    } else {
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
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        http.Response response;
        response = await ApiManager.put(
            "$baseUrl${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId.json",
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

  updateCartMagento(List<dynamic> reqBody) async {
    String exceptionString = "";
    String draftId = await SharedPreferenceManager().getDraftId();
    String uid = await SharedPreferenceManager().getUserId();
    var body = jsonEncode({
      "draft_order": {
        "line_items": reqBody,
        "customer": {"id": uid}
      }
    }
        // {
        //       "cart_item": {
        //         "quote_id": "296",
        //         "sku": "DEN101003005",
        //         "qty": int.parse(quantity),
        //       }
        //     }
        );
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        http.Response response;
        response = await ApiManager.put("carts/mine/items/", body);

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
        http.Response response;
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

  checkout(
    String paymentId,
  ) async {
    if (AppConfigure.bigCommerce) {
      String exceptionString = "";
      String draftId = await SharedPreferenceManager().getDraftId();
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          http.Response response;
          response = await ApiManager.post(
              "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/checkouts/$draftId/orders",
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
    } else if (AppConfigure.wooCommerce) {
      API api = API();
      String exceptionString = "";
      String userId = await SharedPreferenceManager().getUserId();
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          Response response;
          response = await api.sendRequest.post(
              "wp-json/wc/v3/orders?consumer key=${AppConfigure.consumerkey}&consumer secret=${AppConfigure.consumersecret}",
              data: {
                "payment_method": "bacs",
                "payment_method_title": "Direct Bank Transfer",
                "customer_id": int.parse(userId),
                "set_paid": true,
                "billing": woocommerceaddressbody,
                "shipping": woocommerceaddressbody,
                "line_items": bigcommerceOrderedItems
              });
          var data = response.data;
          debugPrint("${response.data} ${response.statusCode}");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            await SharedPreferenceManager().setCartToken("");
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
    } else if (AppConfigure.megentoCommerce) {
      API api = API();
      String exceptionString = "";
      String token = await SharedPreferenceManager().getToken();
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          Response response;
          response = await api.sendRequest.post(
              "https://hp.geexu.org/rest/V1/carts/mine/payment-information",
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              }),
              data: {
                "paymentMethod": {"method": "cashondelivery"},
                "billing_address": woocommerceaddressbody
              });
          var data = response.data;
          debugPrint("${response.data} ${response.statusCode}");
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
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          http.Response response;
          response = await ApiManager.put(
              "$baseUrl${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId/${APIConstants.complete}.json",
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
              "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/carts/$draftId");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            debugPrint(response.body);
            final result = jsonDecode(response.body)['data'];
            debugPrint("result is this $result");

            return DraftOrderModel.fromJson(result);
          } else {
            throw (AppString.noDataError);
          }
        } else {
          throw (AppString.error);
        }
      } catch (error, stackTrace) {
        debugPrint('error is this $error $stackTrace');
        rethrow;
      }
    } else if (AppConfigure.wooCommerce) {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          String email = await SharedPreferenceManager().getCartToken();

          final response = await ApiManager.get(
              "${AppConfigure.woocommerceUrl}/wp-json/cocart/v2/cart?cart_key=$email");
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            debugPrint(response.body);
            final result = jsonDecode(response.body);
            debugPrint("result is this $result");
            if (result['item_count'] == 0) {
              throw (AppString.noDataError);
            }
            return DraftOrderModel.fromJson(result);
          } else {
            throw (AppString.noDataError);
          }
        } else {
          throw (AppString.error);
        }
      } catch (error, stackTrace) {
        debugPrint('error is this $error $stackTrace');
        rethrow;
      }
    } else if (AppConfigure.megentoCommerce) {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          // String cartId = await SharedPreferenceManager().getCartToken();
          String userToken = await SharedPreferenceManager().getToken();

          final response = await api.sendRequest.get(
            "carts/mine",
            options: Options(headers: {
              "Authorization": "Bearer $userToken",
            }),
          );
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            //  debugPrint(response.data);
            final result = response.data;
            debugPrint("result is this $result");
            if (result['items_count'] == 0) {
              throw (AppString.noDataError);
            }

            return DraftOrderModel.fromJson(result);
          } else {
            throw (AppString.noDataError);
          }
        } else {
          throw (AppString.error);
        }
      } catch (error, stackTrace) {
        debugPrint('error is this $error $stackTrace');
        rethrow;
      }
    } else {
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL;
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          String draftId = await SharedPreferenceManager().getDraftId();

          final response = await ApiManager.get(
              "$baseUrl${APIConstants.draftProduct.replaceAll(".json", "")}/$draftId.json");
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
        rethrow;
      }
    }
  }

  Future<List<String>> getCarttotalDetails() async {
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        // String cartId = await SharedPreferenceManager().getCartToken();
        String userToken = await SharedPreferenceManager().getToken();

        final response = await api.sendRequest.get(
          "carts/mine/totals",
          options: Options(headers: {
            "Authorization": "Bearer $userToken",
          }),
        );
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          //  debugPrint(response.data);
          final result = response.data;
          debugPrint("result is this $result");
          if (result['items_qty'] == 0) {
            throw (AppString.noDataError);
          }
          List<String> ATT = [];
          ATT.add(result['subtotal'].toString());
          ATT.add(result['tax_amount'].toString());
          ATT.add(result['base_grand_total'].toString());

          return ATT;
        } else {
          throw (AppString.noDataError);
        }
      } else {
        throw (AppString.error);
      }
    } catch (error, stackTrace) {
      debugPrint('error is this $error $stackTrace');
      rethrow;
    }
  }

  Future<DraftOrderModel> getRepeatOrderDetails(String oId) async {
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL;
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.get(
            "$baseUrl${APIConstants.draftProduct.replaceAll(".json", "")}/$oId.json");
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
      rethrow;
    }
  }

  Future<OrderModel> getOrderInfo(String pid) async {
    final uid = await SharedPreferenceManager().getUserId();
    API api = API();
    if (AppConfigure.wooCommerce) {
      try {
        final response = await api.sendRequest.get(
          "${AppConfigure.woocommerceUrl}wp-json/wc/v3/orders?customer=$uid&consumer key=${AppConfigure.consumerkey}&consumer secret=${AppConfigure.consumersecret}",
        );
        if (response.statusCode == APIConstants.successCode) {
          final userData = response.data;
          log('order is $userData');
          // return OrderModel.fromJson(userData);
          return OrderModel(
            id: userData[0]['id'],
            adminGraphqlApiId: "adminGraphqlApiId",
            appId: userData[0]['id'],
            browserIp: "browserIp",
            buyerAcceptsMarketing: false,
            cancelReason: "cancelReason",
            cancelledAt: "cancelledAt",
            cartToken: "cartToken",
            checkoutId: 1,
            checkoutToken: "checkoutToken",
            confirmed: false,
            contactEmail: userData[0]['billing']['email'],
            createdAt: userData[0]['date_created_gmt'],
            currency: "",
            currentSubtotalPrice: userData[0]['total'],
            currentTotalTax: userData[0]['total_tax'],
            totalPrice: userData[0]['total'],
            customer: CustomerModel(
                id: userData[0]['id'],
                email: userData[0]['billing']['email'],
                acceptsMarketing: false,
                createdAt: "createdAt",
                updatedAt: "updatedAt",
                firstName: userData[0]['billing']['first_name'],
                lastName: userData[0]['billing']['last_name'],
                ordersCount: 0,
                state: "state",
                totalSpent: userData[0]['total'],
                lastOrderId: 1,
                note: "note",
                taxExempt: false,
                tags: "tags",
                lastOrderName: "lastOrderName",
                currency: userData[0]['currency_symbol'],
                phone: "",
                adminGraphqlApiId: "adminGraphqlApiId"),
            lineItems: [],
            firstname: userData[0]['billing']['first_name'],
            lastname: userData[0]['billing']['last_name'],
            phone: userData[0]['billing']['phone'],
          );
        } else {
          throw (AppString.noDataError);
        }
      } catch (error, stackTrace) {
        log("Error is $stackTrace");
        rethrow;
      }
    } else if (AppConfigure.bigCommerce) {
      try {
        final response = await api.sendRequest.get(
          "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v2/orders/$pid",
          options: Options(headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "X-auth-Token": AppConfigure.bigCommerceAccessToken
          }),
        );
        if (response.statusCode == APIConstants.successCode) {
          final userData = response.data;
          return OrderModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (error) {
        rethrow;
      }
    } else if (AppConfigure.megentoCommerce) {
      try {
        final response = await api.sendRequest.get("orders/$pid",
          options: Options(headers: {
            "Authorization": "Bearer ${AppConfigure.megentoCunsumerAccessToken}",
          }),
        );

        if (response.statusCode == APIConstants.successCode) {
          final userData = response.data;
          return OrderModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (error, stackTrace) {
        debugPrint("error is this order details: $stackTrace");
        debugPrint("error is this: $error");
        rethrow;
      }
    } else {
      try {
        String baseUrl = AppConfigure.baseUrl +
            APIConstants.apiForAdminURL +
            APIConstants.apiURL;
        final response =
            await ApiManager.get("$baseUrl/${APIConstants.order}/$pid.json");
        if (response.statusCode == APIConstants.successCode) {
          final userData = json.decode(response.body)['order'];
          return OrderModel.fromJson(userData);
        } else {
          throw (AppString.noDataError);
        }
      } catch (error, stackTrace) {
        debugPrint("error is this order details: $stackTrace");
        debugPrint("error is this: $error");
        rethrow;
      }
    }
  }

  Future<List<OrderModel>> getOrder() async {
    API api = API();
    if (AppConfigure.wooCommerce) {
      final uid = await SharedPreferenceManager().getUserId();
      try {
        final response = await api.sendRequest.get(
          "${AppConfigure.woocommerceUrl}/wp-json/wc/v3/orders?customer=$uid&consumer key=${AppConfigure.consumerkey}&consumer secret=${AppConfigure.consumersecret}",
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
    } else if (AppConfigure.bigCommerce) {
      final uid = await SharedPreferenceManager().getUserId();
      try {
        final response = await api.sendRequest.get(
          "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v2/orders?customer_id=$uid",
          options: Options(headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "X-auth-Token": AppConfigure.bigCommerceAccessToken
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
    } else if (AppConfigure.megentoCommerce) {
      String accessToken = AppConfigure.megentoCunsumerAccessToken;
      final email = await SharedPreferenceManager().getEmail();
      log("  user email is ..............................$email");
      try {
        final response = await api.sendRequest.get(
          "orders?searchCriteria[filterGroups][][filters][][field]=customer_email&searchCriteria[filterGroups][0][filters][0][value]=$email",
          options: Options(headers: {
            "Authorization": "Bearer $accessToken",
          }),
        );
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          //  debugPrint(response.data);
          final result = response.data;
          debugPrint("result is this $result");

          if (response.data['items'].isEmpty) {
            throw (AppString.noDataError);
          } else {
            List order = response.data["items"];

            List<OrderModel> orderlist = [];

            for (int i = 0; i < order.length; i++) {
              orderlist.add(OrderModel(
                  id: response.data['items'][i]['items'][0]['order_id'],
                  adminGraphqlApiId: "",
                  appId: response.data['items'][i]['items'][0]['store_id'],
                  browserIp: "",
                  buyerAcceptsMarketing: true,
                  cancelReason: "",
                  cancelledAt: response.data['items'][i]['items'][0]
                      ['created_at'],
                  cartToken: response.data['items'][i]['items'][0]['sku'],
                  checkoutId: response.data['items'][i]['items'][0]
                      ['quote_item_id'],
                  checkoutToken: response.data['items'][i]['items'][0]
                      ['product_type'],
                  confirmed: true,
                  contactEmail: response.data['items'][i]['customer_email'],
                  createdAt: response.data['items'][i]['items'][0]
                      ['created_at'],
                  currency: response.data['items'][i]['base_currency_code'],
                  currentSubtotalPrice: response.data['items'][i]
                      ['base_subtotal'],
                  currentTotalTax: response.data['items'][i]['base_tax_amount'],
                  totalPrice: response.data['items'][i]
                      ['base_subtotal_incl_tax'],
                  // customer: response.data['items'][i]['items']['order_id'],
                  customer: MagentoCustomerModel(
                    id: response.data['items'][i]['customer_id'],
                    email: response.data['items'][i]['customer_email'],
                    acceptsMarketing: true,
                    createdAt: response.data['items'][i]['created_at'],
                    updatedAt: response.data['items'][i]['updated_at'],
                    firstName: response.data['items'][i]['customer_firstname'],
                    lastName: response.data['items'][i]['customer_lastname'],
                    ordersCount: response.data['items'][i]['total_item_count'],
                    state: response.data['items'][i]['status'],
                    totalSpent: response.data['items'][i]['increment_id'],
                    lastOrderId: response.data['items'][i]['total_qty_ordered'],
                    note: response.data['items'][i]['store_name'],
                    taxExempt: true,
                    tags: response.data['items'][i]['shipping_description'],
                    lastOrderName: response.data['items'][i]['store_name'],
                    currency: response.data['items'][i]['store_currency_code'],
                    phone: response.data['items'][i]['billing_address']
                        ['telephone'],
                    adminGraphqlApiId: "",
                  ),
                  // lineItems: response.data['items'][i]['items']['order_id'],
                  lineItems: (response.data['items'][i]['items']
                              as List<dynamic>?)
                          ?.map(
                              (item) => MagentoCommerceLineItem.fromJson(item))
                          .toList() ??
                      [],
                  firstname: response.data['items'][i]['customer_firstname'],
                  lastname: response.data['items'][i]['customer_lastname'],
                  phone: response.data['items'][i]['billing_address']
                      ['telephone']));
            }

            return orderlist;

            // List order = response.data["items"];
            // return order.map((e) => OrderModel.fromJson(e)).toList();
          }
        } else {
          throw (AppString.noDataError);
        }
      } catch (error, stackTrace) {
        debugPrint("error is this: $stackTrace");
        debugPrint("error is this: $error");
        rethrow;
      }
    } else {
      final uid = await SharedPreferenceManager().getUserId();
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.customer;
      try {
        final response =
            await ApiManager.get("$baseUrl$uid/${APIConstants.order}.json");
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

  // Function to toggle the like status
  Future<void> toggleLikeStatus(bool isLikedd, String wishlistId,
      String productId, String varientId) async {
    try {
      if (isLikedd) {
        // Remove from wishlist
        await deleteWishlistItem(wishlistId);
        Fluttertoast.showToast(
          msg: "Removed this product from wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        // Check if wishlist ID is available

        String wislistId = await SharedPreferenceManager().getwishlistID();

        if (wislistId != "") {
          try {
            log("this is wislis ID : $wislistId");
            // If wishlist ID is available, add product to wishlist
            log("adding product to wislist");

            await addproductTowishlist(productId, varientId);
            Fluttertoast.showToast(
              msg: "Added this product to wishlist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } catch (error, stackTrace) {
            log("error is this: $stackTrace");
            log("error is this: $error");
            rethrow;
          }
        } else {
          // If wishlist ID is not available, create a new wishlist and add product to it
          log("creating wislist.........");
          await createwishlist(productId, varientId);
          Fluttertoast.showToast(
            msg: "Added this product to wishlist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } catch (error, stackTrace) {
      log("error is this: $stackTrace");
      log("error is this: $error");
      rethrow;
    }
  }

  Future<void> addproductTowishlist(String productId, String variantId) async {
    API api = API();
    String WishlistID = await SharedPreferenceManager().getwishlistID();
    log(" product Id... $productId");
    Map<String, dynamic> newProduct = {
      "items": [
        {
          "product_id": int.parse(productId),
          "variant_id": int.parse(variantId),
        }
      ]
    };
    try {
      final response = await api.sendRequest.post(
        "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/wishlists/$WishlistID/items",
        data: newProduct,
        options: Options(headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        log("Added to wishlist : $response");
        final result = response.data['data'];
        await SharedPreferenceManager().setWishlistId(result['id'].toString());
        String WishlistID = await SharedPreferenceManager().getwishlistID();
        log("wishlist id : $WishlistID");
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        throw (AppString.noDataError);
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        throw (AppString.noDataError);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error, stackTrace) {
      log("error is this: $stackTrace");
      log("error is this: $error");
      rethrow;
    }
  }

  deleteWishlistItem(String wishlistItemID) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    final WishlistID = await SharedPreferenceManager().getwishlistID();
    API api = API();
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await api.sendRequest.delete(
          "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/wishlists/$WishlistID/items/$wishlistItemID",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"
          }),
        );
        // var data = jsonDecode(response.body);
        if (response.statusCode == 204) {
          return AppString.success;
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          exceptionString = AppString.unAuthorized;
          return exceptionString;
        } else {
          exceptionString = AppString.serverError;
          return exceptionString;
        }
      } else {
        var exceptionString = AppString.checkInternet;
        return exceptionString;
      }
    } catch (error) {
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }

  Future<void> createwishlist(String productId, String variantId) async {
    API api = API();
    final uid = await SharedPreferenceManager().getUserId();
    log("product Id : $productId");
    Map<String, dynamic> wishlistData = {
      "customer_id": int.parse(uid),
      "is_public": false,
      "name": "new list",
      "items": [
        {
          "product_id": int.parse(productId),
          "variant_id": int.parse(variantId),
        }
      ]
    };
    try {
      final response = await api.sendRequest.post(
        "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/wishlists",
        data: wishlistData,
        options: Options(headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        log("create wishlist : $response");
        final result = response.data['data'];
        await SharedPreferenceManager().setWishlistId(result['id'].toString());
        String WishlistID = await SharedPreferenceManager().getwishlistID();
        log("wishlist id : $WishlistID");
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        throw (AppString.noDataError);
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        throw (AppString.noDataError);
      } else {
        throw (AppString.noDataError);
      }
    } catch (error, stackTrace) {
      log("error is this: $stackTrace");
      log("error is this: $error");
      rethrow;
    }
  }

  // Future<List<WishlistModel>> getallwishlistProducts() async {
  //   try {
  //     log('calling api');
  //       final uid = await SharedPreferenceManager().getUserId();
  //     final response = await api.sendRequest.get("https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/wishlists?customer_id=$uid");

  //     // final response = await ApiManager.get(
  //     //     'https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/catalog/products?include=images,variants,options');

  //     if (response.statusCode == APIConstants.successCode) {
  //       // final List result = AppConfigure.bigCommerce == true
  //       //     ? jsonDecode(response.body)['data']
  //       //     : jsonDecode(response.body)['products'];
  // final List result = response.data;
  //        return result.map((e) => WishlistModel.fromJson(e)).toList();
  //       // return AppString.serverError;
  //           //     Fluttertoast.showToast(
  //           // msg: "your product added to Wishlist",
  //           // toastLength: Toast.LENGTH_SHORT,
  //           // gravity: ToastGravity.BOTTOM,
  //           // timeInSecForIosWeb: 0,
  //           // backgroundColor: AppColors.green,
  //           // textColor: AppColors.whiteColor,
  //           // fontSize: 16.0);

  //     } else if (response.statusCode == APIConstants.dataNotFoundCode) {
  //       log("empty data here");
  //       throw (AppString.noDataError);
  //     } else if (response.statusCode == APIConstants.unAuthorizedCode) {
  //       log("empty data here unauthorized");
  //       throw AppString.unAuthorized;
  //     } else {
  //       // return empty;
  //     }
  //   } catch (error, stackTrace) {
  //     log("error is this $error $stackTrace");
  //     throw error;
  //   }
  // }
}

final productsProvider =
    Provider<ProductRepository>((ref) => ProductRepository());
