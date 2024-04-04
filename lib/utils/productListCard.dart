// productListCard

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/appColors.dart';
import '../models/shopifyModel/shared_preferences/SharedPreference.dart';
import '../services/shopifyServices/restAPIServices/product/productRepository.dart';
import 'appDimension.dart';
import 'appString.dart';
import 'cmsConfigue.dart';
import 'commonAlert.dart';

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
  final GestureTapCallback? shareProduct;
  final GestureTapCallback? onLiked;
  final num ratingCount;
  final String? isLikedToggle;
  final Widget? list;
  final String productId;
  final int stock;
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
    this.shareProduct,
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
  }) : super(key: key);

  @override
  State<ProductListCard> createState() => _ProductListCardstate();
}

class _ProductListCardstate extends State<ProductListCard> {
  double ratings = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String jwt_token = "";
  String userid = "";

  Future<bool> isLogin() async {
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Wrap(
                    // spacing: -10,
                    // space between two icons
                    runAlignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      //TODO list after API integration of wishlist
                      // Text(widget.issaved.toString()),
                      // // Text(widget.issavefortoggele.toString()),
                      // widget.issaved != "true" || widget.issaved == "null"
                      //     ? IconButton(
                      //   // padding: EdgeInsets.zero,
                      //     onPressed: widget.onsaved,
                      //     icon: widget.issavefortoggele != "-1"
                      //         ? Icon(
                      //       Icons.bookmark,
                      //       size: 25,
                      //     )
                      //         : Icon(
                      //       Icons.bookmark_add_outlined,
                      //       size: 25,
                      //     ))
                      //     : IconButton(
                      //   // padding: EdgeInsets.zero,
                      //     onPressed: widget.onsaved,
                      //     icon: widget.issavefortoggele == "-1"
                      //         ? Icon(
                      //       Icons.bookmark,
                      //       size: 25,
                      //     )
                      //         : Icon(
                      //       Icons.bookmark_add_outlined,
                      //       size: 25,
                      //     )),
                      // IconButton(
                      //     // padding: EdgeInsets.zero,
                      //     onPressed: widget.onLiked,
                      //     icon: widget.isLiked != "-1"
                      //         ? const Icon(
                      //             Icons.favorite,
                      //             size: 25,
                      //             color: Colors.red,
                      //           )
                      //         : const Icon(
                      //             Icons.favorite_border,
                      //             size: 25,
                      //           )),
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: widget.shareProduct,
                          icon: const Icon(
                            Icons.share,
                            size: 25,
                          )),
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
                          "${widget.productName}",
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
                    padding: EdgeInsets.only(right: 15),
                    child: widget.stock > 0
                        ? ElevatedButton(
                            onPressed: () async {
                              isLogin().then((value) {
                                if (value == true) {
                                  CommonAlert.show_loading_alert(context);
                                  log("varient id is this ${widget.variantId}");
                                  ProductRepository()
                                      .addToCart(widget.variantId, "1")
                                      .then((value) async {
                                    if (value == AppString.success) {
                                      Navigator.of(context).pop();
                                      widget.ref.refresh(productDataProvider);
                                      widget.ref
                                          .refresh(cartDetailsDataProvider);
                                      widget.ref.refresh(productDetailsProvider(
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
                              style: TextStyle(
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
