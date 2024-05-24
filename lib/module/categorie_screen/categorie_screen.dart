import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobj_project/mappers/bigcommerce_models/bicommerce_wishlistModel.dart';

import '../../utils/api.dart';
import '../../utils/cmsConfigue.dart';
import '../home/collectionWiseProductScreen.dart';
import '../wishlist/wishlishScreen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  List<dynamic> data = [];
  final uid = SharedPreferenceManager().getUserId();
  Future<void> fetchCategories() async {
    API api = API();
    if (AppConfigure.megentoCommerce) {
      log('Megnto API for categories');
      try {
        final response = await api.sendRequest.get(
          "${AppConfigure.megentoCommerceUrl}categories",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer 7iqu2oq5y7oruxwdf9fzksf7ak16cfri',
          }),
        );
        if (response.statusCode == APIConstants.successCode) {
          final apiData = response.data;
          List<dynamic> categories = _parseCategories(apiData['children_data']);
          setState(() {
            data = categories;
          });
        } else {
          throw Exception('Failed to fetch categories');
        }
      } catch (e, stackTrace) {
        debugPrint("error is this $e $stackTrace");
      }
    } else if (AppConfigure.wooCommerce) {
      log('Woo Commerce categories');
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

  List<dynamic> _parseCategories(List<dynamic> categories) {
    List<dynamic> parsedCategories = [];
    for (var category in categories) {
      parsedCategories.add(category);
      if (category['children_data'] != null &&
          category['children_data'].isNotEmpty) {
        parsedCategories.addAll(_parseCategories(category['children_data']));
      }
    }
    return parsedCategories;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          AppLocalizations.of(context)!.categories,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: data.isEmpty
            ? SizedBox(
                height: 600.h,
                child: const Center(child: CircularProgressIndicator()),
              )
            : GridView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              CollectionWiseProductScreen(
                            category: AppConfigure.bigCommerce
                                ? data[index]['category_id'].toString()
                                : AppConfigure.megentoCommerce
                                    ? data[index]['id'].toString()
                                    : AppConfigure.wooCommerce
                                        ? data[index]['id'].toString()
                                        : data[index]['id'].toString(),
                            categoryName: AppConfigure.bigCommerce
                                ? data[index]['name'].toString()
                                : AppConfigure.wooCommerce
                                    ? data[index]['name'].toString()
                                    : AppConfigure.megentoCommerce
                                        ? data[index]['name'].toString()
                                        : data[index]['title'].toString(),
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.greyShade,
                        boxShadow: const [
                          BoxShadow(
                            color: ConstColors.shadowColor,
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: AppConfigure.wooCommerce
                              ? (data[index]["image"] == null
                                  ? const NetworkImage(
                                      "https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg")
                                  : NetworkImage(data[index]["image"]["src"]))
                              : AppConfigure.megentoCommerce
                                  ? (data[index]["image_url"] == null ||
                                          data[index]["image_url"].isEmpty
                                      ? const NetworkImage(
                                          "https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg")
                                      : NetworkImage(data[index]["image_url"]))
                                  : (data[index]["image_url"] == null ||
                                          data[index]["image_url"].isEmpty
                                      ? const NetworkImage(
                                          "https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg")
                                      : NetworkImage(data[index]["image_url"])),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SizedBox(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    AppConfigure.bigCommerce
                                        ? data[index]['name'].toString()
                                        : AppConfigure.wooCommerce
                                            ? data[index]['name'].toString()
                                            : AppConfigure.megentoCommerce
                                                ? data[index]['name'].toString()
                                                : data[index]['title']
                                                    .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                padding: EdgeInsets.all(8.w),
                shrinkWrap: true,
              ),
      ),
      bottomNavigationBar: MobjBottombar(
        bgcolor: AppColors.whiteColor,
        selcted_icon_color: AppColors.buttonColor,
        unselcted_icon_color: AppColors.blackColor,
        selectedPage: 2,
        screen1: const HomeScreen(),
        screen2: SearchWidget(),
        screen3: WishlistScreen(),
        screen4: const ProfileScreen(),
        ref: ref,
      ),
    );
  }
}
