// // guestCheckoutScreen
// import 'package:mobj_project/utils/cmsConfigue.dart';
//
// class GuestCheckoutScreen extends ConsumerStatefulWidget {
//   const GuestCheckoutScreen({super.key});
//
//   @override
//   ConsumerState<GuestCheckoutScreen> createState() =>
//       _GuestCheckoutScreenState();
// }
//
// class _GuestCheckoutScreenState extends ConsumerState<GuestCheckoutScreen> {
//   final LocationMobj _locationService = LocationMobj();
//   String address = "";
//
//   currentAddress() async {
//     final permissionStatus = await Permission.location.request();
//
//     if (permissionStatus.isGranted) {
//       _locationService.getCurrentAddress().then((value) {
//         setState(() {
//           address = value;
//         });
//       });
//     } else {
//       _showLocationPermissionAlert();
//     }
//   }
//
//   Future<void> _showLocationPermissionAlert() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(AppString.locationPermissionReq),
//           content: const Text(AppString.locationPermissionSett),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context); // Close the alert
//                 await openAppSettings(); // Open app settings
//               },
//               child: const Text(AppString.openSetting),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the alert
//               },
//               child: const Text(AppString.cancel),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   String userid = "";
//
//   @override
//   Widget build(BuildContext context) {
//     final appInfoAsyncValue = ref.watch(appInfoProvider);
//     final product = ref.watch(productDataProvider);
//     return appInfoAsyncValue.when(
//         data: (appInfo) => Scaffold(
//             appBar: AppBar(
//                 elevation: 2,
//                 actions: [
//                   appInfoAsyncValue.when(
//                     data: (appInfo) => IconButton(
//                         onPressed: () {
//                           showAlertAndNavigateToLogin(context);
//                         },
//                         icon: CircleAvatar(
//                             backgroundColor: appInfo.primaryColorValue,
//                             child: const Icon(
//                               Icons.filter_alt,
//                               color: AppColors.whiteColor,
//                             ))),
//                     loading: () =>
//                         const Center(child: CircularProgressIndicator()),
//                     error: (error, stackTrace) => Text('Error: $error'),
//                   )
//                 ],
//                 title: appInfoAsyncValue.when(
//                   data: (appInfo) => Text(
//                     appInfo.appName,
//                   ),
//                   loading: () =>
//                       const Center(child: CircularProgressIndicator()),
//                   error: (error, stackTrace) => Text('Error: $error'),
//                 )),
//             body: product.when(
//                 data: (product) {
//                   List<ProductModel> productlist =
//                       product.map((e) => e).toList();
//                   final post = product;
//
//                   return RefreshIndicator(
//                     // Wrap the list in a RefreshIndicator widget
//                     onRefresh: () async {
//                       ref.refresh(productDataProvider("1"));
//                     },
//                     child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           //TODO list guestcheckout functionality
//                           // Padding(
//                           //     padding: const EdgeInsets.only(
//                           //         top: 10, left: 15, right: 15),
//                           //     child: Card(
//                           //         margin: EdgeInsets.only(bottom: 5),
//                           //         elevation: 3,
//                           //         shape: RoundedRectangleBorder(
//                           //           borderRadius: BorderRadius.circular(15),
//                           //         ),
//                           //         child: Padding(
//                           //             padding: const EdgeInsets.all(15),
//                           //             child: Row(
//                           //               children: [
//                           //                 const Icon(Icons.location_on_sharp),
//                           //                 Expanded(child: Text(address))
//                           //               ],
//                           //             )))),
//                           // Expanded(
//                           //     child: ListView.builder(
//                           //         itemCount: productlist.length,
//                           //         itemBuilder:
//                           //             (BuildContext context, int index) {
//                           //           final isBookmarked =
//                           //           bookmarkedProduct.indexWhere(
//                           //                   (p) => p.id == post[index].id);
//                           //           return Padding(
//                           //               padding: const EdgeInsets.only(
//                           //                   top: 10, left: 10, right: 10),
//                           //               child:
//                           //               InkWell(onTap:()async{
//                           //
//                           //                   showAlertAndNavigateToLogin(context);
//                           //
//                           //               },
//                           //                   child: Card(
//                           //                   margin:
//                           //                   EdgeInsets.only(bottom: 5),
//                           //                   elevation: 3,
//                           //                   shape: RoundedRectangleBorder(
//                           //                     borderRadius:
//                           //                     BorderRadius.circular(15),
//                           //                   ),
//                           //                   child: ProductListCard(
//                           //                     share_opportunity: () async {
//                           //                       // Shared_opportunity_repository()
//                           //                       //     .share_opportunity(
//                           //                       //     productlist[index]
//                           //                       //         .opportunityID
//                           //                       //         .toString());
//                           //                       Share.share(
//                           //                           'https://vishvmitra.page.link/post');
//                           //                     },
//                           //                     issavefortoggele: "true",
//                           //                     // isBookmarked.toString(),
//                           //                     onsaved: () async {
//                           //                       ref
//                           //                           .read(
//                           //                           bookmarkedProductProvider
//                           //                               .notifier)
//                           //                           .toggleBookmark(
//                           //                           post[index]);
//                           //                       // debouncer.run(() {
//                           //                       // if ((productlist[index]
//                           //                       //     .saveStatus ==
//                           //                       // "true" &&
//                           //                       // isBookmarked
//                           //                       //     .toString() ==
//                           //                       // "0") ||
//                           //                       // (productlist[index]
//                           //                       //     .saveStatus !=
//                           //                       // "true" &&
//                           //                       // isBookmarked
//                           //                       //     .toString() ==
//                           //                       // "-1")) {
//                           //                       // Onsaved_repository()
//                           //                       //     .onsaved(productlist[
//                           //                       // index]
//                           //                       //     .opportunityID
//                           //                       //     .toString())
//                           //                       //     .then(
//                           //                       // (subjectFromServer) {
//                           //                       // if (subjectFromServer ==
//                           //                       // "Opportunity is already saved") {
//                           //                       Fluttertoast.showToast(
//                           //                           msg: "saved",
//                           //                           toastLength:
//                           //                           Toast.LENGTH_SHORT,
//                           //                           gravity:
//                           //                           ToastGravity.BOTTOM,
//                           //                           timeInSecForIosWeb: 1,
//                           //                           backgroundColor:
//                           //                           Colors.green,
//                           //                           textColor: Colors.white,
//                           //                           fontSize: 16.0);
//                           //                       // }
//                           //                       // // ref.refresh(
//                           //                       // //     ongoingDataProvider);
//                           //                       //
//                           //                       // Fluttertoast.showToast(
//                           //                       // msg: subjectFromServer
//                           //                       //     .toString(),
//                           //                       // toastLength: Toast
//                           //                       //     .LENGTH_SHORT,
//                           //                       // gravity:
//                           //                       // ToastGravity
//                           //                       //     .BOTTOM,
//                           //                       // timeInSecForIosWeb:
//                           //                       // 1,
//                           //                       // backgroundColor:
//                           //                       // Colors.green,
//                           //                       // textColor:
//                           //                       // Colors.white,
//                           //                       // fontSize: 16.0);
//                           //                       // });
//                           //                       // } else {
//                           //                       // Onsaved_repository()
//                           //                       //     .deletesaved(
//                           //                       // productlist[
//                           //                       // index]
//                           //                       //     .opportunityID
//                           //                       //     .toString())
//                           //                       //     .then((val) {});
//                           //                       // }
//                           //                       // });
//                           //                     },
//                           //                     tilecolor:
//                           //                     appInfo.primaryColorValue,
//                           //                     logo_path:
//                           //                     productlist[index].image,
//                           //                     org_name:
//                           //                     productlist[index].name,
//                           //                     org_color:
//                           //                     app_colors.black_color,
//                           //                     address: productlist[index]
//                           //                         .description
//                           //                         .toString(),
//                           //                     datetime:
//                           //                     "Deliver at: ${productlist[index].createdAt.day.toString()}/${productlist[index].createdAt.month}/${productlist[index].createdAt.year}",
//                           //                     link_color:
//                           //                     app_colors.button_color,
//                           //                     star_color:
//                           //                     app_colors.start_color,
//                           //                     org_img:
//                           //                     productlist[index].image,
//                           //                     button_text_color:
//                           //                     app_colors.white_color,
//                           //                     ratings: () {
//                           //                       showDialog(
//                           //                           context: context,
//                           //                           builder: (context) =>
//                           //                               RatingAlert(
//                           //                                   onRatingSelected:
//                           //                                       (val) {},
//                           //                                   org_name: "abc",
//                           //                                   onsubmit: () {},
//                           //                                   user_rating:
//                           //                                   4));
//                           //                       // showDialog(
//                           //                       // context: context,
//                           //                       // builder: (context) =>
//                           //                       // user_ratings.when(
//                           //                       // data: (id) =>
//                           //                       // RatingAlert(
//                           //                       // onRatingSelected:
//                           //                       // (rating) {
//                           //                       // ratings = rating;
//                           //                       // },
//                           //                       // org_name: productlist[
//                           //                       // index]
//                           //                       //     .organizationName,
//                           //                       // onsubmit: () {
//                           //                       // setState(() {
//                           //                       // var avgRating =
//                           //                       // 0.0;
//                           //                       // var sum = 0.0;
//                           //                       // var len = 0.0;
//                           //                       //
//                           //                       // if (productlist[
//                           //                       // index]
//                           //                       //     .ratingsLength ==
//                           //                       // "0") {
//                           //                       // sum = double.parse(productlist[
//                           //                       // index]
//                           //                       //     .sumRatings!
//                           //                       //     .toString()) +
//                           //                       // ratings;
//                           //                       // if (double.parse(
//                           //                       // id.toString()) ==
//                           //                       // "0") {
//                           //                       // len = double.parse(productlist[
//                           //                       // index]
//                           //                       //     .ratingsLength!
//                           //                       //     .toString()) +
//                           //                       // 1;
//                           //                       // } else {
//                           //                       // len = double.parse(productlist[
//                           //                       // index]
//                           //                       //     .ratingsLength!
//                           //                       //     .toString());
//                           //                       // }
//                           //                       // avgRating =
//                           //                       // sum / len;
//                           //                       // }
//                           //                       // productlist[index]
//                           //                       //     .rating =
//                           //                       // ratings
//                           //                       //     .toString();
//                           //                       // });
//                           //                       //
//                           //                       // Rating_repository()
//                           //                       //     .ratings(
//                           //                       // productlist[
//                           //                       // index]
//                           //                       //     .opportunityID
//                           //                       //     .toString(),
//                           //                       // ratings
//                           //                       //     .toString())
//                           //                       //     .then((val) {
//                           //                       // ref.refresh(
//                           //                       // bookmarkedPostsProvider);
//                           //                       //
//                           //                       // ref.refresh(
//                           //                       // opportunityDataProvider);
//                           //                       // ref.refresh(userratingsProvider(
//                           //                       // productlist[
//                           //                       // index]
//                           //                       //     .opportunityID
//                           //                       //     .toString()));
//                           //                       // Fluttertoast.showToast(
//                           //                       // msg:
//                           //                       // "Thank you for your feedback",
//                           //                       // toastLength: Toast
//                           //                       //     .LENGTH_SHORT,
//                           //                       // gravity:
//                           //                       // ToastGravity
//                           //                       //     .BOTTOM,
//                           //                       // timeInSecForIosWeb:
//                           //                       // 1,
//                           //                       // backgroundColor:
//                           //                       // Colors
//                           //                       //     .green,
//                           //                       // textColor:
//                           //                       // Colors
//                           //                       //     .white,
//                           //                       // fontSize:
//                           //                       // 16.0);
//                           //                       // });
//                           //                       // Navigator.pop(
//                           //                       // context);
//                           //                       // },
//                           //                       // user_rating:
//                           //                       // double.parse(id
//                           //                       //     .toString()),
//                           //                       // ),
//                           //                       // error: (error, s) => Text(
//                           //                       // "OOPS Something went wrong"),
//                           //                       // loading: () =>
//                           //                       // Container(),
//                           //                       // ),
//                           //                       // );
//                           //                     },
//                           //                     Apply_Onpressed: () {},
//                           //                     button_color: Colors.red,
//                           //                     opp_profile:
//                           //                     "\u{20B9}${productlist[index].price}",
//                           //                     opp_link: productlist[index]
//                           //                         .attributes
//                           //                         .toString(),
//                           //                     status: productlist[index]
//                           //                         .isDeactive
//                           //                         .toString(),
//                           //                     issaved:
//                           //                     isBookmarked.toString(),
//                           //                     status_name: "Activate",
//                           //                     star_count: num.parse("5.5"),
//                           //                     orgid: productlist[index]
//                           //                         .id
//                           //                         .toString(),
//                           //                     button_name: 'hey',
//                           //                   ))));
//                           //         })),
//                         ]),
//                   );
//                 },
//                 error: (error, s) => Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Text(error.toString()),
//                         const Center(
//                           child: ErrorHandling(
//                             error_type: "error",
//                           ),
//                         ),
//                         // Text(error.toString()),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             primary: AppColors.buttonColor,
//                           ),
//                           onPressed: () {
//                             ref.refresh(productDataProvider("1"));
//                           },
//                           child: const Text(
//                             AppString.refresh,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: AppColors.whiteColor,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                 loading: () => skeleton_loader())),
//         error: (error, s) => Container(),
//         loading: () => Container());
//   }
//
//   void showAlertAndNavigateToLogin(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(AppString.pleaseLogin),
//           content: const Text(AppString.needLogin),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(AppString.cancel),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text(AppString.login),
//               onPressed: () {
//                 // Navigate to the login screen
//                 Navigator.of(context).pop(); // Close the alert
//                 Navigator.pushReplacementNamed(context, RouteConstants.login);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
