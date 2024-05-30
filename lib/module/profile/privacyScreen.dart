import 'package:amazon_like_filter/props/applied_filter_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../wishlist/wishlishScreen.dart';
//

import 'dart:convert';

class PrivacyScreen extends ConsumerStatefulWidget {
  final bool? logout;

  const PrivacyScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    fetchTermsAndConditions();
  }

  Future<Map<String, String>> fetchTermsAndConditions() async {
    String BaseUrl = AppConfigure.adminPanelUrl;
    final response = await http
        .get(Uri.parse("$BaseUrl/api/terms-and-condition?populate=*"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String terms = data['data']['attributes']['terms_and_condition'];
      String imageUrl =
          data['data']['attributes']['image']['data']['attributes']['url'];
      return {'terms': terms, 'image': imageUrl};
    } else {
      throw Exception('Failed to load terms and conditions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(productDataProvider('1'));
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    List<AppliedFilterModel> applied = [];

    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                surfaceTintColor: Theme.of(context).colorScheme.secondary,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      size: 25.sp,
                    )),
                title: Text(
                  AppLocalizations.of(context)!.privacyPolicy,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              bottomNavigationBar: MobjBottombar(
                bgcolor: Colors.white,
                selcted_icon_color: AppColors.buttonColor,
                unselcted_icon_color: AppColors.blackColor,
                selectedPage: 4,
                screen1: const HomeScreen(),
                screen2: SearchWidget(),
                screen3: WishlistScreen(),
                screen4: const ProfileScreen(),
                ref: ref,
              ),
              body: user.when(
                  data: (user) {
                    return SingleChildScrollView(
                        child: Center(
                            child: ref.watch(productDataProvider('1')).when(
                                  data: (profile) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //
                                          FutureBuilder<Map<String, String>>(
                                            future: fetchTermsAndConditions(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const SkeletonLoaderWidget();
                                              } else if (snapshot.hasError) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Center(
                                                      child: ErrorHandling(
                                                        error_type:
                                                            AppString.error,
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors
                                                                .buttonColor,
                                                      ),
                                                      onPressed: () {
                                                        ref.refresh(
                                                            userDataProvider);
                                                      },
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .refresh,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data!['image']!,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        width: 28,
                                                        height: 28,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        width: 28,
                                                        height: 28,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      snapshot.data!['terms']!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  loading: () => const SkeletonLoaderWidget(),
                                  error: (error, stackTrace) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4.2,
                                      ),
                                      const Center(
                                        child: ErrorHandling(
                                          error_type: AppString.error,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Center(
                                            child: ErrorHandling(
                                                error_type: AppString.error),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.buttonColor,
                                            ),
                                            onPressed: () {
                                              ref.refresh(userDataProvider);
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .refresh,
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
                                )));
                  },
                  error: (error, s) =>
                      const ErrorHandling(error_type: AppString.error),
                  loading: () => const SkeletonLoaderWidget()),
            ),
        error: (error, s) => const SizedBox(),
        loading: () => const SizedBox());
  }
}
