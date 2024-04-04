// privacyScreen
import 'package:amazon_like_filter/props/applied_filter_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  final bool? logout;

  PrivacyScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(productDataProvider);
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    List<AppliedFilterModel> applied = [];

    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  title:   Text(
                      AppLocalizations.of(context)!.privacyPolicy
                    ),
                    ),
              bottomNavigationBar: MobjBottombar(
                bgcolor: Colors.white,
                selcted_icon_color: AppColors.buttonColor,
                unselcted_icon_color: AppColors.blackColor,
                selectedPage: 3,
                screen1: const HomeScreen(),
                screen2: const SearchWidget(),
                screen3: const HomeScreen(),
                screen4: const ProfileScreen(),
                ref: ref,
              ),
              body: user.when(
                  data: (user) {
                    return SingleChildScrollView(
                        child: Center(
                      child: ref.watch(productDataProvider).when(
                            data: (profile) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: ClipRRect(
                                          child: CachedNetworkImage(
                                        imageUrl: appInfo.logoImagePath,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
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
                                          width: 28,
                                          height: 28,
                                          color: Colors.grey.shade800,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          width: 28,
                                          height: 28,
                                          color: Colors.grey.shade800,
                                        ),
                                      )),
                                    ),
                                    const SizedBox(height: 20),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Setoo recognises the importance of maintaining your privacy. We value your privacy and appreciate your trust in us. This Privacy Policy sets out how Setoo uses and protects any information that you give Setoo when you use this www.setoo.co or the Setoo mobile application or any other digital medium and other offline sources of our Company. Setoo is committed to ensure that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using this website, then you can be assured that it will only be used in accordance with this Privacy Policy as it describes how we treat user information we collect from you, the policies and procedures on the collection, use, disclosure and protection of your information when you use our Setoo Platform.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        // color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loading: () => SkeletonLoaderWidget(),
                            error: (error, stackTrace) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 4.2,
                                ),
                                const Center(
                                  child: ErrorHandling(
                                    error_type: AppString.error,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: ErrorHandling(
                                          error_type: AppString.error),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.buttonColor,
                                      ),
                                      onPressed: () {
                                        ref.refresh(userDataProvider);
                                      },
                                      child:  Text(
                                        AppLocalizations.of(context)!.refresh,
                                        style: TextStyle(
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
                    ));
                  },
                  error: (error, s) =>
                      const ErrorHandling(error_type: AppString.error),
                  loading: () => SkeletonLoaderWidget()),
            ),
        error: (error, s) => const SizedBox(),
        loading: () => const SizedBox());
  }
}
