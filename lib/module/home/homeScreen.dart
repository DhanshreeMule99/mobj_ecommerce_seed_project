// homeScreen
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:mobj_project/module/home/collectionWiseProductScreen.dart';
import 'package:mobj_project/module/wishlist/wishlishScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../mappers/bigcommerce_models/bigcommerce_getwishlistModel.dart';

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
        final Uri deepLink = pendingDynamicLinkData.link;
        handleMyLink(deepLink);
        // Example of using the dynamic link to push the user to a different screen
        // Navigator.pushNamed(context, deepLink.path);
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

  List<BigcommerceGetWishlistModel> wishlistProductIds = [];
  List<dynamic> data = [];
  Future getWishlistproduct() async {
    wishlistProductIds.clear();
    String wishlidtId = await SharedPreferenceManager().getwishlistID();
    try {
      final response = await ApiManager.get(
          'https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/wishlists/$wishlidtId');
      if (response.statusCode == APIConstants.successCode) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        List productList = responseBody["data"]["items"];

        for (int i = 0; i < productList.length; i++) {
          wishlistProductIds.add(BigcommerceGetWishlistModel(
              id: responseBody["data"]["items"][i]["id"],
              productId: responseBody["data"]["items"][i]["product_id"]));
        }
        log("list wishlist $wishlistProductIds");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCategories() async {
    if (AppConfigure.wooCommerce) {
      log('Woo Commerce caetgorires');
      final response = await ApiManager.get(
          "https://ttf.setoo.org/wp-json/wc/v3/products/categories?consumer key=ck_db1d729eb2978c28ae46451d36c1ca02da112cb3&consumer secret=cs_c5cc06675e8ffa375b084acd40987fec142ec8cf");
      if (response.statusCode == APIConstants.successCode) {
        final apiData = json.decode(response.body);
        log(response.body);
        setState(() {
          data = apiData;
        });
      } else {
        throw Exception('Failed to fetch categories');
      }
    } else if (AppConfigure.bigCommerce) {
      debugPrint('In bigCommerAPI');
      final response = await ApiManager.get(
          "https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/catalog/trees/categories");
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
    getWishlistproduct();
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
              backgroundColor: Theme.of(context).colorScheme.secondary,
              surfaceTintColor: Theme.of(context).colorScheme.secondary,
              // elevation: 2,
              actions: [
                // IconButton(
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         PageRouteBuilder(
                //           pageBuilder: (context, animation1, animation2) =>
                //               WishlistScreen(),
                //           transitionDuration: Duration.zero,
                //           reverseTransitionDuration: Duration.zero,
                //         ),
                //       );
                //     },
                //     icon: const Icon(
                //       Icons.favorite,
                //     )),
                // IconButton(
                //     onPressed: () {
                //       Navigator.of(context).push(PageRouteBuilder(
                //           pageBuilder: (context, animation1, animation2) =>
                //               const SearchWidget()));
                //     },
                //     icon: const Icon(
                //       Icons.search,
                //     )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const CheckoutScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ));
                      // (route) => route.isFirst);
                    },
                    icon: Icon(
                      Ionicons.cart,
                      size: 25.sp,
                    )),
              ],
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: appInfo.logoImagePath,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            //image size fill
                            image: imageProvider,
                            fit: BoxFit.cover,
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
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    appInfo.appName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              )),
          bottomNavigationBar: MobjBottombar(
            bgcolor: AppColors.whiteColor,
            selcted_icon_color: AppColors.buttonColor,
            unselcted_icon_color: AppColors.blackColor,
            selectedPage: 1,
            screen1: const HomeScreen(),
            screen2: const SearchWidget(),
            screen3: WishlistScreen(),
            screen4: const ProfileScreen(),
            ref: ref,
          ),
          body: RefreshIndicator(
            // Wrap the list in a RefreshIndicator widget
            onRefresh: () async {
              ref.refresh(productDataProvider);
            },
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.w),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: ConstColors.shadowColor,
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(0, 1))
                        ]),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const SearchWidget()));
                      },
                      decoration: InputDecoration(
                          hintText: "Search Here",
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.all(10.sp),
                          suffixIcon: Icon(
                            Ionicons.search,
                            size: 20.sp,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        "View All",
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    ],
                  ),
                ),
                data.isEmpty
                    ? Container()
                    : Container(
                        height: 120,
                        margin: const EdgeInsets.only(left: 5),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: appInfo.logoImagePath,
                                    imageBuilder: (context, imageProvider) =>
                                        GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                CollectionWiseProductScreen(
                                              category: AppConfigure.bigCommerce
                                                  ? data[index]['category_id']
                                                      .toString()
                                                  : data[index]['id']
                                                      .toString(),
                                              categoryName:
                                                  AppConfigure.bigCommerce
                                                      ? data[index]["name"]
                                                      : data[index]['title'],
                                            ),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 55.sp,
                                        width: 55.sp,
                                        decoration: BoxDecoration(
                                          color: AppColors.greyShade,
                                          boxShadow: const [
                                            BoxShadow(
                                                color: ConstColors.shadowColor,
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                                offset: Offset(0, 2))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: AppColors.greyShade,
                                              width: 1),
                                          image: DecorationImage(
                                            //image size fill
                                            image: data[index]["image_url"] ==
                                                    ""
                                                ? NetworkImage(
                                                    "https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg")
                                                : NetworkImage(
                                                    data[index]["image_url"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      height: 55.sp,
                                      width: 55.sp,
                                      color: AppColors.greyShade,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            height: 55.sp,
                                            width: 55.sp,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                //image size fill
                                                image: NetworkImage(
                                                    'https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            color: AppColors.greyShade),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    AppConfigure.bigCommerce
                                        ? data[index]["name"]
                                        : data[index]['title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                              // child: FilterChip(
                              //   showCheckmark: false,
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(15),
                              //   ),
                              //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              //   label: Text(
                              //     AppConfigure.bigCommerce
                              //         ? data[index]["name"]
                              //         : data[index]['title'],
                              //     style: TextStyle(
                              //       fontSize:
                              //           0.04 * MediaQuery.of(context).size.width,
                              //       fontWeight: FontWeight.w700,
                              //       // color: selectedChipIndex == index.toString()
                              //       //     ? AppColors.whiteColor
                              //       //     : AppColors.blackColor
                              //     ),
                              //     maxLines: 1,
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              //   selected: selectedChipIndex == index.toString(),
                              //   selectedColor: appInfo.primaryColorValue,
                              //   onSelected: (bool selected) {
                              //     Navigator.of(context).push(
                              //       PageRouteBuilder(
                              //         pageBuilder:
                              //             (context, animation1, animation2) =>
                              //                 CollectionWiseProductScreen(
                              //           category: AppConfigure.bigCommerce
                              //               ? data[index]['category_id'].toString()
                              //               : data[index]['id'].toString(),
                              //           categoryName: AppConfigure.bigCommerce
                              //               ? data[index]["name"]
                              //               : data[index]['title'],
                              //         ),
                              //         transitionDuration: Duration.zero,
                              //         reverseTransitionDuration: Duration.zero,
                              //       ),
                              //     );
                              //   },
                              // ),
                            );
                          },
                        )),
                product.when(
                  data: (product) {
                    List<ProductModel> productlist =
                        product.map((e) => e).toList();
                    final post = product;

                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1 / 1.4),
                        itemCount: productlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          final isBookmarked = bookmarkedProduct
                              .indexWhere((p) => p.id == post[index].id);
                          return InkWell(
                              onTap: () {
                                ref.refresh(productDetailsProvider(
                                    productlist[index].id.toString()));
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            ProductDetailsScreen(
                                      uid: productlist[index].id.toString(),
                                      product: productlist[index],
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: ProductListCard(
                                getwishlistIDHere: wishlistProductIds,
                                isWhislisted: wishlistProductIds.any(
                                    (element) =>
                                        element.productId ==
                                        productlist[index].id),
                                // wishlistProductIds.contains(
                                //     productlist[index].id),
                                shareProduct: () async {
                                  ShareItem().buildDynamicLinks(
                                      productlist[index].id.toString(),
                                      productlist[index].image.src.toString(),
                                      productlist[index].title.toString());
                                },
                                isLikedToggle: "true",
                                onLiked: () async {
                                  ref
                                      .read(bookmarkedProductProvider.notifier)
                                      .toggleBookmark(post[index]);
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
                                tileColor: appInfo.primaryColorValue,
                                logoPath:
                                    productlist[index].image.src.toString(),
                                productName:
                                    productlist[index].title.toString(),
                                address: productlist[index].bodyHtml.toString(),
                                datetime:
                                    "${AppString.deliverAt} ${productlist[index].createdAt.toString()}/${productlist[index].createdAt}/${productlist[index].createdAt}",
                                productImage:
                                    productlist[index].image.src.toString(),
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
                                    "\u{20B9}${productlist[index].variants[0].price}",
                                status: productlist[index].variants.toString(),
                                isLiked: isBookmarked.toString(),
                                ratingCount: num.parse("5.5"),
                                productId: productlist[index].id.toString(),
                                productPrice:
                                    productlist[index].variants.isNotEmpty
                                        ? productlist[index].variants[0].price
                                        : DefaultValues.defaultPrice.toString(),
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
                              ));
                        });
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  loading: () => const SkeletonLoaderWidget(),
                )
              ]),
            ),
          )),
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
    );
  }
}
