// addressListScreen
import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../provider/addressProvider.dart';
import '../paymentGatways/phonePePay/phonePeGateway.dart';
import 'addAddressScreen.dart';

class AddressListScreen extends ConsumerStatefulWidget {
  final bool? isCheckout;
  final int? amount;
  final String? mobile;

  const AddressListScreen(
      {super.key, this.isCheckout, this.amount, this.mobile});

  @override
  ConsumerState<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends ConsumerState<AddressListScreen> {
  double userLat = 0.0;
  double userLng = 0.0;
  double destinationLat = AppConfigure.pickUpAddressLatitude;
  double destinationLng = AppConfigure.pickUpAddressLongitude;
  double distance = 0.0;
  final LocationMobj _locationService = LocationMobj();

  Future<void> getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("latlong is ${position.latitude} ${position.longitude}");

      setState(() {
        userLat = position.latitude;
        userLng = position.longitude;
        distance =
            calculateDistance(userLat, userLng, destinationLat, destinationLng);
      });
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  Future<void> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          userLat = locations.first.latitude;
          userLng = locations.first.longitude;
          distance = calculateDistance(
              userLat, userLng, destinationLat, destinationLng);
        });

      } else {
        userLat = 0.0;
        userLng = 0.0;
        distance = calculateDistance(
            userLat, userLng, destinationLat, destinationLng);
          }
    } catch (e) {
      userLat = 0.0;
      userLng = 0.0;
      distance = calculateDistance(
          userLat, userLng, destinationLat, destinationLng);    }
  }

  String getDeliveryMessage() {
    if (distance > 6.0) {
      return AppString.extraDelivery;
    } else {
      return AppString.standardDelivery;
    }
  }

  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const double earthRadius = 6371.0; // Earth radius in kilometers

    double dLat = radians(endLat - startLat);
    double dLng = radians(endLng - startLng);

    double a = pow(sin(dLat / 2), 2) +
        cos(radians(startLat)) * cos(radians(endLat)) * pow(sin(dLng / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }

  double radians(double degree) {
    return degree * (3.141592653589793 / 180.0);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _paymentHandler = PhonePePaymentHandler(context, ref, widget.amount ?? 10,
        widget!.mobile ?? DefaultValues.defaultCustomerEmail);
    //Razor pay integration
    // _razorpay = Razorpay();
    // _razorpay?.on(
    //   Razorpay.EVENT_PAYMENT_SUCCESS,
    //   PaymentHandler(_razorpay!, context, ref).handlePaymentSuccess,
    // );
    // _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR,
    //     PaymentHandler(_razorpay!, context, ref).handlePaymentError);
    // _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET,
    //     PaymentHandler(_razorpay!, context, ref).handleExternalWallet);
    // ref.read(addressDataProvider).when(
    //       data: (addressList) {
    //         selectedDefaultIndex =
    //             addressList.indexWhere((address) => address.defaultAddress);
    //       },
    //       loading: () {},
    //       error: (error, stack) {
    //         selectedDefaultIndex = 0;
    //       },
    //     );
    // getUserLocation();

    ref.read(addressDataProvider).whenData((addresses) {
      // for (var address in addresses) {

      if (selectedDefaultIndex == 0) {
        getLocationFromAddress(
            "${addresses[addresses.indexWhere((address) => address.defaultAddress)].address1},${addresses[addresses.indexWhere((address) => address.defaultAddress)].zip},${addresses[addresses.indexWhere((address) => address.defaultAddress)].city},${addresses[addresses.indexWhere((address) => address.defaultAddress)].country}");
      } else {

        getLocationFromAddress(
            addresses[addresses.indexWhere((address) => address.defaultAddress)]
                .address1);
      }
      // }
    });
    // getLocationFromAddress();
    // _locationService.getCurrentLatLong().then((value) {
    //   setState(() {
    //     userLat = value!.latitude;
    //     userLng = value!.longitude;      });
    //   print(" Address is $value");
    // });
  }

  String capitalizeWords(String inputString) {
    if (inputString.isEmpty) {
      return inputString; // Return the input string as is if it's empty
    }

    List<String> words = inputString.split(' ');

    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] =
            words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }

    return words.join(' ');
  }

  Future<bool?> showDeleteAddressDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppString.deleteAddressConf),
          content: const Text(AppString.areYouSureDeleteAddress),
          actions: [
            TextButton(
              child: const Text(AppString.cancel),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog and return false
              },
            ),
            TextButton(
              child: const Text(AppString.delete),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and return true
              },
            ),
          ],
        );
      },
    );
  }

  int selectedDefaultIndex = 0;
  PhonePePaymentHandler? _paymentHandler;

  @override
  Widget build(BuildContext context) {
    //TODO use read insted of read and dispose the provider
    final addressProviders = ref.watch(addressDataProvider);
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    final product = ref.watch(cartDetailsDataProvider);
    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text(
            AppString.addressList,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        AddressScreen(
                      isCheckout: widget.isCheckout ?? false,
                      amount: widget.amount,
                      mobile: widget.mobile,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        bottomNavigationBar: MobjBottombar(
          bgcolor: AppColors.whiteColor,
          selcted_icon_color: AppColors.buttonColor,
          unselcted_icon_color: AppColors.blackColor,
          selectedPage: 3,
          screen1: AddressListScreen(),
          screen2: SearchWidget(),
          screen3: AddressListScreen(),
          screen4: ProfileScreen(),
          ref: ref,
        ),
        body: Column(children: [
          Expanded(
              child: addressProviders.when(
            data: (address) {
              List<DefaultAddressModel> addressList =
                  address.map((e) => e).toList();
              return RefreshIndicator(
                // Wrap the list in a RefreshIndicator widget
                onRefresh: () async {
                  ref.refresh(addressDataProvider);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                        itemCount: addressList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final addresses = addressList[index];
                          selectedDefaultIndex = addressList
                              .indexWhere((address) => address.defaultAddress);
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10),
                            child: Card(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: index,
                                      groupValue: selectedDefaultIndex == 0
                                          ? addressList.indexWhere((address) =>
                                              address.defaultAddress)
                                          : selectedDefaultIndex,
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedDefaultIndex = value as int;
                                          getLocationFromAddress(
                                              "${addressList[selectedDefaultIndex].address1},${addressList[selectedDefaultIndex].zip},${addressList[selectedDefaultIndex].city},${addressList[selectedDefaultIndex].country}");
                                        });
                                        CommonAlert.show_loading_alert(context);
                                        AddressRepository()
                                            .setDefaultAddress(
                                                addresses.id.toString())
                                            .then((subjectFromServer) {
                                          Navigator.of(context).pop();
                                          if (subjectFromServer ==
                                              AppString.success) {
                                            ref.refresh(addressDataProvider);
                                            Fluttertoast.showToast(
                                                msg: AppString
                                                    .defaultAddressSuccess,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 0,
                                                backgroundColor:
                                                    AppColors.green,
                                                textColor: AppColors.whiteColor,
                                                fontSize: 16.0);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: AppString.oops,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 0,
                                                backgroundColor:
                                                    AppColors.green,
                                                textColor: AppColors.whiteColor,
                                                fontSize: 16.0);
                                          }
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(capitalizeWords(
                                              addresses.lastName)),
                                          Text(addresses.firstName),
                                          Text(
                                            '${addresses.address1}, ${addresses.city}, ${addresses.country}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            bool? logoutConfirmed =
                                                await showDeleteAddressDialog(
                                                    context);
                                            if (logoutConfirmed.toString() ==
                                                "true") {
                                              if (addresses.defaultAddress ==
                                                  true) {
                                                Fluttertoast.showToast(
                                                    msg: AppString
                                                        .canNotDeleteDefault,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 0,
                                                    backgroundColor:
                                                        AppColors.green,
                                                    textColor:
                                                        AppColors.whiteColor,
                                                    fontSize: 16.0);
                                              } else {
                                                CommonAlert.show_loading_alert(
                                                    context);
                                                AddressRepository()
                                                    .deleteAddress(
                                                        addresses.id.toString())
                                                    .then((subjectFromServer) {
                                                  Navigator.of(context).pop();
                                                  if (subjectFromServer ==
                                                      AppString.success) {
                                                    ref.refresh(
                                                        addressDataProvider);
                                                  }
                                                });
                                              }
                                            }
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressScreen(
                                                        address: addresses,
                                                        isCheckout:
                                                            widget.isCheckout ??
                                                                false),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                          );
                        },
                      )),
                      widget.isCheckout == true
                          ? product.when(
                              data: (product) {
                                DraftOrderModel productlist = product;

                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Divider(
                                        thickness: 1.5,
                                      ),
                                      Text(
                                        getDeliveryMessage(),
                                        style: TextStyle(
                                          color: distance > 6.0
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context)!.distance}:',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '${distance.toStringAsFixed(2)} KM',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context)!.actualPrice}:',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '\u{20B9}${product.subtotalPrice}',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context)!.tax}:',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '\u{20B9}${product.totalTax}',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppString.total}:',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '\u{20B9}${product.totalPrice}',
                                                  style: TextStyle(
                                                    fontSize: 0.05 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            widget.isCheckout == true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 35,
                                                            left: 10,
                                                            right: 10),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          // PaymentHandler(
                                                          //   _razorpay!,
                                                          //   context,
                                                          //   ref,
                                                          // ).openPaymentPortal(
                                                          //     productlist
                                                          //             .customer
                                                          //             .firstName +
                                                          //         productlist
                                                          //             .customer
                                                          //             .lastName,
                                                          //     productlist
                                                          //         .customer
                                                          //         .phone,
                                                          //     productlist
                                                          //         .customer
                                                          //         .email,
                                                          //     double.parse(
                                                          //         productlist
                                                          //             .totalPrice
                                                          //             .toString()));
                                                          _paymentHandler!
                                                              .startPgTransaction(
                                                                  (result) {
                                                            // setState(() {
                                                            //   this.result = result;
                                                            // });
                                                          });
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: appInfo
                                                              .primaryColorValue,
                                                          minimumSize:
                                                              Size.fromHeight(
                                                                  50),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      AppDimension
                                                                          .buttonRadius)),
                                                          textStyle: const TextStyle(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              fontSize: 10,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal),
                                                        ),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .proceedTOPay
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )))
                                                : Container(),
                                            SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        ),
                                      ),
                                    ]);
                              },
                              error: (error, s) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(error.toString()),
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
                                            primary: AppColors.buttonColor,
                                          ),
                                          onPressed: () {
                                            ref.refresh(
                                                cartDetailsDataProvider);
                                          },
                                          child: const Text(
                                            AppString.refresh,
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
                          : Container(),
                    ]),
              );
            },
            error: (error, s) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(error.toString()),
                Center(
                  child: ErrorHandling(
                    error_type: error != AppString.noDataError
                        ? AppString.error
                        : AppString.noDataError,
                  ),
                ),
                error == AppString.noDataError
                    ? Text(AppString.emptyAddress,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold))
                    : Container(),
                error != AppString.noDataError
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.buttonColor,
                        ),
                        onPressed: () {
                          ref.refresh(addressDataProvider);
                        },
                        child: const Text(
                          AppString.refresh,
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
          ))
        ]),
      ),
      error: (error, s) => Container(),
      loading: () => Container(),
    );
  }
}
