// homeScreen
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:like_button/like_button.dart';
import 'package:mobj_project/mappers/bigcommerce_models/bicommerce_wishlistModel.dart';
import 'package:mobj_project/module/home/collectionWiseProductScreen.dart';
import 'package:mobj_project/utils/api.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../paymentGatways/phonePePay/phonePeGateway.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

final selectedCategoryProvider = StateProvider((ref) => "-1");
final selectedChipIndexProvider = StateProvider((ref) => "-1");
final str = StateProvider((ref) => 0);
final bookmarkedProductProvider =
    StateNotifierProvider<BookmarkedProductNotifier, List<ProductModel>>(
        (ref) => BookmarkedProductNotifier());

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  final LocationMobj _locationService = LocationMobj();
  String address = "";
  bool loader = false;
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
  List<ProductModel> wishlistProducts = [];
  final List<WishlistProductModel> products = [];

  Future<void> getallWishlist() async {
    API api = API();
    setState(() {
      loader = true;
    });

    log("Get all wishlist details............");
    String wishlidtId = await SharedPreferenceManager().getwishlistID();
    try {
      final response = await ApiManager.get(
          'https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/wishlists/$wishlidtId');
      if (response.statusCode == APIConstants.successCode) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        // final List result = jsonDecode(response.body)['data'];

        List productList = responseBody["data"]["items"];
        log("body is this one ${responseBody["data"]["items"][0]["product_id"]}");

        String graphQLQuery = '';
        for (int i = 0; i < productList.length; i++) {
          graphQLQuery += '''
      product$i: product(entityId: ${responseBody["data"]["items"][i]["product_id"]}) {
        ...ProductFields
      }
    ''';
        }

        await Future.delayed(Duration(seconds: 1));

        log("query is this $graphQLQuery string");

        String query = '''
query {
 site{ 
    $graphQLQuery
  }
}

fragment ProductFields on Product {
  id
  entityId
  name
  prices(currencyCode: INR) {
    price {
      ...PriceFields
    }
    salePrice {
      ...PriceFields
    }
    basePrice {
      ...PriceFields
    }
    retailPrice {
      ...PriceFields
    }
  }
   defaultImage {
        url (width: 100)
        urlOriginal
        altText
        isDefault
      }
}

fragment PriceFields on Money {               
  currencyCode
  value
}

''';
        var result = await api.sendRequest.post(
            "https://store-${AppConfigure.storeFront}.mybigcommerce.com/graphql",
            data: {"query": query});

        int productIndex = 0;
        while (result.data['data']['site']['product$productIndex'] != null) {
          var productJson = result.data['data']['site']['product$productIndex'];
          products.add(WishlistProductModel.fromJson(productJson));
          productIndex++;
        }
        await Future.delayed(Duration(seconds: 1));
        log("result is this ${products.length}");
        setState(() {
          loader = false;
        });
      } else {}
    } catch (error, stackTrace) {
      log("error is this: $stackTrace");
      log("error is this: $error");
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initDynamicLinks();
    getallWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO use read insted of read and dispose the provider

    final wishlist = ref.watch(productDataProvider);
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
            automaticallyImplyLeading: false,
            title: Text(
              "Wishlist",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          bottomNavigationBar: MobjBottombar(
            bgcolor: AppColors.whiteColor,
            selcted_icon_color: AppColors.buttonColor,
            unselcted_icon_color: AppColors.blackColor,
            selectedPage: 3,
            screen1: HomeScreen(),
            screen2: SearchWidget(),
            screen3: WishlistScreen(),
            screen4: ProfileScreen(),
            ref: ref,
          ),
          body: Column(children: [
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {},
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1 / 1.4),
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              final isBookmarked = bookmarkedProduct.indexWhere(
                                  (p) => p.id == products[index].id);
                              final int staticStock =
                                  10; // Example static value for stock
                              final String staticVariantId =
                                  "static_variant_id";
                              return InkWell(
                                  onTap: () {
                                    ref.refresh(productDetailsProvider(
                                        products[index].id.toString()));
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                ProductDetailsScreen(
                                          uid: products[index].id.toString(),
                                          // product: products[index],
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  child: ProductListCard(
                                    shareProduct: () async {
                                      ShareItem().buildDynamicLinks(
                                          products[index].id.toString(),
                                          products[index]
                                              .defaultImage
                                              .toString(),
                                          products[index].name.toString());
                                    },

                                    isLikedToggle: "true",
                                    onLiked: () async {
                                      // ref
                                      //     .read(
                                      //         bookmarkedProductProvider
                                      //             .notifier)
                                      //     .toggleBookmark(
                                      //         products[index]);
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
                                        products[index].defaultImage.toString(),
                                    productName:
                                        products[index].name.toString(),
                                    address: products[index].name.toString(),
                                    datetime: products[index].name.toString(),
                                    // "${AppString.deliverAt} ${products[index].createdAt.toString()}/${products[index].createdAt}/${products[index].createdAt!}",
                                    productImage: products[index]
                                        .defaultImage
                                        .urlOriginal
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
                                    productDetails: staticVariantId,
                                    // "\u{20B9}${products[index].variants![0].price}",
                                    status: staticVariantId,

                                    // products[index]
                                    //     .variants
                                    //     .toString(),
                                    isLiked: isBookmarked.toString(),
                                    ratingCount: num.parse("5.5"),
                                    productId: products[index].id.toString(),
                                    productPrice: products[index]
                                        .prices
                                        .basePrice
                                        .value
                                        .toString(),
                                    // products[index]
                                    //         .prices
                                    //     //     .isEmpty
                                    //     // ? products[index]
                                    //     //     .variants![0]
                                    //     //     .price
                                    //     // : DefaultValues.defaultPrice
                                    //         .toString(),
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
                                    variantId:
                                        staticVariantId, // Assign static value to variantId
                                    stock: staticStock,
                                    // variantId: products[index]
                                    //     .variants[0]
                                    //     .id
                                    //     .toString(),
                                    // stock: products[index]
                                    //     .variants[0]
                                    //     .inventoryQuantity,
                                    ref: ref,
                                  ));
                            })),
                  ]),
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
