// OrderListScreen
import 'package:intl/intl.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  final bool? isCheckout;

  const OrderListScreen({super.key, this.isCheckout});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO use read insted of read and dispose the provider
    final orderProviders = ref.watch(orderDataProvider);
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
        appBar: AppBar(
         automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              surfaceTintColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            AppLocalizations.of(context)!.myOrders,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 25.sp,
              )),
        ),
        bottomNavigationBar: MobjBottombar(
          bgcolor: AppColors.whiteColor,
          selcted_icon_color: AppColors.buttonColor,
          unselcted_icon_color: AppColors.blackColor,
          selectedPage: 4,
          screen1: const OrderListScreen(),
          screen2:  SearchWidget(),
          screen3: const OrderListScreen(),
          screen4: const ProfileScreen(),
          ref: ref,
        ),
        body: Column(children: [
          Expanded(
              child: orderProviders.when(
            data: (order) {
              return RefreshIndicator(
                // Wrap the list in a RefreshIndicator widget
                onRefresh: () async {
                  ref.refresh(orderDataProvider);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                        //  itemCount: order != []
                        //         ? order.length
                        //         : 0,
                        itemCount: order.length,
                        itemBuilder: (BuildContext context, int index) {
                          final orderes = order[index];
                          String formattedDate;
                          try {
                            DateTime dateTime =
                                DateTime.parse(orderes.createdAt);

                            formattedDate = DateFormat('dd MMM yyyy hh:mm a')
                                .format(dateTime);
                          } catch (error) {
                            formattedDate = orderes.createdAt;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10),
                            child: Card(
                              color: Theme.of(context).colorScheme.onPrimary,
                                elevation: 3,
                                
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ListTile(
                                      title: Text(
                                          '${AppLocalizations.of(context)!.orderId} ${order[index].id.toString()}'),
                                      subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.totalPrice}: \u{20B9}${double.parse(order[index].totalPrice).toStringAsFixed(2)} '),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${AppLocalizations.of(context)!.orderDate}: $formattedDate '),
                                          ]),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                OrderdetailsScreen(
                                                    oId: order[index]
                                                        .id
                                                        .toString()),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      },
                                      trailing: const OrderStatus(
                                          orderStatus: AppString.orderStatus2),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )),
                          );
                        },
                      )),
                    ]),
              );
            },
            // error: (error, s) => Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Center(
            //       child: ErrorHandling(
            //         error_type: error != AppString.noDataError
            //             ? AppString.error
            //             : AppString.noDataError,
            //       ),
            //     ),
            //     error != AppString.noDataError
            //         ? ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: AppColors.buttonColor,
            //             ),
            //             onPressed: () {
            //               ref.refresh(orderDataProvider);
            //             },
            //             child:  Text(
            //               AppLocalizations.of(context)!.refresh,
            //               style: TextStyle(
            //                 fontSize: 16,
            //                 color: AppColors.whiteColor,
            //               ),
            //             ),
            //           )
            //         : Container()
            //   ],
            // ),
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
                    //  ? Text(AppLocalizations.of(context)!.emptyorders,
                    ? Text(AppLocalizations.of(context)!.noOrder,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
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
          ))
        ]),
      ),
      error: (error, s) => Container(),
      loading: () => Container(),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String orderStatus;

  const OrderStatus({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;

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
