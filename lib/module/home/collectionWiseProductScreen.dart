// collectionWiseProductScreen
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../models/product/collectionProductModel.dart';
import '../../services/shopifyServices/graphQLServices/graphQlRespository.dart';
import '../../utils/api.dart';

class CollectionWiseProductScreen extends ConsumerStatefulWidget {
  final String category;
  final String categoryName;

  const CollectionWiseProductScreen({
    super.key,
    required this.category,
    required this.categoryName,
  });

  @override
  ConsumerState<CollectionWiseProductScreen> createState() =>
      _CollectionWiseProductScreenState();
}

final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  HttpLink httpLink = HttpLink(
    AppConfigure.baseUrl + APIConstants.graphQL,
    defaultHeaders: {
      'X-Shopify-Storefront-Access-Token': AppConfigure.storeFrontToken
    },
  );

  return GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );
});
TextEditingController minPriceController = TextEditingController();
TextEditingController maxPriceController = TextEditingController();
double start = 0.0;
double end = 0.0;

class _CollectionWiseProductScreenState
    extends ConsumerState<CollectionWiseProductScreen> {
  bool isFilter = false;
  bool isFilters = false;
  bool toggleIcon = false;
  GraphQlRepository graphQLConfig = GraphQlRepository();
  String plus = "+";
  final productsProvider =
      FutureProvider.family<List<ProductCollectionModel>, String>(
          (ref, pid) async {
    if (AppConfigure.bigCommerce) {
    } else {
      final graphqlClient = ref.read(graphqlClientProvider);
      final QueryResult result = await graphqlClient.query(QueryOptions(
        document: gql('''
      query Price(\$handle: String) {
        collection(handle: \$handle) {
          handle
          products(
            first: 10
            filters: { price: { min: $start, max:$end} }
          ) {
            edges {
              node {
                id
                handle
                title
                description
                featuredImage { src }
                images(first:4){
                edges{
                    node{ url }
                }
            }
                priceRange {
                  minVariantPrice {
                    amount
                    currencyCode
                  }
                  maxVariantPrice {
                    amount
                    currencyCode
                  }
                }
              }
            }
          }
        }
      }
    '''),
        variables: {'handle': pid},
      ));
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      final List<ProductCollectionModel> products =
          (result.data?['collection']['products']['edges'] as List)
              .map((edge) => ProductCollectionModel.fromJson(edge['node']))
              .toList();

      return products;
    }
    throw Error();
  });
  final collectionWiseProvider =
      FutureProvider.family<List<ProductCollectionModel>, String>(
          (ref, pid) async {
    if (AppConfigure.wooCommerce) {
      log("Product from woocommerce");
      API api = API();
      try {
        final response = await api.sendRequest.get(
            'https://ttf.setoo.org/wp-json/wc/v3/products/?category=$pid&consumer key=ck_db1d729eb2978c28ae46451d36c1ca02da112cb3&consumer secret=cs_c5cc06675e8ffa375b084acd40987fec142ec8cf');

        if (response.statusCode == APIConstants.successCode) {
          // Parse the response body
          log("123");
          // log(response.body);
          List<dynamic> responseBody = response.data;
          //log("From json ${responseBody.length} ${responseBody.map((e) => ProductCollectionModel.fromJson(e)).toList()}");

          List<ProductCollectionModel> products = responseBody
              .map((e) => ProductCollectionModel(
                  title: e['name'],
                  description: '',
                  handle: '',
                  featuredImage: e['images'][0]['src'],
                  minPrice: double.parse(e['price']),
                  maxPrice: double.parse(e['price']),
                  currencyCode: '',
                  imageUrls: [e['images'][0]['src']],
                  id: e['id'].toString()))
              .toList();
          return products;
        } else {
          // Handle API error response
          List<ProductCollectionModel> products = [];
          return products;
        }
      } catch (error, stackTrac) {
        // Handle error
        print('Error: $error $stackTrac');
        List<ProductCollectionModel> products = [];
        return products;
      }
      // return products;
    } else if (AppConfigure.bigCommerce) {
      API api = API();
      try {
        final response = await ApiManager.get(
            'https://api.bigcommerce.com/stores/${AppConfigure.storeFront}/v3/catalog/categories/$pid/products/sort-order');

        if (response.statusCode == APIConstants.successCode) {
          // Parse the response body
          final Map<String, dynamic> responseBody = json.decode(response.body);
          final List<dynamic> data = responseBody['data'] ?? [];

          // Extract product IDs from the response
          // List<int> productIds = [];
          // for (var productData in data)
          //  {
          //   final int productId = productData['product_id'];

          // }

          String graphQLQuery = '';
          for (int i = 0; i < data.length; i++) {
            graphQLQuery += '''
      product$i: product(entityId: ${data[i]['product_id']}) {
        ...ProductFields
      }
    ''';
          }

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
  sku
  path
  name
  description
  addToCartUrl
  upc
  mpn
  gtin
  prices(currencyCode: USD) {
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

          final List<ProductCollectionModel> products = [];
          int productIndex = 0;
          while (result.data['data']['site']['product$productIndex'] != null) {
            var productJson =
                result.data['data']['site']['product$productIndex'];
            products.add(ProductCollectionModel.fromJson(productJson));
            productIndex++;
          }
          log("proudcts are this $products");

          return products;
        } else {
          // Handle API error response
          List<ProductCollectionModel> products = [];
          return products;
        }
      } catch (error, stackTrac) {
        // Handle error
        print('Error: $error $stackTrac');
        List<ProductCollectionModel> products = [];
        return products;
      }
    } else {
      final graphqlClient = ref.read(graphqlClientProvider);
      final QueryResult result = await graphqlClient.query(QueryOptions(
        document: gql('''
      query getProductsByCollectionId(\$collectionId: ID!, \$limit: Int) {
            collection(id: \$collectionId) {
              title
              image {
                url
              }
              description
              products(first: \$limit) {
                nodes {
                  id
                  title
                  description
                  images(first: 4) {
                    edges {
                      node {
                        url
                      }
                    }
                  }
                  priceRange {
                  minVariantPrice {
                    amount
                    currencyCode
                  }
                  maxVariantPrice {
                    amount
                    currencyCode
                  }
                }
                }
              }
            }
          }
    '''),
        variables: {
          'collectionId': 'gid://shopify/Collection/$pid',
          'limit': 100
        },
      ));

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final List<ProductCollectionModel> products =
          (result.data?['collection']['products']['nodes'] as List)
              .map((edge) => ProductCollectionModel.fromJson(edge))
              .toList();
      return products;
    }
  });

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    final productsFuture = ref.watch(productsProvider(widget.categoryName));
    final productByCollection =
        ref.watch(collectionWiseProvider(widget.category));

    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
          appBar: AppBar(
            elevation: 2,
            actions: [
              // IconButton(
              //     onPressed: () {
              //       showModalBottomSheet(
              //           shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.vertical(
              //             top: Radius.circular(25.0),
              //           )),
              //           context: context,
              //           builder: (BuildContext context) {
              //             return StatefulBuilder(
              //               builder:
              //                   (BuildContext context, StateSetter setState) {
              //                 return Container(
              //                     decoration: const BoxDecoration(
              //                       borderRadius: BorderRadius.only(
              //                         topLeft: Radius.circular(20.0),
              //                         topRight: Radius.circular(20.0),
              //                       ),
              //                     ),
              //                     child: Padding(
              //                         padding: const EdgeInsets.all(15.0),
              //                         child: SingleChildScrollView(
              //                           child: Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Padding(
              //                                   padding: const EdgeInsets.only(
              //                                       top: 5,
              //                                       left: 15,
              //                                       right: 15),
              //                                   child: Text(
              //                                     AppLocalizations.of(context)!
              //                                         .selectPrice,
              //                                     style: TextStyle(
              //                                       fontSize: 0.04 *
              //                                           MediaQuery.of(context)
              //                                               .size
              //                                               .width,
              //                                     ),
              //                                   )),
              //                               const SizedBox(
              //                                 height: 15,
              //                               ),
              //                               Padding(
              //                                   padding: const EdgeInsets.only(
              //                                       top: 0,
              //                                       left: 15,
              //                                       right: 15),
              //                                   child: Text(
              //                                     "\u{20B9}${start.toStringAsFixed(0)} - \u{20B9}${end.toStringAsFixed(0)}${end >= 900 ? plus : ""}",
              //                                     style: TextStyle(
              //                                       fontSize: 0.04 *
              //                                           MediaQuery.of(context)
              //                                               .size
              //                                               .width,
              //                                       fontWeight: FontWeight.w700,
              //                                     ),
              //                                   )),
              //                               StatefulBuilder(
              //                                   builder: (context, state) {
              //                                 return RangeSlider(
              //                                   values: RangeValues(start, end),
              //                                   labels: RangeLabels(
              //                                     start.toString(),
              //                                     end.toString(),
              //                                   ),
              //                                   activeColor:
              //                                       appInfo.primaryColorValue,
              //                                   onChanged: (value) {
              //                                     setState(() {
              //                                       state(() {
              //                                         start = value.start;
              //                                         end = value.end;
              //                                       });
              //                                     });
              //                                   },
              //                                   min: 0.0,
              //                                   max: 900.0,
              //                                 );
              //                               }),
              //                               Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment.center,
              //                                 children: [
              //                                   ElevatedButton(
              //                                     onPressed: () {
              //                                       setState(() {
              //                                         isFilter = false;
              //                                         isFilters = false;
              //                                       });
              //                                       ref.refresh(
              //                                           productsProvider(widget
              //                                               .categoryName));
              //                                       Navigator.pop(
              //                                           context); // Close the bottom sheet
              //                                     },
              //                                     style:
              //                                         ElevatedButton.styleFrom(
              //                                       backgroundColor:
              //                                           AppColors.whiteColor,
              //                                       // Button color
              //                                       side: BorderSide(
              //                                           color: appInfo
              //                                               .primaryColorValue),
              //                                       // Border color
              //                                       shape:
              //                                           RoundedRectangleBorder(
              //                                         borderRadius: BorderRadius
              //                                             .circular(AppDimension
              //                                                 .buttonRadius),
              //                                       ),
              //                                       textStyle: const TextStyle(
              //                                         color:
              //                                             AppColors.blackColor,
              //                                         fontSize: 10,
              //                                         fontStyle:
              //                                             FontStyle.normal,
              //                                       ),
              //                                     ),
              //                                     child: Text(
              //                                         AppLocalizations.of(
              //                                                 context)!
              //                                             .clear,
              //                                         style: TextStyle(
              //                                             color: AppColors
              //                                                 .blackColor,
              //                                             fontSize: MediaQuery.of(
              //                                                         context)
              //                                                     .size
              //                                                     .width *
              //                                                 0.04,
              //                                             fontWeight:
              //                                                 FontWeight.bold)),
              //                                   ),
              //                                   const SizedBox(
              //                                     width: 15,
              //                                   ),
              //                                   ElevatedButton(
              //                                     onPressed: () {
              //                                       setState(() {
              //                                         isFilter = true;
              //                                         isFilters = true;
              //                                       });
              //                                       ref.refresh(
              //                                           productsProvider(widget
              //                                               .categoryName));
              //                                       Navigator.pop(
              //                                           context); // Close the bottom sheet
              //                                     },
              //                                     style:
              //                                         ElevatedButton.styleFrom(
              //                                       backgroundColor:
              //                                           AppColors.whiteColor,
              //                                       // Button color
              //                                       side: BorderSide(
              //                                           color: appInfo
              //                                               .primaryColorValue),
              //                                       // Border color
              //                                       shape:
              //                                           RoundedRectangleBorder(
              //                                         borderRadius: BorderRadius
              //                                             .circular(AppDimension
              //                                                 .buttonRadius),
              //                                       ),
              //                                       textStyle: const TextStyle(
              //                                         color:
              //                                             AppColors.blackColor,
              //                                         fontSize: 10,
              //                                         fontStyle:
              //                                             FontStyle.normal,
              //                                       ),
              //                                     ),
              //                                     child: Text(
              //                                         AppLocalizations.of(
              //                                                 context)!
              //                                             .applyFilter,
              //                                         style: TextStyle(
              //                                             color: AppColors
              //                                                 .blackColor,
              //                                             fontSize: MediaQuery.of(
              //                                                         context)
              //                                                     .size
              //                                                     .width *
              //                                                 0.04,
              //                                             fontWeight:
              //                                                 FontWeight.bold)),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ],
              //                           ),
              //                         )));
              //               },
              //             );
              //           });
              //     },
              //     icon: const Icon(Icons.filter_alt)),
              // // IconButton(
              // //     onPressed: () {
              // //       _showSortingOptions(context);
              // //     },
              // //     icon: const Icon(Icons.sort))
            ],
            title: Text(
              widget.categoryName,
            ),
          ),
          bottomNavigationBar: MobjBottombar(
            bgcolor: AppColors.whiteColor,
            selcted_icon_color: AppColors.buttonColor,
            unselcted_icon_color: AppColors.blackColor,
            selectedPage: 2,
            screen1:  SearchWidget(),
            screen2:  SearchWidget(),
            screen3:  SearchWidget(),
            screen4: const ProfileScreen(),
            ref: ref,
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                isFilters == true
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 15, right: 15),
                        child: Row(
                          children: [
                            FilterChip(
                              label: Text(
                                AppLocalizations.of(context)!.price,
                                style: const TextStyle(
                                    color: AppColors.whiteColor),
                              ),
                              backgroundColor: AppColors.blue,
                              onSelected: (selected) {},
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // FilterChip(
                            //   label: const Text(AppString.sortBy),
                            //   onSelected: (selected) {},
                            // ),
                          ],
                        ))
                    : Container(),
                isFilter == true
                    ? Expanded(
                        child: productsFuture.when(
                        data: (products) {
                          return products.isNotEmpty
                              ? ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    log("image url is this ${product.featuredImage}");
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 15, right: 15),
                                        child: InkWell(
                                            onTap: () {
                                              ref.refresh(
                                                  productDetailsProvider(
                                                product.id.toString(),
                                              ));
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation1,
                                                          animation2) =>
                                                      ProductDetailsScreen(
                                                    uid: product.id
                                                        .replaceAll(
                                                            "gid://shopify/Product/",
                                                            "")
                                                        .toString(),
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
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                // Add padding to the Card
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  // Remove default ListTile padding
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    // Add padding to the title
                                                    child: Text(product.title),
                                                  ),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    // Add padding to the leading widget
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          product.featuredImage,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 50,
                                                        width: 50,
                                                        color:
                                                            AppColors.greyShade,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                      '\u{20B9}${product.minPrice} - \u{20B9} ${product.maxPrice} ${product.currencyCode}'),
                                                ),
                                              ),
                                            )));
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                        child: ErrorHandling(
                                      error_type: AppString.noDataError,
                                    )),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .emptyProduct,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            fontWeight: FontWeight.bold))
                                  ],
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
                                ref.refresh(productDataProvider("1"));
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
                      ))
                    : Expanded(
                        child: productByCollection.when(
                        data: (products) {
                          return RefreshIndicator(
                              // Wrap the list in a RefreshIndicator widget
                              onRefresh: () async {
                                ref.refresh(productDataProvider("1"));
                              },
                              child: products.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        final product = products[index];
                                        log("image url is this ${product.featuredImage}");
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 15, right: 15),
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          ProductDetailsScreen(
                                                        uid: product.id
                                                            .replaceAll(
                                                                "gid://shopify/Product/",
                                                                "")
                                                            .toString(),
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
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    // Add padding to the Card
                                                    child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      // Remove default ListTile padding
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8),
                                                        // Add padding to the title
                                                        child:
                                                            Text(product.title),
                                                      ),
                                                      leading: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 8),
                                                        // Add padding to the leading widget
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: product
                                                                  .imageUrls
                                                                  .isNotEmpty
                                                              ? product
                                                                  .imageUrls[0]
                                                                  .toString()
                                                              : "" ?? "",
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            height: 50,
                                                            width: 50,
                                                            color: AppColors
                                                                .greyShade,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      trailing: Text(
                                                          '\u{20B9}${product.minPrice} - \u{20B9} ${product.maxPrice} '),
                                                    ),
                                                  ),
                                                )));
                                      },
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Center(
                                          child: ErrorHandling(
                                            error_type: AppString.noDataError,
                                          ),
                                        ),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .emptyProduct,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ));
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
                                ref.refresh(productDataProvider("1"));
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
          error == AppString.noDataError
              ? Text(AppLocalizations.of(context)!.emptyProduct,
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
                    ref.refresh(productDataProvider("1"));
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

  Widget buildBottomSheetContent(BuildContext context, Color color) {
    return Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Text(
                        AppLocalizations.of(context)!.selectPrice,
                        style: TextStyle(
                          fontSize: 0.04 * MediaQuery.of(context).size.width,
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 15, right: 15),
                      child: Text(
                        "\u{20B9}${start.toStringAsFixed(0)} - \u{20B9}${end.toStringAsFixed(0)}${end >= 900 ? plus : ""}",
                        style: TextStyle(
                          fontSize: 0.04 * MediaQuery.of(context).size.width,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  StatefulBuilder(builder: (context, state) {
                    return RangeSlider(
                      values: RangeValues(start, end),
                      labels: RangeLabels(
                        start.toString(),
                        end.toString(),
                      ),
                      activeColor: color,
                      onChanged: (value) {
                        setState(() {
                          state(() {
                            start = value.start;
                            end = value.end;
                          });
                        });
                      },
                      min: 0.0,
                      max: 900.0,
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFilter = false;
                            isFilters = false;
                          });
                          ref.refresh(productsProvider(widget.categoryName));
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteColor, // Button color
                          side: BorderSide(color: color), // Border color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimension.buttonRadius),
                          ),
                          textStyle: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.clear,
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFilter = true;
                            isFilters = true;
                          });
                          ref.refresh(productsProvider(widget.categoryName));
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whiteColor, // Button color
                          side: BorderSide(color: color), // Border color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimension.buttonRadius),
                          ),
                          textStyle: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.applyFilter,
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.lowToHigh),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(AppString.highToLow),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.lowToHigh),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
