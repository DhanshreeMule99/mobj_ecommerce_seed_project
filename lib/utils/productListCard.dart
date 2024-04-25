// productListCard

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:mobj_project/utils/api.dart';
import '../../utils/appColors.dart';
import '../mappers/bigcommerce_models/bigcommerce_getwishlistModel.dart';
import '../services/shopifyServices/restAPIServices/product/productRepository.dart';
import 'appDimension.dart';
import 'appString.dart';
import 'cmsConfigue.dart';
import 'commonAlert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductListCard extends StatefulWidget {
  final Color tileColor;
  final String logoPath;
  final String productName;
  final String? productDetails;
  final String datetime;
  final String address;
  final String productImage;
  final String variantId;
  final String? productPrice;
  final String? status;
  final String? isLiked;
  final GestureTapCallback? ratings;
  final Function addToCart;
  final GestureTapCallback? wishlist;
  final GestureTapCallback? shareProduct;
  final GestureTapCallback? onLiked;
  final num ratingCount;
  final String? isLikedToggle;
  final Widget? list;
  final String productId;
  final int stock;
  final bool isWhislisted;
  final List<BigcommerceGetWishlistModel> getwishlistIDHere;
  final WidgetRef ref;

  const ProductListCard({
    Key? key,
    required this.tileColor,
    required this.logoPath,
    required this.productName,
    required this.address,
    required this.datetime,
    required this.productImage,
    required this.addToCart,
    this.getwishlistIDHere = const [],
    this.shareProduct,
    this.wishlist,
    this.status,
    this.isLiked,
    required this.ratingCount,
    this.isLikedToggle,
    this.list,
    required this.productId,
    this.ratings,
    this.onLiked,
    this.productDetails,
    this.productPrice,
    required this.variantId,
    required this.stock,
    required this.ref,
    this.isWhislisted = false,
  }) : super(key: key);

  @override
  State<ProductListCard> createState() => _ProductListCardstate();
}

class _ProductListCardstate extends State<ProductListCard> {
  double ratings = 0.0;
  bool isLiked = false;
  List<Map<String, dynamic>> favoriteProducts = [];
  int? wishlistItemID;
  // List<String> likedProductIds = [];

//  Future<void> toggleLikeStatus()async {
//     setState(() {
//       // Toggle the liked state
//       isLiked = !isLiked;
//       // Update the liked list accordingly
//       if (isLiked) {
//         likedProductIds.add(widget.productId);
//       } else {
//         likedProductIds.remove(widget.productId);
//       }
//     });
//   }

  // Function to toggle the like status
  Future<void> toggleLikeStatus() async {
    try {
      if (isLiked) {
        // Remove from wishlist
        await deleteWishlistItem();
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

            await addproductTowishlist();
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
          await createwishlist();
          Fluttertoast.showToast(
            msg: "Added this product to wishlist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
      setState(() {
        isLiked = !isLiked;
      });
    } catch (error, stackTrace) {
      log("error is this: $stackTrace");
      log("error is this: $error");
      rethrow;
    }
  }

  Future<void> addproductTowishlist() async {
    API api = API();
    String WishlistID = await SharedPreferenceManager().getwishlistID();
    log(" product Id... $widget.productId");
    Map<String, dynamic> newProduct = {
      "items": [
        {
          "product_id": int.parse(widget.productId),
          "variant_id": int.parse(widget.variantId),
        }
      ]
    };
    try {
      final response = await api.sendRequest.post(
        "https://api.bigcommerce.com/stores/05vrtqkend/v3/wishlists/$WishlistID/items",
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

  deleteWishlistItem() async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    final WishlistID = await SharedPreferenceManager().getwishlistID();
    API api = API();
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await api.sendRequest.delete(
          "https://api.bigcommerce.com/stores/05vrtqkend/v3/wishlists/$WishlistID/items/$wishlistItemID",
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

  Future<void> createwishlist() async {
    API api = API();
    final uid = await SharedPreferenceManager().getUserId();
    log("product Id : $widget.productId");
    Map<String, dynamic> wishlistData = {
      "customer_id": int.parse(uid),
      "is_public": false,
      "name": "new list",
      "items": [
        {
          "product_id": int.parse(widget.productId),
          "variant_id": int.parse(widget.variantId),
        }
      ]
    };
    try {
      final response = await api.sendRequest.post(
        "https://api.bigcommerce.com/stores/05vrtqkend/v3/wishlists",
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

        setState(() {
          isLiked = true;
        });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isLiked = likedProductIds.contains(widget.productId);
  }

  String jwt_token = "";
  String userid = "";
  API api = API();
  Future<bool> isLogin() async {
    String wislistId = await SharedPreferenceManager().getwishlistID();
    final jwt = await SharedPreferenceManager().getToken();
    jwt_token = jwt;
    final uid = await SharedPreferenceManager().getUserId();
    final did = await SharedPreferenceManager().getDeviceId();
    userid = uid;

    if (jwt_token != '' || userid != '') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    isLiked = widget.isWhislisted;
    wishlistItemID = widget.getwishlistIDHere
        .firstWhere(
          (element) => element.productId == int.parse(widget.productId),
          orElse: () => BigcommerceGetWishlistModel(productId: -1, id: -1),
        )
        .id;
    log("wishlist item id is this $wishlistItemID");
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Wrap(
                    runAlignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      // Share Button
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: widget.shareProduct,
                        icon: const Icon(
                          Icons.share,
                          size: 25,
                        ),
                      ),
                      LikeButton(
                        mainAxisAlignment: MainAxisAlignment.end,
                        isLiked: isLiked,
                        onTap: (isLiked) async {
                          await toggleLikeStatus();
                          return !isLiked;
                        },
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.red : Colors.black,
                            size: 25,
                          );
                        },
                      ),
                    ],
                  ))),
          CachedNetworkImage(
            imageUrl: widget.productImage,
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.height / 4,
              // width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  //image size fill
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              color: AppColors.greyShade,
            ),
            errorWidget: (context, url, error) => Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                color: AppColors.greyShade),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                // color: app_colors.white_color,
                borderRadius: BorderRadius.circular(15.0),
                // Adjust the radius as needed
                border: Border.all(
                  color: Colors.transparent,
                  // Set the border color
                  width: 2.0, // Set the border width
                )),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Text(
                          widget.productName,
                          style: TextStyle(
                            fontSize: 0.04 * MediaQuery.of(context).size.width,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      widget.productPrice != null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Text(
                                "\u{20B9}${widget.productPrice}",
                                style: TextStyle(
                                  fontSize:
                                      0.05 * MediaQuery.of(context).size.width,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : Container(),
                    ])),
                Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: widget.stock > 0
                        ? ElevatedButton(
                            onPressed: () async {
                              debugPrint(
                                  "varient id is this ${widget.variantId} 1 ${widget.productName} ${widget.productPrice} ${widget.productId}");
                              isLogin().then((value) {
                                if (value == true) {
                                  CommonAlert.show_loading_alert(context);
                                  debugPrint(
                                      "varient id is this ${widget.variantId}");
                                  if (AppConfigure.bigCommerce) {
                                    ProductRepository()
                                        .addToCartBigcommerce(
                                            widget.variantId,
                                            '1',
                                            widget.productName,
                                            widget.productPrice.toString(),
                                            widget.productId)
                                        .then((value) async {
                                      if (value == AppString.success) {
                                        Navigator.of(context).pop();
                                        widget.ref.refresh(productDataProvider);
                                        widget.ref
                                            .refresh(cartDetailsDataProvider);
                                        widget.ref.refresh(
                                            productDetailsProvider(
                                                widget.productId));
                                        Fluttertoast.showToast(
                                            msg: AppString.addToCartSuccess,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 0,
                                            backgroundColor: AppColors.green,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.0);
                                      } else {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: AppString.oops,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 0,
                                            backgroundColor: AppColors.green,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.0);
                                      }
                                    });
                                  } else {
                                    ProductRepository()
                                        .addToCart(widget.variantId, "1")
                                        .then((value) async {
                                      if (value == AppString.success) {
                                        Navigator.of(context).pop();
                                        widget.ref.refresh(productDataProvider);
                                        widget.ref
                                            .refresh(cartDetailsDataProvider);
                                        widget.ref.refresh(
                                            productDetailsProvider(
                                                widget.productId));
                                        Fluttertoast.showToast(
                                            msg: AppString.addToCartSuccess,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 0,
                                            backgroundColor: AppColors.green,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.0);
                                      } else {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: AppString.oops,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 0,
                                            backgroundColor: AppColors.green,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.0);
                                      }
                                    });
                                  }
                                } else {
                                  CommonAlert.showAlertAndNavigateToLogin(
                                      context);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.tileColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              textStyle: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .addToCart
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  // fontSize:
                                  //     MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ))
                        : outOfStockCard()),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
              left: 5,
            ),
            // child: Divider(
            //   thickness: 1.5,
            // )
          )
        ]);
  }

  Widget outOfStockCard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(15), // Set the radius to 35
      ),
      child: const Text(
        AppString.outOfStock,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
