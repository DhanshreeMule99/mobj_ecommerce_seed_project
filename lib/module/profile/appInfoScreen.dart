import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobj_project/module/home/homeCarousel.dart';
import 'package:mobj_project/module/wishlist/wishlishScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../wishlist/wishlishScreen.dart';

class AppInfoScreen extends ConsumerStatefulWidget {
  final bool? logout;

  const AppInfoScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends ConsumerState<AppInfoScreen> {
  late Future<Map<String, dynamic>> aboutApp;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    aboutApp = fetchAboutApp();
  }

  Future<Map<String, dynamic>> fetchAboutApp() async {
    String BaseUrl = AppConfigure.adminPanelUrl;
    final response =
        await http.get(Uri.parse("$BaseUrl/api/about-uses?populate=*"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final aboutText = data['data'][0]['attributes']['about'];
      final images = data['data'][0]['attributes']['images']['data'];
      return {
        'about': aboutText,
        'images': images,
      };
    } else {
      throw Exception('Failed to load about app');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          surfaceTintColor: Theme.of(context).colorScheme.secondary,
          title: const Text("About Us"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 25.sp,
            ),
          ),
        ),
        bottomNavigationBar: MobjBottombar(
          bgcolor: AppColors.whiteColor,
          selcted_icon_color: AppColors.buttonColor,
          unselcted_icon_color: AppColors.blackColor,
          selectedPage: 4,
          screen1: const HomeScreen(),
          screen2: SearchWidget(),
          screen3: WishlistScreen(),
          screen4: const ProfileScreen(),
          ref: ref,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ref.watch(productDataProvider('1')).when(
                  data: (profile) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: aboutApp,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child:  CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  );
                                } else {
                                  final aboutText = snapshot.data!['about'];
                                  final images = snapshot.data!['images'] as List;
                            
                                  return Column(
                                    children: [
                                      Stack(
                                       children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                                viewportFraction: 1,
                                                autoPlay: true,
                                                enlargeCenterPage: true,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    activeIndex = index;
                                                  });
                                                },
                                              ),
                                        items: images.map((image) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return CachedNetworkImage(
                                                imageUrl: image['attributes']
                                                    ['url'],
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                        Positioned(
                                              bottom: 10,
                                              right: 150.w,
                                              child: AnimatedSmoothIndicator(
                                                activeIndex: activeIndex,
                                                count: imgList.length,
                                              ),
                                            ),
                                             ],
                                        ),
                                      const SizedBox(height: 20),
                                      Text(
                                        aboutText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SkeletonLoaderWidget(),
                  error: (error, stackTrace) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4.2,
                      ),
                      Column(
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
                              ref.refresh(userDataProvider);
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
                    ],
                  ),
                ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('${AppString.error}: $error'),
    );
  }
}
