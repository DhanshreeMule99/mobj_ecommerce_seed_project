// CheckoutScreen

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobj_project/module/wishlist/wishlishScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../main.dart';
import '../../utils/api.dart';
import '../address/addressListScreen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  List<DraftOrderModel> cart = [];
  // double total = 0;
  List<String> ATT = [];
  API api = API();
  final couponApply = TextEditingController();

  void removeItem(LineItem item) {}

  @override
  void initState() {
    if (AppConfigure.megentoCommerce) {
      getTotalDetails();
      alreadyApplyCoupon();
    }
    super.initState();
  }

  ProductRepository apicall = ProductRepository();
  Future<void> getTotalDetails() async {
    String cartId = await SharedPreferenceManager().getDraftId();
    print("cart id is this $cartId");
    ATT.clear();
    if (cartId != "") {
      await apicall.getCarttotalDetails().then((value) {
        log("grand total is this $value");
        setState(() {
          ATT.addAll(value);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bigcommerceOrderedItems.clear();
    final product = ref.watch(cartDetailsDataProvider);
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) {
          return Scaffold(
            appBar: AppBar(
                // centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      size: 25.sp,
                    )),
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                surfaceTintColor: Theme.of(context).colorScheme.secondary,
                title: Text(
                  AppLocalizations.of(context)!.myBag,
                  style: Theme.of(context).textTheme.headlineLarge,
                )),
            bottomNavigationBar: MobjBottombar(
              bgcolor: AppColors.whiteColor,
              selcted_icon_color: AppColors.buttonColor,
              unselcted_icon_color: AppColors.blackColor,
              selectedPage: 1,
              screen1: const HomeScreen(),
              screen2: SearchWidget(),
              screen3: WishlistScreen(),
              screen4: const ProfileScreen(),
              ref: ref,
            ),
            body: product.when(
              data: (product) {
                DraftOrderModel productlist = product;
                for (var element in productlist.lineItems) {
                  bigcommerceOrderedItems.add(AppConfigure.wooCommerce
                      ? {
                          "product_id": element.productId,
                          "quantity": element.quantity
                        }
                      : {"item_id": element.id, "quantity": element.quantity});
                }

                return RefreshIndicator(
                  // Wrap the list in a RefreshIndicator widget
                  onRefresh: () async {
                    ref.refresh(cartDetailsDataProvider);
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: ListView.builder(
                                itemCount: productlist != []
                                    ? productlist.lineItems.length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final orderList =
                                      productlist.lineItems[index];

                                  debugPrint(
                                      'products are this $bigcommerceOrderedItems');
                                  return productlist.lineItems != []
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: GestureDetector(
                                              onTap: () {
                                                if (AppConfigure.wooCommerce) {
                                                } else {
                                                  ref.refresh(
                                                      productDetailsProvider(
                                                    AppConfigure.megentoCommerce
                                                        ? orderList.sku
                                                            .toString()
                                                        : orderList.productId
                                                            .toString(),
                                                  ));
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          ProductDetailsScreen(
                                                        sku: AppConfigure
                                                                .megentoCommerce
                                                            ? orderList.sku
                                                                .toString()
                                                            : "",
                                                        uid: orderList.productId
                                                            .toString(),
                                                      ),
                                                      transitionDuration:
                                                          Duration.zero,
                                                      reverseTransitionDuration:
                                                          Duration.zero,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Card(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 0),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child:
                                                      //  index == 0
                                                      //     ?
                                                      Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: SizedBox(
                                                            width: 90.sp,
                                                            height: 90.sp,
                                                            child: AppConfigure
                                                                    .megentoCommerce
                                                                ? SizedBox(
                                                                    child: Image
                                                                        .network(
                                                                            'https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg'),
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl: AppConfigure.bigCommerce ||
                                                                            AppConfigure
                                                                                .wooCommerce
                                                                        ? orderList
                                                                            .adminGraphqlApiId
                                                                        : (ref.watch(productImageDataProvider(orderList.productId.toString()))).when(
                                                                              data: (images) {
                                                                                if (images.isNotEmpty) {
                                                                                  // Find the image with the specified variant ID
                                                                                  final selectedImage = images.firstWhere(
                                                                                    (image) => image.variantIds.contains(orderList.variantId),
                                                                                    orElse: () => ProductImage(
                                                                                      id: 0,
                                                                                      // Provide a default ID
                                                                                      alt: "Default",
                                                                                      position: 0,
                                                                                      productId: 0,
                                                                                      createdAt: DateTime.now().toString(),
                                                                                      // Provide a default creation time
                                                                                      updatedAt: DateTime.now().toString(),
                                                                                      // Provide a default update time
                                                                                      adminGraphqlApiId: "gid://shopify/ProductImage/0",
                                                                                      width: 0,
                                                                                      height: 0,
                                                                                      src: images[0].src,
                                                                                      // Provide a default image URL
                                                                                      variantIds: [],
                                                                                    ),
                                                                                  );

                                                                                  return selectedImage.src;
                                                                                }
                                                                                return DefaultValues.defaultImagesSrc;
                                                                              },
                                                                              loading: () => DefaultValues.defaultImagesSrc,
                                                                              error: (_, __) => DefaultValues.defaultImagesSrc,
                                                                            ) ??
                                                                            DefaultValues.defaultImagesSrc,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      width:
                                                                          90.sp,
                                                                      height:
                                                                          90.sp,
                                                                      color: AppColors
                                                                          .greyShade,
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                    width:
                                                                        90.sp,
                                                                    height:
                                                                        90.sp,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .5,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  child: Text(
                                                                    orderList
                                                                        .name,
                                                                    maxLines: 2,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineLarge,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20.w,
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 20.sp,
                                                                    color:
                                                                        ConstColors
                                                                            .red
                                                                    // Theme.of(
                                                                    //         context)
                                                                    //     .colorScheme
                                                                    //     .onSecondaryContainer,
                                                                    ),
                                                                onPressed:
                                                                    () async {
                                                                  debugPrint(
                                                                      'id is this ${orderList.id}');
                                                                  String
                                                                      draftId =
                                                                      await SharedPreferenceManager()
                                                                          .getDraftId();
                                                                  CommonAlert
                                                                      .show_loading_alert(
                                                                          context);
                                                                  if (productlist
                                                                          .lineItems
                                                                          .length ==
                                                                      1) {
                                                                    if (AppConfigure
                                                                        .wooCommerce) {
                                                                      await SharedPreferenceManager()
                                                                          .setCartToken(
                                                                              "");
                                                                    } else if (AppConfigure
                                                                        .megentoCommerce) {
                                                                      log("delete by witch id ....................${orderList.id}");
                                                                      String
                                                                          userToken =
                                                                          await SharedPreferenceManager()
                                                                              .getToken();
                                                                      var response = await api
                                                                          .sendRequest
                                                                          .delete(
                                                                        'carts/mine/items/${orderList.id}',
                                                                        options:
                                                                            Options(headers: {
                                                                          "Authorization":
                                                                              "Bearer $userToken",
                                                                        }),
                                                                      );
                                                                      getTotalDetails();
                                                                      //  await SharedPreferenceManager()
                                                                      //     .setDraftId(
                                                                      //         "");

                                                                      ref.refresh(
                                                                          cartDetailsDataProvider);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      debugPrint(
                                                                          "cart item deleted successfully ${response.statusCode}");
                                                                      cartcount--;
                                                                    } else {
                                                                      await SharedPreferenceManager()
                                                                          .setDraftId(
                                                                              "");
                                                                    }

                                                                    ref.refresh(
                                                                      cartDetailsDataProvider,
                                                                    );
                                                                    //  ref.refresh(
                                                                    // cartTotalDetailsDataProvider);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  } else {
                                                                    productlist
                                                                        .lineItems
                                                                        .removeAt(
                                                                            index);
                                                                    setState(
                                                                        () {});
                                                                    final lineItemsList =
                                                                        productlist
                                                                            .lineItems;
                                                                    var reqBody =
                                                                        [];
                                                                    for (int i =
                                                                            0;
                                                                        i <=
                                                                            productlist.lineItems.length -
                                                                                1;
                                                                        i++) {
                                                                      reqBody
                                                                          .add({
                                                                        "variant_id":
                                                                            lineItemsList[i].variantId,
                                                                        "quantity":
                                                                            lineItemsList[i].quantity
                                                                      });
                                                                    }

                                                                    if (AppConfigure
                                                                        .bigCommerce) {
                                                                      var response =
                                                                          await ApiManager.delete(
                                                                              '${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}');

                                                                      ref.refresh(
                                                                          cartDetailsDataProvider);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      debugPrint(
                                                                          "cart item deleted successfully ${response.statusCode}");
                                                                      cartcount--;
                                                                    } else if (AppConfigure
                                                                        .wooCommerce) {
                                                                      String
                                                                          email =
                                                                          await SharedPreferenceManager()
                                                                              .getCartToken();
                                                                      var response =
                                                                          await ApiManager.delete(
                                                                              '${AppConfigure.woocommerceUrl}/wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$email');

                                                                      ref.refresh(
                                                                          cartDetailsDataProvider);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      debugPrint(
                                                                          "cart item deleted successfully ${response.statusCode}");
                                                                      cartcount--;
                                                                    } else if (AppConfigure
                                                                        .megentoCommerce) {
                                                                      log("delete by witch id ....................${orderList.id}");
                                                                      String
                                                                          userToken =
                                                                          await SharedPreferenceManager()
                                                                              .getToken();
                                                                      var response = await api
                                                                          .sendRequest
                                                                          .delete(
                                                                        'carts/mine/items/${orderList.id}',
                                                                        options:
                                                                            Options(headers: {
                                                                          "Authorization":
                                                                              "Bearer $userToken",
                                                                        }),
                                                                      );
                                                                      getTotalDetails();

                                                                      ref.refresh(
                                                                          cartDetailsDataProvider);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      debugPrint(
                                                                          "cart item deleted successfully ${response.statusCode}");
                                                                      cartcount--;
                                                                    } else {
                                                                      ProductRepository()
                                                                          .updateCart(
                                                                              reqBody)
                                                                          .then(
                                                                              (subjectFromServer) {
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        if (subjectFromServer ==
                                                                            AppString.success) {
                                                                          ref.refresh(
                                                                              cartDetailsDataProvider);
                                                                        }
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                            child: Text(
                                                              '\u{20B9}${(double.parse(orderList.price.toString()) * orderList.quantity).toStringAsFixed(2)}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium,
                                                            ),
                                                          ),
                                                          // SizedBox(
                                                          //   height: orderList
                                                          //               .name
                                                          //               .length >
                                                          //           22
                                                          //       ? 5.h
                                                          //       : 12.h,
                                                          // ),
                                                          SizedBox(
                                                            width: 232.w,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  width: 32.sp,
                                                                  height: 32.sp,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              15),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: Border.all(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onSecondaryContainer,
                                                                          width:
                                                                              2)),
                                                                  child:
                                                                      IconButton(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero, // Remove padding
                                                                    icon:
                                                                        const Icon(
                                                                      FontAwesomeIcons
                                                                          .minus,
                                                                    ), // Adjust icon size
                                                                    onPressed: AppConfigure
                                                                            .bigCommerce
                                                                        ? () async {
                                                                            if (orderList.quantity >
                                                                                1) {
                                                                              API api = API();
                                                                              try {
                                                                                String draftId = await SharedPreferenceManager().getDraftId();
                                                                                CommonAlert.show_loading_alert(context);

                                                                                orderList.quantity--;
                                                                                setState(() {});
                                                                                debugPrint('add maps');

                                                                                debugPrint('calling put api ');
                                                                                var response = await api.sendRequest.put(
                                                                                  '${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                                                  data: {
                                                                                    "line_item": {
                                                                                      "id": orderList.id,
                                                                                      "variant_id": orderList.variantId,
                                                                                      "product_id": orderList.productId,
                                                                                      "quantity": orderList.quantity,
                                                                                    }
                                                                                  },
                                                                                  options: Options(headers: {
                                                                                    "X-auth-Token": AppConfigure.bigCommerceAccessToken,
                                                                                    'Content-Type': 'application/json',
                                                                                  }),
                                                                                );

                                                                                ref.refresh(cartDetailsDataProvider);

                                                                                debugPrint('cart updated successfully ${response.statusCode}');
                                                                              } on Exception catch (e) {
                                                                                debugPrint(e.toString());
                                                                              } finally {
                                                                                Navigator.of(context).pop();
                                                                              }
                                                                            }
                                                                          }
                                                                        : AppConfigure.wooCommerce
                                                                            ? () async {
                                                                                if (orderList.quantity > 1) {
                                                                                  API api = API();
                                                                                  try {
                                                                                    String draftId = await SharedPreferenceManager().getDraftId();
                                                                                    CommonAlert.show_loading_alert(context);

                                                                                    orderList.quantity--;
                                                                                    setState(() {});
                                                                                    debugPrint('add maps');

                                                                                    debugPrint('calling put api ');
                                                                                    String cartToken = await SharedPreferenceManager().getCartToken();

                                                                                    var response = await api.sendRequest.post(
                                                                                      'wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$cartToken',
                                                                                      data: {
                                                                                        "quantity": orderList.quantity.toString()
                                                                                      },
                                                                                    );

                                                                                    ref.refresh(cartDetailsDataProvider);

                                                                                    debugPrint('cart updated successfully ${response.statusCode}');
                                                                                  } on Exception catch (e) {
                                                                                    debugPrint(e.toString());
                                                                                  } finally {
                                                                                    Navigator.of(context).pop();
                                                                                  }
                                                                                }
                                                                              }
                                                                            : AppConfigure.megentoCommerce
                                                                                ? () {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          // title: Text("Magento "),
                                                                                          content: Text("You can NOT decrement cart quantity. You should delete the cart."),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              child: Text("OK"),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                : () {
                                                                                    if (orderList.quantity > 1) {
                                                                                      setState(
                                                                                        () {
                                                                                          orderList.quantity--;
                                                                                          final lineItemsList = productlist.lineItems;
                                                                                          var reqBody = [];
                                                                                          for (int i = 0; i <= productlist.lineItems.length - 1; i++) {
                                                                                            reqBody.add({
                                                                                              "variant_id": lineItemsList[i].variantId,
                                                                                              "quantity": lineItemsList[i].quantity
                                                                                            });
                                                                                          }

                                                                                          CommonAlert.show_loading_alert(context);

                                                                                          ProductRepository().updateCart(reqBody).then((subjectFromServer) {
                                                                                            Navigator.of(context).pop();

                                                                                            if (subjectFromServer == AppString.success) {
                                                                                              ref.refresh(cartDetailsDataProvider);
                                                                                            }
                                                                                          });
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                  },
                                                                  ),

                                                                  //     IconButton(
                                                                  //   padding:
                                                                  //       EdgeInsets
                                                                  //           .zero,
                                                                  //   // Remove padding
                                                                  //   icon:
                                                                  //       const Icon(
                                                                  //     FontAwesomeIcons
                                                                  //         .minus,
                                                                  //   ),
                                                                  //   // Adjust icon size
                                                                  //   onPressed: AppConfigure
                                                                  //           .bigCommerce
                                                                  //       ? () async {
                                                                  //           if (orderList.quantity >
                                                                  //               1) {
                                                                  //             API api = API();
                                                                  //             try {
                                                                  //               String draftId = await SharedPreferenceManager().getDraftId();
                                                                  //               CommonAlert.show_loading_alert(context);

                                                                  //               orderList.quantity--;
                                                                  //               setState(() {});
                                                                  //               debugPrint('add maps');

                                                                  //               debugPrint('calling put api ');
                                                                  //               var response = await api.sendRequest.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                                  //                   data: {
                                                                  //                     "line_item": {
                                                                  //                       "id": orderList.id,
                                                                  //                       "variant_id": orderList.variantId,
                                                                  //                       "product_id": orderList.productId,
                                                                  //                       "quantity": orderList.quantity,
                                                                  //                     }
                                                                  //                   },
                                                                  //                   options: Options(headers: {
                                                                  //                     "X-auth-Token": AppConfigure.bigCommerceAccessToken,
                                                                  //                     'Content-Type': 'application/json',
                                                                  //                   }));

                                                                  //               // Response
                                                                  //               //     response =
                                                                  //               //     await ApiManager.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                                  //               //         body);

                                                                  //               ref.refresh(cartDetailsDataProvider);

                                                                  //               debugPrint('cart updated successfully ${response.statusCode}');
                                                                  //             } on Exception catch (e) {
                                                                  //               debugPrint(e.toString());
                                                                  //             } finally {
                                                                  //               Navigator.of(context).pop();
                                                                  //             }
                                                                  //           }
                                                                  //         }
                                                                  //       : AppConfigure.wooCommerce
                                                                  //           ? () async {
                                                                  //               if (orderList.quantity > 1) {
                                                                  //                 API api = API();
                                                                  //                 try {
                                                                  //                   String draftId = await SharedPreferenceManager().getDraftId();
                                                                  //                   CommonAlert.show_loading_alert(context);

                                                                  //                   orderList.quantity--;
                                                                  //                   setState(() {});
                                                                  //                   debugPrint('add maps');

                                                                  //                   debugPrint('calling put api ');
                                                                  //                   String cartToken = await SharedPreferenceManager().getCartToken();

                                                                  //                   var response = await api.sendRequest.post(
                                                                  //                     'wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$cartToken',
                                                                  //                     data: {
                                                                  //                       "quantity": orderList.quantity.toString()
                                                                  //                     },
                                                                  //                   );

                                                                  //                   ref.refresh(cartDetailsDataProvider);

                                                                  //                   debugPrint('cart updated successfully ${response.statusCode}');
                                                                  //                 } on Exception catch (e) {
                                                                  //                   debugPrint(e.toString());
                                                                  //                 } finally {
                                                                  //                   Navigator.of(context).pop();
                                                                  //                 }
                                                                  //               }
                                                                  //             }
                                                                  //           : () {
                                                                  //               if (orderList.quantity > 1) {
                                                                  //                 setState(
                                                                  //                   () {
                                                                  //                     orderList.quantity--;
                                                                  //                     final lineItemsList = productlist.lineItems;
                                                                  //                     var reqBody = [];
                                                                  //                     for (int i = 0; i <= productlist.lineItems.length - 1; i++) {
                                                                  //                       reqBody.add({
                                                                  //                         "variant_id": lineItemsList[i].variantId,
                                                                  //                         "quantity": lineItemsList[i].quantity
                                                                  //                       });
                                                                  //                     }

                                                                  //                     CommonAlert.show_loading_alert(context);
                                                                  //                     // getProductsByVariantId

                                                                  //                     ProductRepository().updateCart(reqBody).then((subjectFromServer) {
                                                                  //                       Navigator.of(context).pop();

                                                                  //                       if (subjectFromServer == AppString.success) {
                                                                  //                         ref.refresh(cartDetailsDataProvider);
                                                                  //                       }
                                                                  //                     });
                                                                  //                   },
                                                                  //                 );
                                                                  //               }
                                                                  //             },
                                                                  // ),
                                                                ),
                                                                Text(
                                                                  '${orderList.quantity}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineLarge,
                                                                ),
                                                                Container(
                                                                  width: 32.sp,
                                                                  height: 32.sp,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              15),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      border: Border.all(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          width:
                                                                              2)),
                                                                  child: IconButton(
                                                                      padding: EdgeInsets.zero,
                                                                      // Remove padding

                                                                      icon: Icon(
                                                                        FontAwesomeIcons
                                                                            .plus,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                      onPressed: () async {
                                                                        if (AppConfigure
                                                                            .bigCommerce) {
                                                                          API api =
                                                                              API();
                                                                          try {
                                                                            String
                                                                                draftId =
                                                                                await SharedPreferenceManager().getDraftId();
                                                                            CommonAlert.show_loading_alert(context);

                                                                            orderList.quantity++;
                                                                            setState(() {});
                                                                            debugPrint('add maps');

                                                                            debugPrint('calling put api ');
                                                                            var response = await api.sendRequest.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                                                data: {
                                                                                  "line_item": {
                                                                                    "id": orderList.id,
                                                                                    "variant_id": orderList.variantId,
                                                                                    "product_id": orderList.productId,
                                                                                    "quantity": orderList.quantity,
                                                                                  }
                                                                                },
                                                                                options: Options(headers: {
                                                                                  "X-auth-Token": AppConfigure.bigCommerceAccessToken,
                                                                                  'Content-Type': 'application/json',
                                                                                }));
                                                                            ref.refresh(cartDetailsDataProvider);

                                                                            debugPrint('cart updated successfully ${response.statusCode}');
                                                                          } on Exception catch (e) {
                                                                            debugPrint(e.toString());
                                                                          } finally {
                                                                            Navigator.of(context).pop();
                                                                          }
                                                                        } else if (AppConfigure
                                                                            .wooCommerce) {
                                                                          API api =
                                                                              API();
                                                                          try {
                                                                            String
                                                                                draftId =
                                                                                await SharedPreferenceManager().getDraftId();
                                                                            CommonAlert.show_loading_alert(context);

                                                                            orderList.quantity++;
                                                                            setState(() {});
                                                                            debugPrint('add maps');

                                                                            debugPrint('calling put api ');
                                                                            String
                                                                                cartToken =
                                                                                await SharedPreferenceManager().getCartToken();

                                                                            var response =
                                                                                await api.sendRequest.post(
                                                                              'wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$cartToken',
                                                                              data: {
                                                                                "quantity": orderList.quantity.toString()
                                                                              },
                                                                            );

                                                                            ref.refresh(cartDetailsDataProvider);

                                                                            debugPrint('cart updated successfully ${response.statusCode}');
                                                                          } on Exception catch (e) {
                                                                            debugPrint(e.toString());
                                                                          } finally {
                                                                            Navigator.of(context).pop();
                                                                          }
                                                                        } else if (AppConfigure
                                                                            .megentoCommerce) {
                                                                          API api =
                                                                              API();
                                                                          try {
                                                                            String
                                                                                draftId =
                                                                                await SharedPreferenceManager().getDraftId();
                                                                            CommonAlert.show_loading_alert(context);

                                                                            orderList.quantity++;
                                                                            setState(() {});
                                                                            debugPrint('add maps................${orderList.sku}');

                                                                            debugPrint('calling put api  $draftId ');
                                                                            var response =
                                                                                await api.sendRequest.put(
                                                                              'carts/mine/items/${orderList.id}',
                                                                              data: {
                                                                                "cart_item": {
                                                                                  "quote_id": draftId,
                                                                                  "sku": orderList.sku,
                                                                                  "qty": 1
                                                                                }
                                                                              },
                                                                              options: Options(headers: {
                                                                                'Authorization': 'Bearer ${AppConfigure.megentoCunsumerAccessToken}',
                                                                              }),
                                                                            );

                                                                            await getTotalDetails();
                                                                            ref.refresh(cartDetailsDataProvider);

                                                                            debugPrint('cart updated successfully ${response.statusCode}');
                                                                          } on Exception catch (e) {
                                                                            debugPrint(e.toString());
                                                                          } finally {
                                                                            Navigator.of(context).pop();
                                                                          }
                                                                        } else {
                                                                          final price = double.parse(orderList
                                                                              .price
                                                                              .toString());
                                                                          CommonAlert.show_loading_alert(
                                                                              context);
                                                                          ProductRepository()
                                                                              .getProductsByVariantId(orderList.variantId.toString(), orderList.productId.toString())
                                                                              .then((subjectFromServer) {
                                                                            if (orderList.quantity <
                                                                                subjectFromServer.inventoryQuantity) {
                                                                              setState(
                                                                                () {
                                                                                  orderList.quantity++;
                                                                                  final lineItemsList = productlist.lineItems;
                                                                                  var reqBody = [];
                                                                                  for (int i = 0; i <= productlist.lineItems.length - 1; i++) {
                                                                                    reqBody.add({
                                                                                      "variant_id": lineItemsList[i].variantId,
                                                                                      "quantity": lineItemsList[i].quantity
                                                                                    });
                                                                                  }

                                                                                  ProductRepository().updateCart(reqBody).then((subjectFromServers) {
                                                                                    Navigator.of(context).pop();

                                                                                    if (subjectFromServers == AppString.success) {
                                                                                      ref.refresh(cartDetailsDataProvider);
                                                                                    }
                                                                                  });
                                                                                },
                                                                              );
                                                                            } else {
                                                                              Navigator.of(context).pop();
                                                                              Fluttertoast.showToast(msg: "Only ${subjectFromServer.inventoryQuantity} left in stock", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 0, backgroundColor: AppColors.blackColor, textColor: AppColors.whiteColor, fontSize: 16.0);
                                                                            }
                                                                            // });
                                                                          });
                                                                        }
                                                                      }),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )

                                                  // : ListTile(
                                                  //     contentPadding:
                                                  //         EdgeInsets.zero,
                                                  //     minVerticalPadding: 0,
                                                  //     dense: false,
                                                  //     visualDensity:
                                                  //         const VisualDensity(
                                                  //             horizontal: 4,
                                                  //             vertical: 4),
                                                  //     leading: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(
                                                  //               left: 5),
                                                  //       child: Container(
                                                  //         width: 100.sp,
                                                  //         height: 100,
                                                  //         color: Colors.red,
                                                  //         child:
                                                  //             CachedNetworkImage(
                                                  //           imageUrl: AppConfigure
                                                  //                       .bigCommerce ||
                                                  //                   AppConfigure
                                                  //                       .wooCommerce
                                                  //               ? orderList
                                                  //                   .adminGraphqlApiId
                                                  //               : (ref.watch(productImageDataProvider(orderList
                                                  //                           .productId
                                                  //                           .toString())))
                                                  //                       .when(
                                                  //                     data:
                                                  //                         (images) {
                                                  //                       if (images
                                                  //                           .isNotEmpty) {
                                                  //                         // Find the image with the specified variant ID
                                                  //                         final selectedImage =
                                                  //                             images.firstWhere(
                                                  //                           (image) => image.variantIds.contains(orderList.variantId),
                                                  //                           orElse: () => ProductImage(
                                                  //                             id: 0,
                                                  //                             // Provide a default ID
                                                  //                             alt: "Default",
                                                  //                             position: 0,
                                                  //                             productId: 0,
                                                  //                             createdAt: DateTime.now().toString(),
                                                  //                             // Provide a default creation time
                                                  //                             updatedAt: DateTime.now().toString(),
                                                  //                             // Provide a default update time
                                                  //                             adminGraphqlApiId: "gid://shopify/ProductImage/0",
                                                  //                             width: 0,
                                                  //                             height: 0,
                                                  //                             src: images[0].src,
                                                  //                             // Provide a default image URL
                                                  //                             variantIds: [],
                                                  //                           ),
                                                  //                         );

                                                  //                         return selectedImage.src;
                                                  //                       }
                                                  //                       return DefaultValues
                                                  //                           .defaultImagesSrc;
                                                  //                     },
                                                  //                     loading:
                                                  //                         () =>
                                                  //                             DefaultValues.defaultImagesSrc,
                                                  //                     error: (_,
                                                  //                             __) =>
                                                  //                         DefaultValues.defaultImagesSrc,
                                                  //                   ) ??
                                                  //                   DefaultValues
                                                  //                       .defaultImagesSrc,
                                                  //           placeholder:
                                                  //               (context,
                                                  //                       url) =>
                                                  //                   Container(
                                                  //             width: 100.sp,
                                                  //             height: 100.sp,
                                                  //             color: AppColors
                                                  //                 .greyShade,
                                                  //           ),
                                                  //           errorWidget: (context,
                                                  //                   url,
                                                  //                   error) =>
                                                  //               const Icon(Icons
                                                  //                   .error),
                                                  //           width: 100.sp,
                                                  //           height: 100.sp,
                                                  //           fit: BoxFit
                                                  //               .contain,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     title: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(
                                                  //               top: 10,
                                                  //               left: 0),
                                                  //       child: Text(
                                                  //           orderList.name),
                                                  //     ),
                                                  //     subtitle: Padding(
                                                  //         padding:
                                                  //             const EdgeInsets
                                                  //                 .only(
                                                  //                 top: 5,
                                                  //                 left: 0),
                                                  //         child: Column(
                                                  //           crossAxisAlignment:
                                                  //               CrossAxisAlignment
                                                  //                   .start,
                                                  //           children: [
                                                  //             Text(
                                                  //               '${AppLocalizations.of(context)!.price}: \u{20B9}${(double.parse(orderList.price.toString()) * orderList.quantity).toStringAsFixed(2)}',
                                                  //             ),
                                                  //             const SizedBox(
                                                  //               height: 5,
                                                  //             ),
                                                  //           ],
                                                  //         )),
                                                  //     trailing: Row(
                                                  //       mainAxisSize:
                                                  //           MainAxisSize.min,
                                                  //       children: [
                                                  //         Container(
                                                  //           decoration:
                                                  //               BoxDecoration(
                                                  //             border: Border.all(
                                                  //                 color: AppColors
                                                  //                     .blackColor,
                                                  //                 width: 1.5),
                                                  //             borderRadius:
                                                  //                 BorderRadius.circular(
                                                  //                     AppDimension
                                                  //                         .buttonRadius),
                                                  //           ),
                                                  //           child: Row(
                                                  //             mainAxisSize:
                                                  //                 MainAxisSize
                                                  //                     .min,
                                                  //             children: [
                                                  //               IconButton(
                                                  //                 padding:
                                                  //                     EdgeInsets
                                                  //                         .zero,
                                                  //                 // Remove padding
                                                  //                 icon:
                                                  //                     const Icon(
                                                  //                   Icons
                                                  //                       .remove,
                                                  //                 ),
                                                  //                 // Adjust icon size
                                                  //                 onPressed: AppConfigure
                                                  //                         .bigCommerce
                                                  //                     ? () async {
                                                  //                         if (orderList.quantity >
                                                  //                             1) {
                                                  //                           API api = API();
                                                  //                           try {
                                                  //                             String draftId = await SharedPreferenceManager().getDraftId();
                                                  //                             CommonAlert.show_loading_alert(context);

                                                  //                             orderList.quantity--;
                                                  //                             setState(() {});
                                                  //                             debugPrint('add maps');

                                                  //                             debugPrint('calling put api ');
                                                  //                             var response = await api.sendRequest.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                  //                                 data: {
                                                  //                                   "line_item": {
                                                  //                                     "id": orderList.id,
                                                  //                                     "variant_id": orderList.variantId,
                                                  //                                     "product_id": orderList.productId,
                                                  //                                     "quantity": orderList.quantity,
                                                  //                                   }
                                                  //                                 },
                                                  //                                 options: Options(headers: {
                                                  //                                   "X-auth-Token": AppConfigure.bigCommerceAccessToken,
                                                  //                                   'Content-Type': 'application/json',
                                                  //                                 }));

                                                  //                             // Response
                                                  //                             //     response =
                                                  //                             //     await ApiManager.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                  //                             //         body);

                                                  //                             ref.refresh(cartDetailsDataProvider);

                                                  //                             debugPrint('cart updated successfully ${response.statusCode}');
                                                  //                           } on Exception catch (e) {
                                                  //                             debugPrint(e.toString());
                                                  //                           } finally {
                                                  //                             Navigator.of(context).pop();
                                                  //                           }
                                                  //                         }
                                                  //                       }
                                                  //                     : AppConfigure.wooCommerce
                                                  //                         ? () async {
                                                  //                             if (orderList.quantity > 1) {
                                                  //                               API api = API();
                                                  //                               try {
                                                  //                                 String draftId = await SharedPreferenceManager().getDraftId();
                                                  //                                 CommonAlert.show_loading_alert(context);

                                                  //                                 orderList.quantity--;
                                                  //                                 setState(() {});
                                                  //                                 debugPrint('add maps');

                                                  //                                 debugPrint('calling put api ');
                                                  //                                 String cartToken = await SharedPreferenceManager().getCartToken();

                                                  //                                 var response = await api.sendRequest.post(
                                                  //                                   'wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$cartToken',
                                                  //                                   data: {
                                                  //                                     "quantity": orderList.quantity.toString()
                                                  //                                   },
                                                  //                                 );

                                                  //                                 ref.refresh(cartDetailsDataProvider);

                                                  //                                 debugPrint('cart updated successfully ${response.statusCode}');
                                                  //                               } on Exception catch (e) {
                                                  //                                 debugPrint(e.toString());
                                                  //                               } finally {
                                                  //                                 Navigator.of(context).pop();
                                                  //                               }
                                                  //                             }
                                                  //                           }
                                                  //                         : () {
                                                  //                             if (orderList.quantity > 1) {
                                                  //                               setState(
                                                  //                                 () {
                                                  //                                   orderList.quantity--;
                                                  //                                   final lineItemsList = productlist.lineItems;
                                                  //                                   var reqBody = [];
                                                  //                                   for (int i = 0; i <= productlist.lineItems.length - 1; i++) {
                                                  //                                     reqBody.add({
                                                  //                                       "variant_id": lineItemsList[i].variantId,
                                                  //                                       "quantity": lineItemsList[i].quantity
                                                  //                                     });
                                                  //                                   }

                                                  //                                   CommonAlert.show_loading_alert(context);
                                                  //                                   // getProductsByVariantId

                                                  //                                   ProductRepository().updateCart(reqBody).then((subjectFromServer) {
                                                  //                                     Navigator.of(context).pop();

                                                  //                                     if (subjectFromServer == AppString.success) {
                                                  //                                       ref.refresh(cartDetailsDataProvider);
                                                  //                                     }
                                                  //                                   });
                                                  //                                 },
                                                  //                               );
                                                  //                             }
                                                  //                           },
                                                  //               ),
                                                  //               Text(
                                                  //                   '${orderList.quantity}'),
                                                  //               IconButton(
                                                  //                 padding:
                                                  //                     EdgeInsets
                                                  //                         .zero,
                                                  //                 // Remove padding

                                                  //                 icon:
                                                  //                     const Icon(
                                                  //                   Icons.add,
                                                  //                 ),
                                                  //                 onPressed: AppConfigure
                                                  //                         .bigCommerce
                                                  //                     ? () async {
                                                  //                         API api =
                                                  //                             API();
                                                  //                         try {
                                                  //                           String draftId = await SharedPreferenceManager().getDraftId();
                                                  //                           CommonAlert.show_loading_alert(context);

                                                  //                           orderList.quantity++;
                                                  //                           setState(() {});
                                                  //                           debugPrint('add maps');

                                                  //                           debugPrint('calling put api ');
                                                  //                           var response = await api.sendRequest.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                  //                               data: {
                                                  //                                 "line_item": {
                                                  //                                   "id": orderList.id,
                                                  //                                   "variant_id": orderList.variantId,
                                                  //                                   "product_id": orderList.productId,
                                                  //                                   "quantity": orderList.quantity,
                                                  //                                 }
                                                  //                               },
                                                  //                               options: Options(headers: {
                                                  //                                 "X-auth-Token": AppConfigure.bigCommerceAccessToken,
                                                  //                                 'Content-Type': 'application/json',
                                                  //                               }));

                                                  //                           // Response
                                                  //                           //     response =
                                                  //                           //     await ApiManager.put('${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}',
                                                  //                           //         body);

                                                  //                           ref.refresh(cartDetailsDataProvider);

                                                  //                           debugPrint('cart updated successfully ${response.statusCode}');
                                                  //                         } on Exception catch (e) {
                                                  //                           debugPrint(e.toString());
                                                  //                         } finally {
                                                  //                           Navigator.of(context).pop();
                                                  //                         }
                                                  //                       }
                                                  //                     : AppConfigure.wooCommerce
                                                  //                         ? () async {
                                                  //                             API api = API();
                                                  //                             try {
                                                  //                               String draftId = await SharedPreferenceManager().getDraftId();
                                                  //                               CommonAlert.show_loading_alert(context);

                                                  //                               orderList.quantity++;
                                                  //                               setState(() {});
                                                  //                               debugPrint('add maps');

                                                  //                               debugPrint('calling put api ');
                                                  //                               String cartToken = await SharedPreferenceManager().getCartToken();

                                                  //                               var response = await api.sendRequest.post(
                                                  //                                 'wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$cartToken',
                                                  //                                 data: {
                                                  //                                   "quantity": orderList.quantity.toString()
                                                  //                                 },
                                                  //                               );

                                                  //                               ref.refresh(cartDetailsDataProvider);

                                                  //                               debugPrint('cart updated successfully ${response.statusCode}');
                                                  //                             } on Exception catch (e) {
                                                  //                               debugPrint(e.toString());
                                                  //                             } finally {
                                                  //                               Navigator.of(context).pop();
                                                  //                             }
                                                  //                           }
                                                  //                         : () {
                                                  //                             final price = double.parse(orderList.price.toString());
                                                  //                             CommonAlert.show_loading_alert(context);
                                                  //                             ProductRepository().getProductsByVariantId(orderList.variantId.toString(), orderList.productId.toString()).then((subjectFromServer) {
                                                  //                               if (orderList.quantity < subjectFromServer.inventoryQuantity) {
                                                  //                                 setState(
                                                  //                                   () {
                                                  //                                     orderList.quantity++;
                                                  //                                     final lineItemsList = productlist.lineItems;
                                                  //                                     var reqBody = [];
                                                  //                                     for (int i = 0; i <= productlist.lineItems.length - 1; i++) {
                                                  //                                       reqBody.add({
                                                  //                                         "variant_id": lineItemsList[i].variantId,
                                                  //                                         "quantity": lineItemsList[i].quantity
                                                  //                                       });
                                                  //                                     }

                                                  //                                     ProductRepository().updateCart(reqBody).then((subjectFromServers) {
                                                  //                                       Navigator.of(context).pop();

                                                  //                                       if (subjectFromServers == AppString.success) {
                                                  //                                         ref.refresh(cartDetailsDataProvider);
                                                  //                                       }
                                                  //                                     });
                                                  //                                   },
                                                  //                                 );
                                                  //                               } else {
                                                  //                                 Navigator.of(context).pop();
                                                  //                                 Fluttertoast.showToast(msg: "Only ${subjectFromServer.inventoryQuantity} left in stock", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 0, backgroundColor: AppColors.blackColor, textColor: AppColors.whiteColor, fontSize: 16.0);
                                                  //                               }
                                                  //                               // });
                                                  //                             });
                                                  //                           },
                                                  //               )
                                                  //             ],
                                                  //           ),
                                                  //         ),
                                                  //         IconButton(
                                                  //           icon: const Icon(
                                                  //               Icons.delete),
                                                  //           onPressed:
                                                  //               () async {
                                                  //             debugPrint(
                                                  //                 'id is this ${orderList.id}');
                                                  //             String draftId =
                                                  //                 await SharedPreferenceManager()
                                                  //                     .getDraftId();
                                                  //             CommonAlert
                                                  //                 .show_loading_alert(
                                                  //                     context);
                                                  //             if (productlist
                                                  //                     .lineItems
                                                  //                     .length ==
                                                  //                 1) {
                                                  //               if (AppConfigure
                                                  //                   .wooCommerce) {
                                                  //                 await SharedPreferenceManager()
                                                  //                     .setCartToken(
                                                  //                         "");
                                                  //               } else {
                                                  //                 await SharedPreferenceManager()
                                                  //                     .setDraftId(
                                                  //                         "");
                                                  //               }

                                                  //               ref.refresh(
                                                  //                   cartDetailsDataProvider);
                                                  //               Navigator.of(
                                                  //                       context)
                                                  //                   .pop();
                                                  //             } else {
                                                  //               productlist
                                                  //                   .lineItems
                                                  //                   .removeAt(
                                                  //                       index);
                                                  //               setState(
                                                  //                   () {});
                                                  //               final lineItemsList =
                                                  //                   productlist
                                                  //                       .lineItems;
                                                  //               var reqBody =
                                                  //                   [];
                                                  //               for (int i =
                                                  //                       0;
                                                  //                   i <=
                                                  //                       productlist.lineItems.length -
                                                  //                           1;
                                                  //                   i++) {
                                                  //                 reqBody
                                                  //                     .add({
                                                  //                   "variant_id":
                                                  //                       lineItemsList[i]
                                                  //                           .variantId,
                                                  //                   "quantity":
                                                  //                       lineItemsList[i]
                                                  //                           .quantity
                                                  //                 });
                                                  //               }

                                                  //               if (AppConfigure
                                                  //                   .bigCommerce) {
                                                  //                 var response =
                                                  //                     await ApiManager.delete(
                                                  //                         '${AppConfigure.bigcommerceUrl}/carts/$draftId/items/${orderList.id}');

                                                  //                 ref.refresh(
                                                  //                     cartDetailsDataProvider);
                                                  //                 Navigator.of(
                                                  //                         context)
                                                  //                     .pop();
                                                  //                 debugPrint(
                                                  //                     "cart item deleted successfully ${response.statusCode}");
                                                  //               } else if (AppConfigure
                                                  //                   .wooCommerce) {
                                                  //                 String
                                                  //                     email =
                                                  //                     await SharedPreferenceManager()
                                                  //                         .getCartToken();
                                                  //                 var response =
                                                  //                     await ApiManager.delete(
                                                  //                         '${AppConfigure.woocommerceUrl}/wp-json/cocart/v2/cart/item/${orderList.id}?cart_key=$email');

                                                  //                 ref.refresh(
                                                  //                     cartDetailsDataProvider);
                                                  //                 Navigator.of(
                                                  //                         context)
                                                  //                     .pop();
                                                  //                 debugPrint(
                                                  //                     "cart item deleted successfully ${response.statusCode}");
                                                  //               } else {
                                                  //                 ProductRepository()
                                                  //                     .updateCart(
                                                  //                         reqBody)
                                                  //                     .then(
                                                  //                         (subjectFromServer) {
                                                  //                   Navigator.of(
                                                  //                           context)
                                                  //                       .pop();

                                                  //                   if (subjectFromServer ==
                                                  //                       AppString
                                                  //                           .success) {
                                                  //                     ref.refresh(
                                                  //                         cartDetailsDataProvider);
                                                  //                   }
                                                  //                 });
                                                  //               }
                                                  //             }
                                                  //           },
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ),

                                                  )))
                                      : const Center(
                                          child: ErrorHandling(
                                            error_type: AppString.noDataError,
                                          ),
                                        );
                                })),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(
                                thickness: 1.5,
                                color: AppColors.greyShade,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: couponApply,
                                // keyboardType: TextInputType.text,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(
                                //       RegExp(r'.*'))
                                // ],
                                // decoration: InputDecoration(
                                //   labelText: AppLocalizations.of(context)!.personNameLabel,
                                //   enabledBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,), // Color when enabled
                                //   ),
                                //   focusedBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,), // Color when focused
                                //   ),
                                // ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,

                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontSize: 12),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10),
                                    label: Text(
                                      "Enter Coupon",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    suffixIcon: TextButton(
                                      onPressed: () {
                                        log("coupon is this ${couponApply.text}");
                                        if (couponApply.text.trim() != "") {
                                          ApplyCoupon();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Please enter coupon');
                                        }
                                      },
                                      child: Text('APPLY',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    border: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1.5,
                                        )),
                                    //normal border
                                    enabledBorder: OutlineInputBorder(
                                        //Outline  order type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1.5,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 1.5))),
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
                                ],

                                validator: (value) {
                                  return Validation().nameValidation(value);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context)!.actualPrice}:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                      AppConfigure.megentoCommerce
                                          ? '\u{20B9}${ATT.first}'
                                          : '\u{20B9}${product.subtotalPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${AppLocalizations.of(context)!.tax}:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                      AppConfigure.megentoCommerce
                                          ? '\u{20B9}${ATT[1]}'
                                          : product.totalTax == ""
                                              ? '\u{20B9}${0}'
                                              : '\u{20B9}${product.totalTax}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context)!.total}:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                      AppConfigure.megentoCommerce
                                          ? '\u{20B9}${ATT.last}'
                                          : '\u{20B9}${product.totalPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, left: 0, right: 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              AddressListScreen(
                                            actualPrice:
                                                AppConfigure.megentoCommerce
                                                    ? ATT.first.toString()
                                                    : "",
                                            tax: AppConfigure.megentoCommerce
                                                ? ATT[1].toString()
                                                : "",
                                            totalPrice:
                                                AppConfigure.megentoCommerce
                                                    ? ATT.last.toString()
                                                    : "",
                                            isCheckout: true,
                                            amount: AppConfigure.megentoCommerce
                                                ? int.parse(
                                                        ATT.last.toString()) *
                                                    100
                                                : product.totalPrice.toInt() *
                                                    100,
                                            mobile: product.customer.phone
                                                .toString(),
                                            bigcommerceOrderedItems:
                                                bigcommerceOrderedItems,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      minimumSize: const Size.fromHeight(50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimension.buttonRadius)),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .next
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    )),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ]),
                );
              },
              error: (error, s) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: ErrorHandling(
                      error_type: error != AppString.noDataError
                          ? AppString.error
                          : AppString.noDataError,
                    ),
                  ),
                  error == AppString.noDataError
                      ? Text(AppLocalizations.of(context)!.emptyCart,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold))
                      : Container(),
                  error != AppString.noDataError
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                          ),
                          onPressed: () {
                            ref.refresh(cartDetailsDataProvider);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.refresh,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              loading: () => const SkeletonLoaderWidget(),
            ),
          );
        },
        error: (error, s) => Container(),
        loading: () => Container());
  }

  Future<void> ApplyCoupon() async {
    String token = await SharedPreferenceManager().getToken();

    try {
      Response response = await api.sendRequest.put(
          'carts/mine/coupons/${couponApply.text}',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Coupon applied successfully');
        getTotalDetails();
      } else {}
    } on Exception catch (e) {
      log('appply coupon error is this $e');
      Fluttertoast.showToast(msg: 'Coupon is not valid');
      rethrow;
    }
  }

  Future<void> alreadyApplyCoupon() async {
    String token = await SharedPreferenceManager().getToken();

    try {
      Response response = await api.sendRequest.get('carts/mine/coupons',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        setState(() {
          couponApply.text = response.data.toString();
        });
      } else {}
    } on Exception catch (e) {
      
      rethrow;
    }
  }
}
