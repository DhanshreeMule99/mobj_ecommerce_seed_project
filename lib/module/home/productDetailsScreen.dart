// productDetailsScreen

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:html/parser.dart' as htmlParser;

import '../../utils/imageDialog.dart';
import '../wishlist/wishlishScreen.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String uid;
  final ProductModel? product;

  const ProductDetailsScreen({
    super.key,
    required this.uid,
    this.product,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;
  var selectedVariant;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product != null) {
      selectedVariant = widget.product!.variants[0];
      setState(() {
        for (int i = 0; i <= widget.product!.options.length - 1; i++) {
          if (widget.product!.options[i].name.toLowerCase() == "color") {
            if (widget.product!.options[i].values
                .contains(selectedVariant.option1)) {
              selectedColor = selectedVariant.option1;
            } else {
              selectedColor = selectedVariant.option2;
            }
          }
          if (widget.product!.options[i].name.toLowerCase() == "size") {
            if (widget.product!.options[i].values
                .contains(selectedVariant.option1)) {
              selectedSize = selectedVariant.option1;
            } else {
              selectedSize = selectedVariant.option2;
            }
          }
        }
      });
    } else {
      ref.read(productDetailsProvider(widget.uid)).when(
            data: (product) {
              selectedVariant = product.variants[0];
              setState(() {
                for (int i = 0; i <= product.options.length - 1; i++) {
                  if (product.options[i].name.toLowerCase() == "color") {
                    if (product.options[i].values
                        .contains(selectedVariant.option1)) {
                      selectedColor = selectedVariant.option1;
                    } else {
                      selectedColor = selectedVariant.option2;
                    }
                  }
                  if (product.options[i].name.toLowerCase() == "size") {
                    if (product.options[i].values
                        .contains(selectedVariant.option1)) {
                      selectedSize = selectedVariant.option1;
                    } else {
                      selectedSize = selectedVariant.option2;
                    }
                  }
                }
              });
            },
            loading: () {},
            error: (error, stack) {},
          );
    }
  }

  String extractImageUrls(String htmlContent) {
    final document = htmlParser.parse(htmlContent);
    final imgElements = document.getElementsByTagName('img');
    final imageUrls =
        imgElements.map((element) => element.attributes['src']).toList();
    return imageUrls.join(', '); // Concatenate the URLs with a separator
  }

  String extractTextContent(String htmlContent) {
    final document = htmlParser.parse(htmlContent);
    final textElements = document.getElementsByTagName('p');
    final textContent = textElements.map((element) => element.text).join(' ');
    return textContent;
  }

  String? selectedColor;
  String? selectedSize;
  int currentIndex = 0;
  bool isLoading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    final user = ref.watch(productDetailsProvider(widget.uid));
    final ratingProduct = ref.watch(productReviewsProvider(widget.uid));
    final product = ref.watch(productRecommendedDataProvider(widget.uid));
    final productRating = ref.watch(productRatingProvider(widget.uid));
    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: const Text(""),
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
            body: widget.uid == ""
                ? Text(AppLocalizations.of(context)!.noData)
                : user.when(
                    data: (user) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    child: buildContent(
                                        context,
                                        user,
                                        ref,
                                        appInfoAsyncValue,
                                        product,
                                        ratingProduct,
                                        productRating))),
                          ]);
                    },
                    error: (error, s) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                              child: ErrorHandling(
                                error_type: "error",
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                              ),
                              onPressed: () {
                                ref.refresh(productDetailsProvider(widget.uid));
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
                    loading: () => const SkeletonLoaderWidget())),
        error: (error, s) => const SizedBox(),
        loading: () => const SizedBox());
  }

  Widget buildContent(
      BuildContext context,
      ProductModel productModel,
      WidgetRef ref,
      AsyncValue<AppInfo> appInfoAsyncValue,
      AsyncValue<List<RecommendedProductModel>> product,
      AsyncValue<ReviewProductModels> ratingProduct,
      AsyncValue<ProductRatingModel> productRating) {
    return SingleChildScrollView(
        child: appInfoAsyncValue.when(
      data: (appInfo) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          AppConfigure.bigCommerce == true
              ? Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                  child: Center(
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              try {
                                return ImageDialog(
                                  imageUrl: productModel.image.src,
                                );
                              } catch (e) {
                                return Container();
                              }
                            },
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: productModel.image.src,
                          imageBuilder: (context, imageProvider) => Container(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                //image size fill
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.whiteColor,
                          ),
                          errorWidget: (context, url, error) => Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              color: AppColors.whiteColor),
                        )),
                  ),
                )
              : selectedVariant != null &&
                      selectedVariant != DefaultValues.defaultVariants
                  ? selectedVariant.imageId != DefaultValues.defaultImageId
                      ? Column(
                          children: productModel.images.map(
                            (images) {
                              return images.id == selectedVariant.imageId
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0, top: 0),
                                      child: Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  try {
                                                    return ImageDialog(
                                                      imageUrl: selectedVariant !=
                                                              null
                                                          ? images.id ==
                                                                  selectedVariant
                                                                      .imageId
                                                              ? images.src
                                                              : productModel
                                                                  .image.src
                                                          : productModel
                                                              .image.src,
                                                    );
                                                  } catch (e) {
                                                    return Container();
                                                  }
                                                },
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: selectedVariant != null
                                                  ? images.id ==
                                                          selectedVariant
                                                              .imageId
                                                      ? images.src
                                                      : productModel.image.src
                                                  : productModel.image.src,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    //image size fill
                                                    image: imageProvider,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: AppColors.whiteColor,
                                              ),
                                              errorWidget:
                                                  (context, url,
                                                          error) =>
                                                      Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          color: AppColors
                                                              .whiteColor),
                                            )),
                                      ),
                                    )
                                  : Container();
                            },
                          ).toList(), // Convert Iterable<Padding> to List<Widget>
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 0),
                          child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      try {
                                        return ImageDialog(
                                          imageUrl: productModel.image.src,
                                        );
                                      } catch (e) {
                                        return Container();
                                      }
                                    },
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: productModel.image.src,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        //image size fill
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColors.whiteColor,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: AppColors.whiteColor),
                                )),
                          ),
                        )
                  : Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  try {
                                    return ImageDialog(
                                      imageUrl: productModel.image.src,
                                    );
                                  } catch (e) {
                                    return Container();
                                  }
                                },
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: productModel.image.src,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    //image size fill
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.whiteColor,
                              ),
                              errorWidget: (context, url, error) => Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width,
                                  color: AppColors.whiteColor),
                            )),
                      ),
                    ),
          const SizedBox(height: 15),

          Text(
            productModel.title,
            style: TextStyle(
              fontSize: 0.05 * MediaQuery.of(context).size.width,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Text(
                "\u{20B9}${selectedVariant != null ? selectedVariant.price : productModel.variants[0].price}",
                style: TextStyle(
                  fontSize: 0.05 * MediaQuery.of(context).size.width,
                  fontWeight: FontWeight.w700,
                ),
              )),
            ],
          ),
          Wrap(
            children: productModel.options.asMap().entries.map((entry) {
              return SizedBox(
                child: entry.value.name.toLowerCase() == "color"
                    ? Column(children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.selectColor,
                          style: TextStyle(
                            fontSize: 0.05 * MediaQuery.of(context).size.width,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ])
                    : Container(),
              );
            }).toList(),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            children: productModel.options.asMap().entries.map((entry) {
              return SizedBox(
                child: entry.value.name.toLowerCase() == "color"
                    ? Wrap(
                        spacing: 8.0, // Horizontal spacing between items
                        runSpacing: 8.0, // Vertical spacing between items
                        children: entry.value.values.map(
                          (color) {
                            return GestureDetector(
                              onTap: () {
                                selectedVariant = productModel.variants
                                    .firstWhere(
                                        (variant) => variant.option1 == color,
                                        orElse: () =>
                                            productModel.variants.firstWhere(
                                              (variant) =>
                                                  variant.option2 == color,
                                            ));
                                setState(() {
                                  selectedColor = color;
                                  quantity = 1;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                margin: const EdgeInsets.only(bottom: 5),
                                // Add margin for spacing
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedColor == color
                                          ? appInfo.primaryColorValue
                                          : AppColors.blackColor,
                                      width: selectedColor == color ? 2 : 1),
                                  borderRadius: BorderRadius.circular(
                                      AppDimension.buttonRadius),
                                ),
                                child: Text(
                                  color,
                                  style: TextStyle(
                                    fontSize: 0.04 *
                                        MediaQuery.of(context).size.width,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList())
                    : Container(),
              );
            }).toList(),
          ),
          Wrap(
            children: productModel.options.asMap().entries.map((entry) {
              return SizedBox(
                child: entry.value.name.toLowerCase() == "size"
                    ? Column(children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(AppLocalizations.of(context)!.selectSize,
                            style: TextStyle(
                              fontSize:
                                  0.05 * MediaQuery.of(context).size.width,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                      ])
                    : Container(),
              );
            }).toList(),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            children: productModel.options.asMap().entries.map((entry) {
              return SizedBox(
                child: entry.value.name.toLowerCase() == "size"
                    ? Wrap(
                        spacing: 8.0, // Horizontal spacing between items
                        runSpacing: 8.0, // Vertical spacing between items
                        children: entry.value.values.map(
                          (size) {
                            return GestureDetector(
                              onTap: () {
                                selectedVariant = productModel.variants
                                    .firstWhere(
                                        (variant) => variant.option1 == size,
                                        orElse: () =>
                                            productModel.variants.firstWhere(
                                              (variant) =>
                                                  variant.option2 == size,
                                            ));
                                setState(() {
                                  selectedSize = size;
                                  quantity = 1;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                margin: const EdgeInsets.only(bottom: 5),
                                // Add margin for spacing
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedSize == size
                                          ? appInfo.primaryColorValue
                                          : AppColors.blackColor,
                                      width: selectedSize == size ? 2 : 1),
                                  borderRadius: BorderRadius.circular(
                                      AppDimension.buttonRadius),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 0.04 *
                                        MediaQuery.of(context).size.width,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList())
                    : Container(),
              );
            }).toList(),
          ),
          //  Wrap(
          //   spacing: 10,
          //   children: productModel.options.asMap().entries.map((entry) {
          //     return
          //       Wrap(
          //         spacing: 8.0, // Horizontal spacing between items
          //         runSpacing: 8.0, // Vertical spacing between items
          //         children: productModel.options.asMap().entries.map((entry) {
          //           return entry.value.name.toLowerCase() == "size"
          //               ? GestureDetector(
          //                   onTap: () {
          //                     selectedVariant = productModel.variants
          //                         .firstWhere(
          //                             (variant) => variant.option1 == size,
          //                             orElse: () =>
          //                                 productModel.variants.firstWhere(
          //                                   (variant) =>
          //                                       variant.option2 == size,
          //                                 ));
          //
          //                     setState(() {
          //                       selectedSize = size;
          //                     });
          //                   },
          //                   child: Container(
          //                     padding: const EdgeInsets.symmetric(
          //                       vertical: 10,
          //                       horizontal: 20,
          //                     ),
          //                     margin: const EdgeInsets.only(bottom: 5),
          //                     // Add margin for spacing
          //                     decoration: BoxDecoration(
          //                       border: Border.all(
          //                           color: selectedSize == size
          //                               ? appInfo.primaryColorValue
          //                               : AppColors.blackColor,
          //                           width: selectedSize == size ? 2 : 1),
          //                       borderRadius: BorderRadius.circular(
          //                           AppDimension.buttonRadius),
          //                     ),
          //                     child: Text(
          //                       size,
          //                       style: TextStyle(
          //                         fontSize:
          //                             0.04 * MediaQuery.of(context).size.width,
          //                         fontWeight: FontWeight.w400,
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               : Container();
          //         }));
          //   }).toList(),
          // ),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context)!.quantity,
            style: TextStyle(
              fontSize: 0.05 * MediaQuery.of(context).size.width,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          selectedVariant != null
              ? selectedVariant.inventoryQuantity > 0
                  ? Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.blackColor, width: 1.5),
                        borderRadius:
                            BorderRadius.circular(AppDimension.buttonRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (selectedVariant != null) {
                                  if (quantity <
                                      selectedVariant.inventoryQuantity) {
                                    quantity++;
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only ${selectedVariant.inventoryQuantity} left in stock",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 0,
                                        backgroundColor: AppColors.blackColor,
                                        textColor: AppColors.whiteColor,
                                        fontSize: 16.0);
                                  }
                                } else {
                                  if (quantity <
                                      productModel
                                          .variants[0].inventoryItemId) {
                                    quantity++;
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only ${selectedVariant.inventoryQuantity} left in stock",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 0,
                                        backgroundColor: AppColors.blackColor,
                                        textColor: AppColors.whiteColor,
                                        fontSize: 16.0);
                                  }
                                }
                              });
                            },
                          ),
                        ],
                      ))
                  : outOfStockCard()
              : productModel.variants[0].inventoryQuantity > 0
                  ? Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.blackColor, width: 1.5),
                        borderRadius:
                            BorderRadius.circular(AppDimension.buttonRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (selectedVariant != null) {
                                  if (quantity <
                                      productModel
                                          .variants[0].inventoryQuantity) {
                                    quantity++;
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only ${productModel.variants[0].inventoryQuantity} left in stock",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 0,
                                        backgroundColor: AppColors.blackColor,
                                        textColor: AppColors.whiteColor,
                                        fontSize: 16.0);
                                  }
                                } else {
                                  if (quantity <
                                      productModel
                                          .variants[0].inventoryQuantity) {
                                    quantity++;
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only ${productModel.variants[0].inventoryQuantity} left in stock",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 0,
                                        backgroundColor: AppColors.blackColor,
                                        textColor: AppColors.whiteColor,
                                        fontSize: 16.0);
                                  }
                                }
                              });
                            },
                          ),
                        ],
                      ))
                  : outOfStockCard(),
          productModel.bodyHtml != ""
              ? const SizedBox(
                  height: 10,
                )
              : const SizedBox(),
          productModel.bodyHtml != ""
              ? Text(
                  extractTextContent(productModel.bodyHtml).isNotEmpty
                      ? extractTextContent(productModel.bodyHtml)
                      : productModel.bodyHtml,
                  style: TextStyle(
                    fontSize: 0.04 * MediaQuery.of(context).size.width,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Container(),
          productModel.bodyHtml != ""
              ? const SizedBox(
                  height: 10,
                )
              : const SizedBox(
                  height: 10,
                ),
          productModel.tags.toString() != ""
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.label,
                      size: 18,
                    ),
                    Expanded(child: Text(" ${productModel.tags.toString()}")),
                  ],
                )
              : Container(),
          productModel.tags.toString() != ""
              ? const SizedBox(height: 16)
              : Container(),

          productRating.when(
            data: (product) {
              final post = product;

              return InkWell(
                  onTap: () {
                    showReviewsBottomSheet(context, ratingProduct);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            children: List.generate(
                          5,
                          (index) => Icon(
                            index < product.average.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.yellow,
                          ),
                        )),
                        Text(
                          " (${product.count.toString()})",
                          style: TextStyle(
                            fontSize: 0.04 * MediaQuery.of(context).size.width,
                          ),
                        ),
                        // SizedBox(height: 15,)
                      ]));
            },
            error: (error, s) => Container(),
            loading: () => Container(),
          ),
          const SizedBox(height: 25),
          error != ""
              ? Column(
                  children: [
                    Center(
                        child: Text(
                      error,
                      style: const TextStyle(color: AppColors.red),
                    )),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                )
              : Container(),

          ElevatedButton(
              onPressed: () async {
                isLogin().then((value) {
                  print("$value");
                  if (value == true) {
                    CommonAlert.show_loading_alert(context);
                    if ((selectedVariant != null &&
                            selectedVariant.inventoryQuantity > 0) ||
                        productModel.variants[0].inventoryQuantity > 0) {
                      setState(() {
                        isLoading = true;
                      });
                      int? variantId;
                      List<ProductVariant> filteredVariants =
                          productModel.variants.where((variant) {
                        if ((variant.option1 != DefaultValues.defaultOption1) &&
                            (variant.option2 == DefaultValues.defaultOption2 &&
                                variant.option3 ==
                                    DefaultValues.defaultOption3)) {
                          return ((variant.option1
                                  .contains(selectedSize.toString())) ||
                              (variant.option1
                                  .contains(selectedColor.toString())));
                        } else if ((variant.option1 !=
                                DefaultValues.defaultOption1) &&
                            (variant.option2 != DefaultValues.defaultOption2 &&
                                variant.option3 ==
                                    DefaultValues.defaultOption3)) {
                          return (((variant.option1
                                      .contains(selectedSize.toString())) ||
                                  (variant.option1
                                      .contains(selectedColor.toString()))) &&
                              ((variant.option2
                                      .contains(selectedSize.toString())) ||
                                  (variant.option2
                                      .contains(selectedColor.toString()))));
                        } else {
                          return ((variant.option1
                                  .contains(selectedSize.toString())) ||
                              (variant.option1
                                  .contains(selectedColor.toString())));
                        }
                      }).toList();

                      // Display the filtered variants
                      for (var variant in filteredVariants) {
                        variantId = variant.id;
                      }

                      if (AppConfigure.bigCommerce) {
                        ProductRepository()
                            .addToCartBigcommerce(
                                variantId != null
                                    ? variantId.toString()
                                    : productModel.variants[0].id.toString(),
                                quantity.toString(),
                                productModel.title,
                                selectedVariant != null
                                    ? selectedVariant.price
                                    : productModel.variants[0].price,
                                productModel.id.toString())
                            .then((value) async {
                          if (value == AppString.success) {
                            Navigator.of(context).pop();
                            ref.refresh(cartDetailsDataProvider);
                            ref.refresh(productDetailsProvider(widget.uid));
                            Fluttertoast.showToast(
                                msg: AppString.addToCartSuccess,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 0,
                                backgroundColor: AppColors.green,
                                textColor: AppColors.whiteColor,
                                fontSize: 16.0);
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
                      } else if (AppConfigure.wooCommerce) {
                        //  log('product to ${widget.productId} ${widget.variantId}');
                        ProductRepository()
                            .addToCartWooCommerce(
                          quantity.toString(),
                          variantId != null
                              ? variantId.toString()
                              : productModel.variants[0].id.toString(),
                        )
                            .then((value) async {
                          if (value == AppString.success) {
                            Navigator.of(context).pop();
                            ref.refresh(productDataProvider);
                            ref.refresh(cartDetailsDataProvider);
                            ref.refresh(productDetailsProvider(widget.uid));
                            Fluttertoast.showToast(
                                msg: AppString.addToCartSuccess,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 0,
                                backgroundColor: AppColors.green,
                                textColor: AppColors.whiteColor,
                                fontSize: 16.0);
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
                      } else {
                        ProductRepository()
                            .addToCart(
                                variantId != null
                                    ? variantId.toString()
                                    : productModel.variants[0].id.toString(),
                                quantity.toString())
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value == AppString.success) {
                            setState(() {
                              error = "";
                              isLoading = false;
                            });
                            ref.refresh(cartDetailsDataProvider);
                            ref.refresh(productDetailsProvider(widget.uid));
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)!
                                    .addToCartSuccess,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 0,
                                backgroundColor: AppColors.green,
                                textColor: AppColors.whiteColor,
                                fontSize: 16.0);
                          } else {
                            setState(() {
                              error = AppLocalizations.of(context)!.oops;
                              isLoading = false;
                            });
                          }
                        });
                      }
                    }
                  } else {
                    CommonAlert.showAlertAndNavigateToLogin(context);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedVariant != null
                    ? selectedVariant.inventoryQuantity > 0
                        ? appInfo.primaryColorValue
                        : AppColors.greyShade200
                    : productModel.variants[0].inventoryQuantity > 0
                        ? appInfo.primaryColorValue
                        : AppColors.greyShade200,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimension.buttonRadius)),
                textStyle: TextStyle(
                    color: selectedVariant != null
                        ? selectedVariant.inventoryQuantity > 0
                            ? AppColors.whiteColor
                            : AppColors.blackColor
                        : productModel.variants[0].inventoryQuantity > 0
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                    fontSize: 10,
                    fontStyle: FontStyle.normal),
              ),
              child: Text(
                AppLocalizations.of(context)!.addToCart.toUpperCase(),
                style: TextStyle(
                    color: selectedVariant != null
                        ? selectedVariant.inventoryQuantity > 0
                            ? AppColors.whiteColor
                            : AppColors.blackColor
                        : productModel.variants[0].inventoryQuantity > 0
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 25),

          product.when(
            data: (product) {
              List<RecommendedProductModel> productlist =
                  product.map((e) => e).toList();
              return RefreshIndicator(
                // Wrap the list in a RefreshIndicator widget
                onRefresh: () async {
                  ref.refresh(productDataProvider);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.relatedProduct,
                        style: TextStyle(
                          fontSize: 0.05 * MediaQuery.of(context).size.width,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          padEnds: true,
                          height: MediaQuery.of(context).size.height * 0.42,
                          // Responsive height
                          enableInfiniteScroll: productModel.images.length > 1,
                          viewportFraction: 1,
                          enlargeCenterPage: false,
                          autoPlayInterval: const Duration(seconds: 4),
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        items: productlist
                            .map(
                              (productlist) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 0),
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1,
                                                animation2) =>
                                            ProductDetailsScreen(
                                                uid: productlist.id.toString()),
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
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ProductListCard(
                                      ref: ref,
                                      stock:
                                          productlist.variants[0].available ==
                                                  true
                                              ? 1
                                              : 0,
                                      variantId:
                                          productlist.variants[0].id.toString(),
                                      shareProduct: () async {
                                        ShareItem().buildDynamicLinks(
                                            productlist.id.toString(),
                                            !productlist.images[0]
                                                    .contains("http")
                                                ? "https:${productlist.images[0]}"
                                                    .toString()
                                                : productlist.images[0],
                                            productlist.title.toString());
                                      },
                                      isLikedToggle: "true",
                                      onLiked: () async {
                                        // Handle like logic here
                                      },
                                      tileColor: appInfo.primaryColorValue,
                                      logoPath: !productlist.featuredImage
                                              .toString()
                                              .contains("http")
                                          ? "https:${productlist.featuredImage}"
                                              .toString()
                                          : productlist.featuredImage
                                              .toString(),
                                      productName: productlist.title.toString(),
                                      address:
                                          productlist.description.toString(),
                                      datetime:
                                          "${AppLocalizations.of(context)!.deliverAt} ${productlist.createdAt.toString()}/${productlist.createdAt}/${productlist.createdAt}",
                                      productImage: !productlist.featuredImage
                                              .toString()
                                              .contains("http")
                                          ? "https:${productlist.featuredImage}"
                                              .toString()
                                          : productlist.featuredImage
                                              .toString(),
                                      ratings: () {
                                        // Handle rating logic here
                                      },
                                      productDetails:
                                          "\u{20B9}${productlist.variants[0].price}",
                                      status: productlist.variants.toString(),
                                      isLiked: "-1",
                                      ratingCount: num.parse("5.5"),
                                      productId: productlist.id.toString(),
                                      productPrice:
                                          productlist.price.toString(),
                                      addToCart: () {},
                                    ),
                                  ),
                                )),
                              ),
                            )
                            .toList(),
                      ),
                      Container(
                        // height: 100, // Set a fixed height for the container
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: productlist.map((imagePath) {
                              int index = productlist.indexOf(imagePath);
                              return Flexible(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.grey),
                                    color: currentIndex == index
                                        ? AppColors.blackColor
                                        : AppColors.whiteColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ]),
              );
            },
            error: (error, s) => Container(),
            loading: () => const SkeletonLoaderWidget(),
          ),
          ratingProduct.when(
            data: (product) {
              // List<ReviewProductModel> productlist =
              //     product.map((e) => e).toList();

              return RefreshIndicator(
                // Wrap the list in a RefreshIndicator widget
                onRefresh: () async {
                  ref.refresh(productDataProvider);
                },
                child: product.reviews.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            const SizedBox(
                              height: 0,
                            ),
                            Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)!
                                          .customerReview,
                                      style: TextStyle(
                                        fontSize: 0.05 *
                                            MediaQuery.of(context).size.width,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  ElevatedButton(
                                      onPressed: () async {
                                        isLogin().then((value) {
                                          if (value == true) {
                                            // CommonAlert.show_loading_alert(context);

                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    RatingAlert(
                                                      onRatingSelected:
                                                          (double rating) {},
                                                      pid: widget.uid,
                                                      onsubmit: () {},
                                                      user_rating: 0,
                                                      ref: ref,
                                                    )); // ProductRepository()
                                          } else {
                                            CommonAlert
                                                .showAlertAndNavigateToLogin(
                                                    context);
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.green,
                                        // minimumSize: const Size.fromHeight(50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppDimension.buttonRadius)),
                                        textStyle: TextStyle(
                                            color: selectedVariant != null
                                                ? selectedVariant
                                                            .inventoryQuantity >
                                                        0
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor
                                                : productModel.variants[0]
                                                            .inventoryQuantity >
                                                        0
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor,
                                            fontSize: 10,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .addReview
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: selectedVariant != null
                                                ? selectedVariant
                                                            .inventoryQuantity >
                                                        0
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor
                                                : productModel.variants[0]
                                                            .inventoryQuantity >
                                                        0
                                                    ? AppColors.whiteColor
                                                    : AppColors.blackColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ]),
                            const SizedBox(height: 10),
                            for (int index = 0;
                                index < product.reviews.length && index < 1;
                                index++)
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 2,
                                                              left: 3,
                                                              right: 5,
                                                              bottom: 2),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: AppColors
                                                                .whiteColor,
                                                            size: 0.04 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                              product
                                                                  .reviews[
                                                                      index]
                                                                  .rating
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 0.04 *
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              )),
                                                        ],
                                                      ))),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  product.reviews[index].title
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 0.04 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ])),
                                    product.reviews[index].body.toString() != ""
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 3, bottom: 5),
                                            child: Text(
                                                AppConfigure.wooCommerce
                                                    ? extractTextContent(product
                                                        .reviews[index].body)
                                                    : product
                                                        .reviews[index].body
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 0.04 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                )))
                                        : Container(),
                                    const Divider(),
                                    const SizedBox(
                                      height: 0,
                                    )
                                  ]),
                            if (product.reviews.length > 1)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: InkWell(
                                    onTap: () {
                                      showReviewsBottomSheet(
                                          context, ratingProduct);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .readMore
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: appInfo.primaryColorValue,
                                        // Change the color as needed
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                          ])
                    : Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Text(AppLocalizations.of(context)!.noReview,
                                style: TextStyle(
                                  fontSize:
                                      0.05 * MediaQuery.of(context).size.width,
                                  fontWeight: FontWeight.w700,
                                )),
                            ElevatedButton(
                                onPressed: () async {
                                  isLogin().then((value) {
                                    if (value == true) {
                                      // CommonAlert.show_loading_alert(context);

                                      showDialog(
                                          context: context,
                                          builder: (context) => RatingAlert(
                                                onRatingSelected:
                                                    (double rating) {},
                                                pid: widget.uid,
                                                onsubmit: () {},
                                                user_rating: 0,
                                                ref: ref,
                                              )); // ProductRepository()
                                    } else {
                                      CommonAlert.showAlertAndNavigateToLogin(
                                          context);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  // minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimension.buttonRadius)),
                                  textStyle: TextStyle(
                                      color: selectedVariant != null
                                          ? selectedVariant.inventoryQuantity >
                                                  0
                                              ? AppColors.whiteColor
                                              : AppColors.blackColor
                                          : productModel.variants[0]
                                                      .inventoryQuantity >
                                                  0
                                              ? AppColors.whiteColor
                                              : AppColors.blackColor,
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .addReview
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: selectedVariant != null
                                          ? selectedVariant.inventoryQuantity >
                                                  0
                                              ? AppColors.whiteColor
                                              : AppColors.blackColor
                                          : productModel.variants[0]
                                                      .inventoryQuantity >
                                                  0
                                              ? AppColors.whiteColor
                                              : AppColors.blackColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold),
                                )),
                          ]),
              );
            },
            error: (error, s) => Container(
              child: ElevatedButton(
                  onPressed: () async {
                    isLogin().then((value) {
                      if (value == true) {
                        // CommonAlert.show_loading_alert(context);

                        showDialog(
                            context: context,
                            builder: (context) => RatingAlert(
                                  onRatingSelected: (double rating) {},
                                  pid: widget.uid,
                                  onsubmit: () {},
                                  user_rating: 0,
                                  ref: ref,
                                )); // ProductRepository()
                      } else {
                        CommonAlert.showAlertAndNavigateToLogin(context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    // minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimension.buttonRadius)),
                    textStyle: TextStyle(
                        color: selectedVariant != null
                            ? selectedVariant.inventoryQuantity > 0
                                ? AppColors.whiteColor
                                : AppColors.blackColor
                            : productModel.variants[0].inventoryQuantity > 0
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.addReview.toUpperCase(),
                    style: TextStyle(
                        color: selectedVariant != null
                            ? selectedVariant.inventoryQuantity > 0
                                ? AppColors.whiteColor
                                : AppColors.blackColor
                            : productModel.variants[0].inventoryQuantity > 0
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            loading: () => Container(),
          ),
        ],
      ),
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
    ));
  }

  String jwt_token = "";
  String userid = "";

  Future<bool> isLogin() async {
    final jwt = await SharedPreferenceManager().getToken();
    jwt_token = jwt;
    final uid = await SharedPreferenceManager().getUserId();
    final did = await SharedPreferenceManager().getDeviceId();
    userid = uid;

    if (jwt_token != '' || userid != '') {
      return true;
    } else {
      return false;
    }
  }

  Widget outOfStockCard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(
            AppDimension.buttonRadius), // Set the radius to 35
      ),
      child: Text(
        AppLocalizations.of(context)!.outOfStock,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showReviewsBottomSheet(
      BuildContext context, AsyncValue<ReviewProductModels> ratingProduct) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(15.0),
      )),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ratingProduct.when(
            data: (product) {
              // List<ReviewProductModel> productlist =
              //     product.map((e) => e).toList();
              return RefreshIndicator(
                // Wrap the list in a RefreshIndicator widget
                onRefresh: () async {
                  ref.refresh(productDataProvider);
                },
                child: product.reviews.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            const SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Center(
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .customerReview,
                                    style: TextStyle(
                                      fontSize: 0.05 *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: FontWeight.w700,
                                    ))),
                            const SizedBox(height: 20),
                            for (int index = 0;
                                index < product.reviews.length;
                                index++)
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Row(
                                                // mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: AppColors.green,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(15.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 2,
                                                                  left: 3,
                                                                  right: 5,
                                                                  bottom: 2),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color: AppColors
                                                                    .whiteColor,
                                                                size: 0.04 *
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              Text(
                                                                  product
                                                                      .reviews[
                                                                          index]
                                                                      .rating
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 0.04 *
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                    color: AppColors
                                                                        .whiteColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  )),
                                                            ],
                                                          ))),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      product
                                                          .reviews[index].title
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 0.04 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                ])),
                                        product.reviews[index].body
                                                    .toString() !=
                                                ""
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, left: 3, bottom: 5),
                                                child: Text(
                                                    AppConfigure.wooCommerce
                                                        ? extractTextContent(
                                                            product
                                                                .reviews[index]
                                                                .body)
                                                        : product
                                                            .reviews[index].body
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 0.04 *
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    )))
                                            : Container(),
                                        const Divider(),
                                      ]))
                          ])
                    : Container(),
              );
            },
            error: (error, s) => Container(),
            loading: () => const SkeletonLoaderWidget(),
          ),
        );
      },
    );
  }
}
