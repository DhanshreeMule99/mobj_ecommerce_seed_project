// OrderdetailsScreen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:intl/intl.dart';
import 'package:mobj_project/module/profile/myOrder/repeatOrder.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderdetailsScreen extends ConsumerStatefulWidget {
  final String oId;

  const OrderdetailsScreen({super.key, required this.oId});

  @override
  ConsumerState<OrderdetailsScreen> createState() => _OrderdetailsScreenState();
}

class _OrderdetailsScreenState extends ConsumerState<OrderdetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String convertDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);

      date = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
      return date;
    } catch (error) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO use read insted of read and dispose the provider
    final orderProviders = ref.watch(orderDetailsProvider(widget.oId));
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: Text(
              AppLocalizations.of(context)!.orderDetailsTitle,
            ),
            actions: [],
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            orderProviders.when(
              data: (order) {
                return RefreshIndicator(
                  // Wrap the list in a RefreshIndicator widget
                  onRefresh: () async {
                    ref.refresh(orderDetailsProvider(widget.oId));
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                            '${AppLocalizations.of(context)!.orderId}: ${order.id.toString()}'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.name}: ${order.firstname} ${order.lastname}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.email}: ${order.contactEmail}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.phoneLabel}: ${order.phone}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.tax}: \u{20B9}${order.currentTotalTax} ${order.currency}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.totalPrice}: \u{20B9}${double.parse(order.totalPrice).toStringAsFixed(2)} ${order.currency}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.orderDate}: ${convertDate(order.createdAt)} '),
                                          ],
                                        ),
                                        trailing: OrderStatus(
                                            orderStatus:
                                                AppString.orderStatus2),
                                      )),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            )),
                        Column(
                          children: order.lineItems.map((item) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              ProductDetailsScreen(
                                                  uid: item.productId
                                                      .toString()),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.only(bottom: 0),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: CachedNetworkImage(
                                            imageUrl: (ref.watch(
                                                        productImageDataProvider(
                                                            item.productId
                                                                .toString())))
                                                    .when(
                                                  data: (images) {
                                                    if (images.isNotEmpty) {
                                                      // Find the image with the specified variant ID
                                                      final selectedImage =
                                                          images.firstWhere(
                                                        (image) => image
                                                            .variantIds
                                                            .contains(
                                                                item.variantId),
                                                        orElse: () =>
                                                            ProductImage(
                                                          id: 0,
                                                          // Provide a default ID
                                                          alt: "Default",
                                                          position: 0,
                                                          productId: 0,
                                                          createdAt:
                                                              DateTime.now()
                                                                  .toString(),
                                                          // Provide a default creation time
                                                          updatedAt:
                                                              DateTime.now()
                                                                  .toString(),
                                                          // Provide a default update time
                                                          adminGraphqlApiId:
                                                              "gid://shopify/ProductImage/0",
                                                          width: 0,
                                                          height: 0,
                                                          src: images[0].src,
                                                          // Provide a default image URL
                                                          variantIds: [],
                                                        ),
                                                      );

                                                      return selectedImage.src;
                                                    }
                                                    return DefaultValues
                                                        .defaultImagesSrc;
                                                  },
                                                  loading: () => DefaultValues
                                                      .defaultImagesSrc,
                                                  error: (_, __) =>
                                                      DefaultValues
                                                          .defaultImagesSrc,
                                                ) ??
                                                DefaultValues.defaultImagesSrc,
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 50,
                                              width: 50,
                                              color: AppColors.greyShade,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: Text(item.name),
                                        ),
                                        subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context)!.price}: \u{20B9}${(double.parse(item.price.toString()) * item.quantity).toStringAsFixed(2)}',
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.quantity}: ${item.quantity.toString()}',
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            )),
                                      ),
                                    )));
                          }).toList(),
                        ),
                        SizedBox(
                          height: 15,
                        )
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
                  error != AppString.noDataError
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                          ),
                          onPressed: () {
                            ref.refresh(orderDataProvider);
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
            )
          ])),
          bottomNavigationBar: BottomAppBar(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appInfo.primaryColorValue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimension.buttonRadius)),
                          textStyle: const TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 10,
                              fontStyle: FontStyle.normal),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.trackOrder,
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderTrackingScreen()),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appInfo.primaryColorValue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimension.buttonRadius)),
                          textStyle: const TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 10,
                              fontStyle: FontStyle.normal),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.repeatOrder,
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          orderProviders.whenData((product) async {
                            // Initialize an empty list to store line_items
                            List<Map<String, String>> lineItemsList = [];
                            String uid =
                                await SharedPreferenceManager().getUserId();
                            // Iterate through product.lineItems
                            for (int i = 0; i < product.lineItems.length; i++) {
                              String quantity =
                                  product.lineItems[i].quantity.toString();
                              String variantId =
                                  product.lineItems[i].variantId.toString();

                              // Create a line_item Map for the current iteration
                              Map<String, String> lineItem = {
                                "variant_id": variantId,
                                "quantity": quantity,
                              };
                              // Add the line_item to the list
                              lineItemsList.add(lineItem);
                            }
                            // Create the draft_order Map with line_items list and customer information
                            Map<String, dynamic> draftOrder = {
                              "draft_order": {
                                "line_items": lineItemsList,
                                "customer": {"id": uid}
                              }
                            };
                            CommonAlert.show_loading_alert(context);
                            ProductRepository()
                                .repeatOrder(draftOrder)
                                .then((value) async {
                              if (value != AppString.oops) {
                                Navigator.of(context).pop();
                                ref.refresh(productDataProvider);
                                ref.refresh(cartDetailsDataProvider);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RepeatOrderScreen(orderId: value)));
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
                            // Print the result or use it as needed
                          });
                        },
                      ),
                    ],
                  )))),
      error: (error, s) => Container(),
      loading: () => Container(),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String orderStatus;

  OrderStatus({required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.grey;

    if (orderStatus == AppString.orderStatus2) {
      statusColor = AppColors.orange;
    } else if (orderStatus == AppString.shipped) {
      statusColor = AppColors.blue;
    } else if (orderStatus == AppString.orderStatus4) {
      statusColor = AppColors.green;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        orderStatus,
        style: const TextStyle(color: AppColors.whiteColor),
      ),
    );
  }
}
