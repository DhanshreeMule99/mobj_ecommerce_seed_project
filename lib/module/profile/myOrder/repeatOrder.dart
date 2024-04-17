// RepeatOrderScreen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobj_project/models/shopifyModel/product/draftOrderModel.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../main.dart';
import '../../address/addressListScreen.dart';

class RepeatOrderScreen extends ConsumerStatefulWidget {
  final String orderId;
  RepeatOrderScreen({
    super.key,
    required this.orderId,
  });

  @override
  _RepeatOrderScreenState createState() => _RepeatOrderScreenState();
}

class _RepeatOrderScreenState extends ConsumerState<RepeatOrderScreen> {
  List<DraftOrderModel> cart = [];
  double total = 0;

  void removeItem(LineItem item) {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(repeatOrderProvider(widget.orderId));
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) {
          return Scaffold(
            appBar: AppBar(
                elevation: 1,
                title: Text(
                  AppLocalizations.of(context)!.orderDetailsTitle,
                )),
            bottomNavigationBar: MobjBottombar(
              bgcolor: AppColors.whiteColor,
              selcted_icon_color: AppColors.buttonColor,
              unselcted_icon_color: AppColors.blackColor,
              selectedPage: 2,
              screen1: HomeScreen(),
              screen2: SearchWidget(),
              screen3: HomeScreen(),
              screen4: ProfileScreen(),
              ref: ref,
            ),
            body: product.when(
              data: (product) {
                DraftOrderModel productlist = product;

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
                                  return productlist.lineItems != []
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: GestureDetector(
                                              onTap: () {
                                                ref.refresh(
                                                    productDetailsProvider(
                                                  orderList.productId
                                                      .toString(),
                                                ));
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation1,
                                                            animation2) =>
                                                        ProductDetailsScreen(
                                                      uid: orderList.productId
                                                          .toString(),
                                                    ),
                                                    transitionDuration:
                                                        Duration.zero,
                                                    reverseTransitionDuration:
                                                        Duration.zero,
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                margin: const EdgeInsets.only(
                                                    bottom: 0),
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: CachedNetworkImage(
                                                      imageUrl: (ref.watch(
                                                                  productImageDataProvider(
                                                                      orderList
                                                                          .productId
                                                                          .toString())))
                                                              .when(
                                                            data: (images) {
                                                              if (images
                                                                  .isNotEmpty) {
                                                                // Find the image with the specified variant ID
                                                                final selectedImage =
                                                                    images
                                                                        .firstWhere(
                                                                  (image) => image
                                                                      .variantIds
                                                                      .contains(
                                                                          orderList
                                                                              .variantId),
                                                                  orElse: () =>
                                                                      ProductImage(
                                                                    id: 0,
                                                                    // Provide a default ID
                                                                    alt:
                                                                        "Default",
                                                                    position: 0,
                                                                    productId:
                                                                        0,
                                                                    createdAt: DateTime
                                                                            .now()
                                                                        .toString(),
                                                                    // Provide a default creation time
                                                                    updatedAt: DateTime
                                                                            .now()
                                                                        .toString(),
                                                                    // Provide a default update time
                                                                    adminGraphqlApiId:
                                                                        "gid://shopify/ProductImage/0",
                                                                    width: 0,
                                                                    height: 0,
                                                                    src: images[
                                                                            0]
                                                                        .src,
                                                                    // Provide a default image URL
                                                                    variantIds: [],
                                                                  ),
                                                                );

                                                                return selectedImage
                                                                    .src;
                                                              }
                                                              return DefaultValues
                                                                  .defaultImagesSrc;
                                                            },
                                                            loading: () =>
                                                                DefaultValues
                                                                    .defaultImagesSrc,
                                                            error: (_, __) =>
                                                                DefaultValues
                                                                    .defaultImagesSrc,
                                                          ) ??
                                                          DefaultValues
                                                              .defaultImagesSrc,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 50,
                                                        width: 50,
                                                        color:
                                                            AppColors.greyShade,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, left: 0),
                                                    child: Text(orderList.name),
                                                  ),
                                                  subtitle: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5, left: 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${AppLocalizations.of(context)!.price}: \u{20B9}${(double.parse(orderList.price.toString()) * orderList.quantity).toStringAsFixed(2)}',
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      )),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .blackColor,
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  AppDimension
                                                                      .buttonRadius),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              // Remove padding
                                                              icon: const Icon(
                                                                Icons.remove,
                                                              ),
                                                              // Adjust icon size
                                                              onPressed: () {
                                                                if (orderList
                                                                        .quantity >
                                                                    1) {
                                                                  setState(
                                                                    () {
                                                                      orderList
                                                                          .quantity--;
                                                                      final lineItemsList =
                                                                          productlist
                                                                              .lineItems;
                                                                      var reqBody =
                                                                          [];
                                                                      for (int i =
                                                                              0;
                                                                          i <=
                                                                              productlist.lineItems.length - 1;
                                                                          i++) {
                                                                        reqBody
                                                                            .add({
                                                                          "variant_id":
                                                                              lineItemsList[i].variantId,
                                                                          "quantity":
                                                                              lineItemsList[i].quantity
                                                                        });
                                                                      }

                                                                      CommonAlert
                                                                          .show_loading_alert(
                                                                              context);
                                                                      // getProductsByVariantId

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
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                                '${orderList.quantity}'),
                                                            IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              // Remove padding

                                                              icon: const Icon(
                                                                Icons.add,
                                                              ),
                                                              onPressed: () {
                                                                final price =
                                                                    double.parse(
                                                                        orderList
                                                                            .price
                                                                            .toString());
                                                                CommonAlert
                                                                    .show_loading_alert(
                                                                        context);
                                                                ProductRepository()
                                                                    .getProductsByVariantId(
                                                                        orderList
                                                                            .variantId
                                                                            .toString(),
                                                                        orderList
                                                                            .productId
                                                                            .toString())
                                                                    .then(
                                                                        (subjectFromServer) {
                                                                  if (orderList
                                                                          .quantity <
                                                                      subjectFromServer
                                                                          .inventoryQuantity) {
                                                                    setState(
                                                                      () {
                                                                        orderList
                                                                            .quantity++;
                                                                        final lineItemsList =
                                                                            productlist.lineItems;
                                                                        var reqBody =
                                                                            [];
                                                                        for (int i =
                                                                                0;
                                                                            i <=
                                                                                productlist.lineItems.length - 1;
                                                                            i++) {
                                                                          reqBody
                                                                              .add({
                                                                            "variant_id":
                                                                                lineItemsList[i].variantId,
                                                                            "quantity":
                                                                                lineItemsList[i].quantity
                                                                          });
                                                                        }

                                                                        ProductRepository()
                                                                            .updateCart(reqBody)
                                                                            .then((subjectFromServers) {
                                                                          Navigator.of(context)
                                                                              .pop();

                                                                          if (subjectFromServers ==
                                                                              AppString.success) {
                                                                            ref.refresh(cartDetailsDataProvider);
                                                                          }
                                                                        });
                                                                      },
                                                                    );
                                                                  } else {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Only ${subjectFromServer.inventoryQuantity} left in stock",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .BOTTOM,
                                                                        timeInSecForIosWeb:
                                                                            0,
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .blackColor,
                                                                        textColor:
                                                                            AppColors
                                                                                .whiteColor,
                                                                        fontSize:
                                                                            16.0);
                                                                  }
                                                                  // });
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        onPressed: () async {
                                                          CommonAlert
                                                              .show_loading_alert(
                                                                  context);
                                                          if (productlist
                                                                  .lineItems
                                                                  .length ==
                                                              1) {
                                                            await SharedPreferenceManager()
                                                                .setDraftId("");
                                                            ref.refresh(
                                                                cartDetailsDataProvider);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else {
                                                            setState(
                                                              () {
                                                                productlist
                                                                    .lineItems
                                                                    .removeAt(
                                                                        index);
                                                                final lineItemsList =
                                                                    productlist
                                                                        .lineItems;
                                                                var reqBody =
                                                                    [];
                                                                for (int i = 0;
                                                                    i <=
                                                                        productlist.lineItems.length -
                                                                            1;
                                                                    i++) {
                                                                  reqBody.add({
                                                                    "variant_id":
                                                                        lineItemsList[i]
                                                                            .variantId,
                                                                    "quantity":
                                                                        lineItemsList[i]
                                                                            .quantity
                                                                  });
                                                                }

                                                                ProductRepository()
                                                                    .updateCart(
                                                                        reqBody)
                                                                    .then(
                                                                        (subjectFromServer) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  if (subjectFromServer ==
                                                                      AppString
                                                                          .success) {
                                                                    ref.refresh(
                                                                        cartDetailsDataProvider);
                                                                  }
                                                                });
                                                              },
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.actualPrice}:',
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9}${product.subtotalPrice}',
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.tax}:',
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9}${product.totalTax}',
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.total}:',
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9}${product.totalPrice}',
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, left: 10, right: 10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              AddressListScreen(
                                            isCheckout: true,
                                            amount: product.totalPrice.toInt() *
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
                                          appInfo.primaryColorValue,
                                      minimumSize: const Size.fromHeight(50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimension.buttonRadius)),
                                      textStyle: const TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 10,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .next
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              loading: () => SkeletonLoaderWidget(),
            ),
          );
        },
        error: (error, s) => Container(),
        loading: () => Container());
  }
}
