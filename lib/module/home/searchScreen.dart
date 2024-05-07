// Search_user
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../wishlist/wishlishScreen.dart';

final searchQueryProvider = StateNotifierProvider<SearchQueryNotifier, String>(
    (ref) => SearchQueryNotifier());

class SearchQueryNotifier extends StateNotifier<String> {
  SearchQueryNotifier() : super('');

  void setSearchQuery(String query) {
    state = query;
  }
}

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<SearchWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends ConsumerState<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final userModel = ref.watch(productDataProvider);

    List<ProductModel> product = userModel.when(
      data: (product) {
        // Filter product based on search query
        if (searchQuery.isNotEmpty) {
          return product
              .where((user) =>
                  user.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  user.bodyHtml
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
              .toList();
        } else {
          return product;
        }
      },
      loading: () => [], // Return an empty list when data is still loading
      error: (error, stackTrace) =>
          [], // Return an empty list when an error occurs
    );
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.secondary,

                automaticallyImplyLeading: true,
                // elevation: 2,
                // title: Text(
                //   appInfo.appName,
                // ),
              ),
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
              body: Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 8.sp, horizontal: 10.w),
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
                      child: TextField(
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: "Search Here",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.all(10.sp),
                            suffixIcon: Icon(
                              Ionicons.search,
                              size: 20.sp,
                            )),
                        onChanged: (value) async {
                          ref
                              .read(searchQueryProvider.notifier)
                              .setSearchQuery(value);
                        },
                      )),
                  Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1 / 1.6),
                          itemCount: product.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {
                                  ref.refresh(productDetailsProvider(
                                    product[index].id.toString(),
                                  ));
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              ProductDetailsScreen(
                                        uid: product[index].id.toString(),
                                        product: product[index],
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                                child: ProductListCard(
                                    shareProduct: () async {
                                      ShareItem().buildDynamicLinks(
                                          product[index].id.toString(),
                                          product[index].image.src.toString(),
                                          product[index].title.toString());
                                    },
                                    isLikedToggle: "false",
                                    // isBookmarked.toString(),

                                    onLiked: () async {
                                      // ref
                                      //     .read(
                                      //     bookmarkedProductProvider
                                      //         .notifier)
                                      //     .toggleBookmark(
                                      //     post[index]);
                                      //TODO list API integration of like
                                      // debouncer.run(() {
                                      // if ((product[index]
                                      //     .saveStatus ==
                                      // "true" &&
                                      // isBookmarked
                                      //     .toString() ==
                                      // "0") ||
                                      // (product[index]
                                      //     .saveStatus !=
                                      // "true" &&
                                      // isBookmarked
                                      //     .toString() ==
                                      // "-1")) {
                                      // Onsaved_repository()
                                      //     .onsaved(product[
                                      // index]
                                      //     .opportunityID
                                      //     .toString())
                                      //     .then(
                                      // (subjectFromServer) {
                                      // if (subjectFromServer ==
                                      // "Opportunity is already saved") {
                                      Fluttertoast.showToast(
                                          msg: "liked",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      // }
                                      // // ref.refresh(
                                      // //     ongoingDataProvider);
                                      //
                                      // Fluttertoast.showToast(
                                      // msg: subjectFromServer
                                      //     .toString(),
                                      // toastLength: Toast
                                      //     .LENGTH_SHORT,
                                      // gravity:
                                      // ToastGravity
                                      //     .BOTTOM,
                                      // timeInSecForIosWeb:
                                      // 1,
                                      // backgroundColor:
                                      // Colors.green,
                                      // textColor:
                                      // Colors.white,
                                      // fontSize: 16.0);
                                      // });
                                      // } else {
                                      // Onsaved_repository()
                                      //     .deletesaved(
                                      // product[
                                      // index]
                                      //     .opportunityID
                                      //     .toString())
                                      //     .then((val) {});
                                      // }
                                      // });
                                    },
                                    tileColor: appInfo.primaryColorValue,
                                    logoPath:
                                        product[index].image.src.toString(),
                                    productName:
                                        product[index].title.toString(),
                                    address: product[index].bodyHtml.toString(),
                                    datetime:
                                        "${AppLocalizations.of(context)!.deliverAt} ${product[index].createdAt.toString()}/${product[index].createdAt}/${product[index].createdAt}",
                                    productImage:
                                        product[index].image.src.toString(),
                                    ratings: () {
                                      //ToDo list rating
                                      // showDialog(
                                      // context: context,
                                      // builder: (context) =>
                                      // user_ratings.when(
                                      // data: (id) =>
                                      // RatingAlert(
                                      // onRatingSelected:
                                      // (rating) {
                                      // ratings = rating;
                                      // },
                                      // org_name: product[
                                      // index]
                                      //     .organizationName,
                                      // onsubmit: () {
                                      // setState(() {
                                      // var avgRating =
                                      // 0.0;
                                      // var sum = 0.0;
                                      // var len = 0.0;
                                      //
                                      // if (product[
                                      // index]
                                      //     .ratingsLength ==
                                      // "0") {
                                      // sum = double.parse(product[
                                      // index]
                                      //     .sumRatings!
                                      //     .toString()) +
                                      // ratings;
                                      // if (double.parse(
                                      // id.toString()) ==
                                      // "0") {
                                      // len = double.parse(productlist[
                                      // index]
                                      //     .ratingsLength!
                                      //     .toString()) +
                                      // 1;
                                      // } else {
                                      // len = double.parse(productlist[
                                      // index]
                                      //     .ratingsLength!
                                      //     .toString());
                                      // }
                                      // avgRating =
                                      // sum / len;
                                      // }
                                      // productlist[index]
                                      //     .rating =
                                      // ratings
                                      //     .toString();
                                      // });
                                      //
                                      // Rating_repository()
                                      //     .ratings(
                                      // productlist[
                                      // index]
                                      //     .opportunityID
                                      //     .toString(),
                                      // ratings
                                      //     .toString())
                                      //     .then((val) {
                                      // ref.refresh(
                                      // bookmarkedPostsProvider);
                                      //
                                      // ref.refresh(
                                      // opportunityDataProvider);
                                      // ref.refresh(userratingsProvider(
                                      // productlist[
                                      // index]
                                      //     .opportunityID
                                      //     .toString()));
                                      // Fluttertoast.showToast(
                                      // msg:
                                      // "Thank you for your feedback",
                                      // toastLength: Toast
                                      //     .LENGTH_SHORT,
                                      // gravity:
                                      // ToastGravity
                                      //     .BOTTOM,
                                      // timeInSecForIosWeb:
                                      // 1,
                                      // backgroundColor:
                                      // Colors
                                      //     .green,
                                      // textColor:
                                      // Colors
                                      //     .white,
                                      // fontSize:
                                      // 16.0);
                                      // });
                                      // Navigator.pop(
                                      // context);
                                      // },
                                      // user_rating:
                                      // double.parse(id
                                      //     .toString()),
                                      // ),
                                      // error: (error, s) => Text(
                                      // "OOPS Something went wrong"),
                                      // loading: () =>
                                      // Container(),
                                      // ),
                                      // );
                                    },
                                    productDetails:
                                        "\u{20B9}${product[index].variants[0].price}",
                                    status: product[index].variants.toString(),
                                    isLiked: "-1",
                                    ratingCount: num.parse("5.5"),
                                    productId: product[index].id.toString(),
                                    productPrice:
                                        product[index].variants.isNotEmpty
                                            ? product[index].variants[0].price
                                            : "35",
                                    addToCart: () {},
                                    variantId: product[index]
                                        .variants[0]
                                        .id
                                        .toString(),
                                    stock: product[index]
                                        .variants[0]
                                        .inventoryQuantity,
                                    ref: ref));
                          })),
                ],
              ),
            ),
        error: (error, s) => const ErrorHandling(error_type: AppString.error),
        loading: () => const SkeletonLoaderWidget());
  }
}
