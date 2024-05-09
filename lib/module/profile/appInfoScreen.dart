// appInfoScreen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../wishlist/wishlishScreen.dart';

class AppInfoScreen extends ConsumerStatefulWidget {
  final bool? logout;

  const AppInfoScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends ConsumerState<AppInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "",
          ),
        ),
        bottomNavigationBar: MobjBottombar(
          bgcolor: AppColors.whiteColor,
          selcted_icon_color: AppColors.buttonColor,
          unselcted_icon_color: AppColors.blackColor,
          selectedPage: 1,
          screen1: const HomeScreen(),
          screen2: const SearchWidget(),
          screen3:  WishlistScreen(),
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
                          child: ClipRRect(
                              child: CachedNetworkImage(
                            imageUrl: appInfo.logoImagePath,
                            imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              width: 28,
                              height: 28,
                              color: AppColors.greyShade800,
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 28,
                              height: 28,
                              color: AppColors.greyShade800,
                            ),
                          )),
                        ),
                        // const SizedBox(height: 20),
                        // Text(
                        //   appInfo.appName,
                        //   style: const TextStyle(
                        //     fontSize: 24,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        Text(
                          appInfo.aboutApp,
                          style: const TextStyle(
                            fontSize: 16,
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
                          child:  Text(
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
        )),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('${AppString.error}: $error'),
    );
  }
}
