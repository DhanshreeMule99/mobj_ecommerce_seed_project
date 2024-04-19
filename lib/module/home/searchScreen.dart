// Search_user
import 'package:mobj_project/utils/cmsConfigue.dart';

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
                elevation: 2,
                title: Text(
                  appInfo.appName,
                ),
              ),
              bottomNavigationBar: MobjBottombar(
                bgcolor: AppColors.whiteColor,
                selcted_icon_color: AppColors.buttonColor,
                unselcted_icon_color: AppColors.blackColor,
                selectedPage: 1,
                screen1: const HomeScreen(),
                screen2: const SearchWidget(),
                screen3: const HomeScreen(),
                screen4: const ProfileScreen(),
                ref: ref,
              ),
              body: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchProduct,
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppDimension.buttonRadius)),
                              borderSide: BorderSide(
                                color: appInfo.primaryColorValue,
                                width: 1.5,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              //Outline border type for TextFeild
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimension.buttonRadius)),
                              borderSide: BorderSide(
                                width: 1.5,
                              )),
                          focusedBorder: OutlineInputBorder(
                              //Outline border type for TextFeild
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppDimension.buttonRadius)),
                              borderSide: BorderSide(
                                  color: appInfo.primaryColorValue,
                                  width: 1.5)),
                          suffixIcon: Icon(
                            Icons.search,
                            color: appInfo.primaryColorValue,
                          ),
                        ),
                        onChanged: (value) async {
                          ref
                              .read(searchQueryProvider.notifier)
                              .setSearchQuery(value);
                        },
                      )),
                  Expanded(
                      child: ListView.builder(
                          itemCount: product.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 15, right: 15),
                                child: InkWell(
                                    onTap: () {
                                      ref.refresh(productDetailsProvider(
                                        product[index].id.toString(),
                                      ));
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              ProductDetailsScreen(
                                            uid: product[index].id.toString(),
                                            product: product[index],
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    },
                                    child: Card(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ProductListCard(
                                            shareProduct: () async {
                                              ShareItem().buildDynamicLinks(
                                                  product[index].id.toString(),
                                                  product[index]
                                                      .image
                                                      .src
                                                      .toString(),
                                                  product[index]
                                                      .title
                                                      .toString());
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
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                                            tileColor:
                                                appInfo.primaryColorValue,
                                            logoPath: product[index]
                                                .image
                                                .src
                                                .toString(),
                                            productName:
                                                product[index].title.toString(),
                                            address: product[index]
                                                .bodyHtml
                                                .toString(),
                                            datetime:
                                                "${AppLocalizations.of(context)!.deliverAt} ${product[index].createdAt.toString()}/${product[index].createdAt}/${product[index].createdAt}",
                                            productImage: product[index]
                                                .image
                                                .src
                                                .toString(),
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
                                            status: product[index]
                                                .variants
                                                .toString(),
                                            isLiked: "-1",
                                            ratingCount: num.parse("5.5"),
                                            productId:
                                                product[index].id.toString(),
                                            productPrice: product[index]
                                                    .variants
                                                    .isNotEmpty
                                                ? product[index]
                                                    .variants[0]
                                                    .price
                                                : "35",
                                            addToCart: () {},
                                            variantId: product[index]
                                                .variants[0]
                                                .id
                                                .toString(),
                                            stock: product[index]
                                                .variants[0]
                                                .inventoryQuantity,
                                            ref: ref))));
                          })),
                ],
              ),
            ),
        error: (error, s) => const ErrorHandling(error_type: AppString.error),
        loading: () => const SkeletonLoaderWidget());
  }
}
