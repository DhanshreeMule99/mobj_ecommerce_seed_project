import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobj_project/mappers/bigcommerce_models/bicommerce_wishlistModel.dart';

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
            "Categories",
            style: Theme.of(context).textTheme.headlineLarge,
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              data.length == 0
                  ? SizedBox(
                      height: 600.h,
                      child: Center(child: CircularProgressIndicator()))
                  : GridView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        CollectionWiseProductScreen(
                                  category: AppConfigure.bigCommerce
                                      ? data[index]['category_id'].toString()
                                      : data[index]['id'].toString(),
                                  categoryName: AppConfigure.bigCommerce
                                      ? data[index]['name'].toString()
                                      : (AppConfigure.wooCommerce
                                          ? data[index]['name'].toString()
                                          : data[index]['title'].toString()),
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
                                    offset: Offset(0, 2))
                              ],
                              image: DecorationImage(
                                  image: AppConfigure.wooCommerce
                                      ? (data[index]["image"] == null
                                          ? NetworkImage(
                                              "https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg")
                                          : NetworkImage(
                                              data[index]["image"]["src"]))
                                      : (data[index]["image_url"] == ""
                                          ? NetworkImage(
                                              "https://t4.ftcdn.net/jpg/03/85/95/63/360_F_385956366_Zih7xDcSLqDxiJRYUfG5ZHNoFCSLMRjm.jpg")
                                          : NetworkImage(
                                              data[index]["image_url"])),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust border radius as needed
                              // Add border
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        // Colors.black38,
                                        Colors.black54
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                        AppConfigure.bigCommerce
                                            ? data[index]['name'].toString()
                                            : (AppConfigure.wooCommerce
                                                ? data[index]['name'].toString()
                                                : data[index]['title']
                                                    .toString()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      padding: EdgeInsets.all(8.w),
                      shrinkWrap: true,
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MobjBottombar(
        bgcolor: AppColors.whiteColor,
        selcted_icon_color: AppColors.buttonColor,
        unselcted_icon_color: AppColors.blackColor,
        selectedPage: 2,
        screen1: const HomeScreen(),
        screen2: const SearchWidget(),
        screen3: WishlistScreen(),
        screen4: const ProfileScreen(),
        ref: ref,
      ),
    );
  }
}
