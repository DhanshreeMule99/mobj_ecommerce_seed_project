// privacyScreen
import 'package:amazon_like_filter/props/applied_filter_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:http/http.dart' as http;
import '../wishlist/wishlishScreen.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  final bool? logout;

  const PrivacyScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
 

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
                                    Text(
                                      "Setoo recognises the importance of maintaining your privacy. We value your privacy and appreciate your trust in us. This Privacy Policy sets out how Setoo uses and protects any information that you give Setoo when you use this www.setoo.co or the Setoo mobile application or any other digital medium and other offline sources of our Company. Setoo is committed to ensure that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using this website, then you can be assured that it will only be used in accordance with this Privacy Policy as it describes how we treat user information we collect from you, the policies and procedures on the collection, use, disclosure and protection of your information when you use our Setoo Platform.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
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
                    ));
                  },
                  error: (error, s) =>
                      const ErrorHandling(error_type: AppString.error),
                  loading: () => const SkeletonLoaderWidget()),
            ),
        error: (error, s) => const SizedBox(),
        loading: () => const SizedBox());
  }
}
