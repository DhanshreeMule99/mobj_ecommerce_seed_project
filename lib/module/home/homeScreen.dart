// homeScreen
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mobj_project/module/home/collectionWiseProductScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../paymentGatways/phonePePay/phonePeGateway.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

final selectedCategoryProvider = StateProvider((ref) => "-1");
final selectedChipIndexProvider = StateProvider((ref) => "-1");
final str = StateProvider((ref) => 0);
final bookmarkedProductProvider =
    StateNotifierProvider<BookmarkedProductNotifier, List<ProductModel>>(
        (ref) => BookmarkedProductNotifier());

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final LocationMobj _locationService = LocationMobj();
  String address = "";

  void initDynamicLinks() async {
    // Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
    } else {}

    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) {
        // Set up the `onLink` event listener next as it may be received here
        if (pendingDynamicLinkData != null) {
          final Uri deepLink = pendingDynamicLinkData.link;
          handleMyLink(deepLink);
          // Example of using the dynamic link to push the user to a different screen
          // Navigator.pushNamed(context, deepLink.path);
        }
      },
    );
  }

  void handleMyLink(Uri url) {
    String opportunityId = url.queryParameters["itemIds"] ?? "";
//TODO list firebase integration
    // ref.read(str.notifier).state++;
    // Get.to(()=>ProductDetailScreen(sepeatedLink[1]));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(uid: opportunityId),
      ),
    );
  }

  List<dynamic> data = [];

  Future<void> fetchCategories() async {
    if (AppConfigure.bigCommerce) {
      log('In bigCommerAPI');
      final response = await ApiManager.get(
          "https://api.bigcommerce.com/stores/05vrtqkend/v3/catalog/trees/categories");
      if (response.statusCode == APIConstants.successCode) {
        final apiData = json.decode(response.body)['data'];
        setState(() {
          data = apiData;
        });
      } else {
        throw Exception('Failed to fetch categories');
      }
    } else {
      final response =
          await ApiManager.get(AppConfigure.baseUrl + APIConstants.collection);
      if (response.statusCode == APIConstants.successCode) {
        final apiData = json.decode(response.body)['collections'];
        setState(() {
          data = apiData;
        });
      } else {
        throw Exception('Failed to fetch categories');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initDynamicLinks();
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO use read insted of read and dispose the provider
    final product = ref.watch(productDataProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedChipIndex = ref.watch(selectedChipIndexProvider);
    final productByCollection =
        ref.watch(productDataByCollectionProvider(selectedCategory.toString()));
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    final bookmarkedProduct = ref.watch(bookmarkedProductProvider);
    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
          appBar: AppBar(
              elevation: 2,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const SearchWidget()));
                    },
                    icon: const Icon(
                      Icons.search,
                    )),
              ],
              title: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: appInfo.logoImagePath,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          //image size fill
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: 35,
                      width: 35,
                      color: AppColors.greyShade,
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: 35, width: 35, color: AppColors.greyShade),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    appInfo.appName,
                  )
                ],
              )),
          bottomNavigationBar: MobjBottombar(
            bgcolor: AppColors.whiteColor,
            selcted_icon_color: AppColors.buttonColor,
            unselcted_icon_color: AppColors.blackColor,
            selectedPage: 1,
            screen1: HomeScreen(),
            screen2: SearchWidget(),
            screen3: HomeScreen(),
            screen4: ProfileScreen(),
            ref: ref,
          ),
          body: Column(children: [
            data.length == 0
                ? Container()
                : Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(2),
                          child: FilterChip(
                            showCheckmark: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            label: Text(
                              AppConfigure.bigCommerce
                                  ? data[index]["name"]
                                  : data[index]['title'],
                              style: TextStyle(
                                fontSize:
                                    0.04 * MediaQuery.of(context).size.width,
                                fontWeight: FontWeight.w700,
                                // color: selectedChipIndex == index.toString()
                                //     ? AppColors.whiteColor
                                //     : AppColors.blackColor
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            selected: selectedChipIndex == index.toString(),
                            selectedColor: appInfo.primaryColorValue,
                            onSelected: (bool selected) {
                            
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          CollectionWiseProductScreen(
                                    category: AppConfigure.bigCommerce
                                        ? data[index]['category_id'].toString()
                                        : data[index]['id'].toString(),
                                    categoryName: AppConfigure.bigCommerce
                                        ? data[index]["name"]
                                        : data[index]['title'],
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )),
            Expanded(
                child: product.when(
              data: (product) {
                List<ProductModel> productlist = product.map((e) => e).toList();
                final post = product;

                return RefreshIndicator(
                  // Wrap the list in a RefreshIndicator widget
                  onRefresh: () async {
                    ref.refresh(productDataProvider);
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: ListView.builder(
                                itemCount: productlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final isBookmarked =
                                      bookmarkedProduct.indexWhere(
                                          (p) => p.id == post[index].id);
                                  return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 15, right: 15),
                                      child: InkWell(
                                          onTap: () {
                                            ref.refresh(productDetailsProvider(
                                                productlist[index]
                                                    .id
                                                    .toString()));
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    ProductDetailsScreen(
                                                  uid: productlist[index]
                                                      .id
                                                      .toString(),
                                                  product: productlist[index],
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
                                                  bottom: 10),
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: ProductListCard(
                                                shareProduct: () async {
                                                  ShareItem().buildDynamicLinks(
                                                      productlist[index]
                                                          .id
                                                          .toString(),
                                                      productlist[index]
                                                          .image!
                                                          .src
                                                          .toString(),
                                                      productlist[index]
                                                          .title
                                                          .toString());
                                                },
                                                isLikedToggle: "true",
                                                onLiked: () async {
                                                  ref
                                                      .read(
                                                          bookmarkedProductProvider
                                                              .notifier)
                                                      .toggleBookmark(
                                                          post[index]);
                                                  //TODO list API integration of like
                                                  // debouncer.run(() {
                                                  // if ((productlist[index]
                                                  //     .saveStatus ==
                                                  // "true" &&
                                                  // isBookmarked
                                                  //     .toString() ==
                                                  // "0") ||
                                                  // (productlist[index]
                                                  //     .saveStatus !=
                                                  // "true" &&
                                                  // isBookmarked
                                                  //     .toString() ==
                                                  // "-1")) {
                                                  // Onsaved_repository()
                                                  //     .onsaved(productlist[
                                                  // index]
                                                  //     .opportunityID
                                                  //     .toString())
                                                  //     .then(
                                                  // (subjectFromServer) {
                                                  // if (subjectFromServer ==
                                                  // "Opportunity is already saved") {
                                                },
                                                tileColor:
                                                    appInfo.primaryColorValue,
                                                logoPath: productlist[index]
                                                    .image!
                                                    .src
                                                    .toString(),
                                                productName: productlist[index]
                                                    .title
                                                    .toString(),
                                                address: productlist[index]
                                                    .bodyHtml
                                                    .toString(),
                                                datetime:
                                                    "${AppString.deliverAt} ${productlist[index].createdAt.toString()}/${productlist[index].createdAt}/${productlist[index].createdAt!}",
                                                productImage: productlist[index]
                                                    .image!
                                                    .src
                                                    .toString(),
                                                ratings: () {
                                                  //TODO list product rating
                                                  // showDialog(
                                                  //     context: context,
                                                  //     builder: (context) =>
                                                  //         // RatingAlert(
                                                  //         //     onRatingSelected:
                                                  //         //         (val) {},
                                                  //         //     org_name:
                                                  //         //         "abc",
                                                  //         //     onsubmit:
                                                  //         //         () {},
                                                  //         //     user_rating:
                                                  //         //         4));
                                                  // // showDialog(
                                                  // // context: context,
                                                  // // builder: (context) =>
                                                  // // user_ratings.when(
                                                  // // data: (id) =>
                                                  // // RatingAlert(
                                                  // // onRatingSelected:
                                                  // // (rating) {
                                                  // // ratings = rating;
                                                  // // },
                                                  // // org_name: productlist[
                                                  // // index]
                                                  // //     .organizationName,
                                                  // // onsubmit: () {
                                                  // // setState(() {
                                                  // // var avgRating =
                                                  // // 0.0;
                                                  // // var sum = 0.0;
                                                  // // var len = 0.0;
                                                  // //
                                                  // // if (productlist[
                                                  // // index]
                                                  // //     .ratingsLength ==
                                                  // // "0") {
                                                  // // sum = double.parse(productlist[
                                                  // // index]
                                                  // //     .sumRatings!
                                                  // //     .toString()) +
                                                  // // ratings;
                                                  // // if (double.parse(
                                                  // // id.toString()) ==
                                                  // // "0") {
                                                  // // len = double.parse(productlist[
                                                  // // index]
                                                  // //     .ratingsLength!
                                                  // //     .toString()) +
                                                  // // 1;
                                                  // // } else {
                                                  // // len = double.parse(productlist[
                                                  // // index]
                                                  // //     .ratingsLength!
                                                  // //     .toString());
                                                  // // }
                                                  // // avgRating =
                                                  // // sum / len;
                                                  // // }
                                                  // // productlist[index]
                                                  // //     .rating =
                                                  // // ratings
                                                  // //     .toString();
                                                  // // });
                                                  // //
                                                  // // Rating_repository()
                                                  // //     .ratings(
                                                  // // productlist[
                                                  // // index]
                                                  // //     .opportunityID
                                                  // //     .toString(),
                                                  // // ratings
                                                  // //     .toString())
                                                  // //     .then((val) {
                                                  // // ref.refresh(
                                                  // // bookmarkedPostsProvider);
                                                  // //
                                                  // // ref.refresh(
                                                  // // opportunityDataProvider);
                                                  // // ref.refresh(userratingsProvider(
                                                  // // productlist[
                                                  // // index]
                                                  // //     .opportunityID
                                                  // //     .toString()));
                                                  // // Fluttertoast.showToast(
                                                  // // msg:
                                                  // // "Thank you for your feedback",
                                                  // // toastLength: Toast
                                                  // //     .LENGTH_SHORT,
                                                  // // gravity:
                                                  // // ToastGravity
                                                  // //     .BOTTOM,
                                                  // // timeInSecForIosWeb:
                                                  // // 1,
                                                  // // backgroundColor:
                                                  // // Colors
                                                  // //     .green,
                                                  // // textColor:
                                                  // // Colors
                                                  // //     .white,
                                                  // // fontSize:
                                                  // // 16.0);
                                                  // // });
                                                  // // Navigator.pop(
                                                  // // context);
                                                  // // },
                                                  // // user_rating:
                                                  // // double.parse(id
                                                  // //     .toString()),
                                                  // // ),
                                                  // // error: (error, s) => Text(
                                                  // // "OOPS Something went wrong"),
                                                  // // loading: () =>
                                                  // // Container(),
                                                  // // ),
                                                  // // );
                                                },
                                                productDetails:
                                                    "\u{20B9}${productlist[index].variants![0].price}",
                                                status: productlist[index]
                                                    .variants
                                                    .toString(),
                                                isLiked:
                                                    isBookmarked.toString(),
                                                ratingCount: num.parse("5.5"),
                                                productId: productlist[index]
                                                    .id
                                                    .toString(),
                                                productPrice: productlist[index]
                                                        .variants
                                                        .isNotEmpty
                                                    ? productlist[index]
                                                        .variants![0]
                                                        .price
                                                    : DefaultValues.defaultPrice
                                                        .toString(),
                                                addToCart: () {
                                                  // CommonAlert
                                                  //     .show_loading_alert(
                                                  //         context);
                                                  // ProductRepository()
                                                  //     .addToCart(
                                                  //         productlist[index]
                                                  //             .variants[0]
                                                  //             .id
                                                  //             .toString(),
                                                  //         "1")
                                                  //     .then((value) async {
                                                  //   if (value ==
                                                  //       AppString.success) {
                                                  //
                                                  //     ref.refresh(
                                                  //         cartDetailsDataProvider);
                                                  //     ref.refresh(
                                                  //         productDetailsProvider(
                                                  //             productlist[index].id.toString()));
                                                  //     Fluttertoast.showToast(
                                                  //         msg: AppString
                                                  //             .addToCartSuccess,
                                                  //         toastLength: Toast
                                                  //             .LENGTH_SHORT,
                                                  //         gravity: ToastGravity
                                                  //             .BOTTOM,
                                                  //         timeInSecForIosWeb: 0,
                                                  //         backgroundColor:
                                                  //             AppColors.green,
                                                  //         textColor: AppColors
                                                  //             .whiteColor,
                                                  //         fontSize: 16.0);
                                                  //   } else {
                                                  //     Fluttertoast.showToast(
                                                  //         msg: AppString
                                                  //             .oops,
                                                  //         toastLength: Toast
                                                  //             .LENGTH_SHORT,
                                                  //         gravity: ToastGravity
                                                  //             .BOTTOM,
                                                  //         timeInSecForIosWeb: 0,
                                                  //         backgroundColor:
                                                  //         AppColors.green,
                                                  //         textColor: AppColors
                                                  //             .whiteColor,
                                                  //         fontSize: 16.0);
                                                  //   }
                                                  // });
                                                },
                                                variantId: productlist[index]
                                                    .variants[0]
                                                    .id
                                                    .toString(),
                                                stock: productlist[index]
                                                    .variants[0]
                                                    .inventoryQuantity,
                                                ref: ref,
                                              ))));
                                })),
                      ]),
                );
              },
              error: (error, s) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: ErrorHandling(
                      error_type: AppString.error,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                    ),
                    onPressed: () {
                      ref.refresh(productDataProvider);
                      // Navigator.of(context).push(
                      //   PageRouteBuilder(
                      //     pageBuilder:
                      //         (context, animation1, animation2) =>
                      //         PhonePeGatewayScreen(
                      //           // isCheckout: true,
                      //         ),
                      //     transitionDuration: Duration.zero,
                      //     reverseTransitionDuration:
                      //     Duration.zero,
                      //   ),
                      // );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.refresh,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              loading: () => SkeletonLoaderWidget(),
            ))
          ])),
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
                    ref.refresh(productDataProvider);
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
    );
  }
}
