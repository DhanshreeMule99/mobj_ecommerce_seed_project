// profileScreen

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../address/addressListScreen.dart';
import '../wishlist/wishlishScreen.dart';
import 'myOrder/orderListScreen.dart';

class ProfileState extends StateNotifier<bool> {
  ProfileState() : super(false);

  void toggleBioExpansion() {
    state = !state;
  }
}

final profileStateProvider =
    StateNotifierProvider<ProfileState, bool>((ref) => ProfileState());

class ProfileScreen extends ConsumerStatefulWidget {
  final bool? logout;

  const ProfileScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  getProfilePic() async {
    profilePic = await SharedPreferenceManager().getProfile();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfilePic();
    super.initState();
  }

  String? profilePic;

  int countLines(String text, TextStyle style, double maxWidth) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }

  @override
  Widget build(BuildContext context) {
    //TODO list API integration
    final user = ref.watch(profileDataProvider);

    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              surfaceTintColor: Theme.of(context).colorScheme.secondary,
              actions: [
                IconButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      LanguageProvider languageProvider =
                          LanguageProvider(prefs);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              SettingScreen(
                            languageProvider: languageProvider,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings))
              ],
              title: Text(
                AppLocalizations.of(context)!.profile,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            bottomNavigationBar: MobjBottombar(
              bgcolor: AppColors.whiteColor,
              selcted_icon_color: AppColors.buttonColor,
              unselcted_icon_color: AppColors.blackColor,
              selectedPage: 4,
              screen1: const HomeScreen(),
              screen2: const SearchWidget(),
              screen3: WishlistScreen(),
              screen4: const ProfileScreen(),
              ref: ref,
            ),
            body: user.when(
                data: (user) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 15),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 15),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              left: 0,
                                              right: 10,
                                              bottom: 0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 16.sp,
                                                color: AppColors.grey,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "${user.firstName} ${user.lastName}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                              ),
                                              const SizedBox(width: 5),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const EditProfileScreen()));
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: AppColors.blue,
                                                  ))
                                            ],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: 0, right: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              size: 16.sp,
                                              color: AppColors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              user.email,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 0, right: 10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 16.sp,
                                              color: AppColors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              user.phone,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            )),
                        ProfileOptionButton(
                          title: AppLocalizations.of(context)!.myOrders,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const OrderListScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        ),
                        ProfileOptionButton(
                          title: AppLocalizations.of(context)!.myAddressList,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        AddressListScreen(
                                  bigcommerceOrderedItems:
                                      bigcommerceOrderedItems,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        ),
                        //ToDO list wishList and paymentOption
                        // ProfileOptionButton(
                        //   title: AppString.myWishList,
                        //   onTap: () {},
                        // ),
                        // ProfileOptionButton(
                        //   title: AppString.paymentOption,
                        //   onTap: () {},
                        // ),
                      ]);
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
                            ref.refresh(profileDataProvider);
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
}

class ProfileOptionButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const ProfileOptionButton(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        onTap();
      },
    );
  }
}
