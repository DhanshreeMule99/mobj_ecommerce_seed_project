// profileScreen
import 'dart:io';

import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:mobj_project/utils/defaultValues.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../address/addressListScreen.dart';
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
              elevation: 2,
              actions: [
                IconButton(
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      LanguageProvider languageProvider = LanguageProvider(prefs);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                               SettingScreen(languageProvider: languageProvider,),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings))
              ],
              title:  Text(
                AppLocalizations.of(context)!.profile,
              ),
            ),
            bottomNavigationBar: MobjBottombar(
              bgcolor: AppColors.whiteColor,
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
                                      // const Padding(
                                      //     padding: EdgeInsets.only(
                                      //         top: 0,
                                      //         left: 10,
                                      //         right: 10,
                                      //         bottom: 0),
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.center,
                                      //       children: [
                                      //         //TODO list display profile pic from cache
                                      //         // CircleAvatar(
                                      //         //     radius: 75,
                                      //         //     backgroundColor:
                                      //         //         app_colors
                                      //         //             .button_color,
                                      //         //     child: CachedNetworkImage(
                                      //         //       imageUrl:
                                      //         //           user.profilePhoto,
                                      //         //       imageBuilder: (context,
                                      //         //               imageProvider) =>
                                      //         //           Container(
                                      //         //         width: 100,
                                      //         //         height: 100,
                                      //         //         decoration:
                                      //         //             BoxDecoration(
                                      //         //           image:
                                      //         //               DecorationImage(
                                      //         //             //image size fill
                                      //         //             image:
                                      //         //                 imageProvider,
                                      //         //             fit: BoxFit.fill,
                                      //         //           ),
                                      //         //         ),
                                      //         //       ),
                                      //         //       placeholder:
                                      //         //           (context, url) =>
                                      //         //               Container(
                                      //         //         width: 100,
                                      //         //         height: 100,
                                      //         //         // color: Appcolors.grey_shade,
                                      //         //         child: const Icon(
                                      //         //           Icons.person,
                                      //         //           size: 35,
                                      //         //         ),
                                      //         //       ),
                                      //         //       errorWidget: (context,
                                      //         //               url, error) =>
                                      //         //           Container(
                                      //         //         width: 45,
                                      //         //         height: 45,
                                      //         //         // color: Appcolors.grey_shade,
                                      //         //         child: const Icon(
                                      //         //             Icons.person,
                                      //         //             size: 35),
                                      //         //       ),
                                      //         //     )
                                      //         //     // Mobj_text(
                                      //         //     //   string: user.firstName[0].toUpperCase() +
                                      //         //     //       user.lastName[0].toUpperCase(),
                                      //         //     //   color: app_colors.white_color,
                                      //         //     //   fontweight: FontWeight.bold,
                                      //         //     //   fontsize:
                                      //         //     //   MediaQuery.of(context).size.width * 0.06,
                                      //         //     // ),
                                      //         //     ),
                                      //         CircleAvatar(
                                      //           radius: 50,
                                      //           backgroundImage: NetworkImage(
                                      //               'https://cdn.shopify.com/s/files/1/0625/7685/3156/products/2015-03-20_Ashley_Look_20_23515_15567.jpg?v=1697805909'), // Replace with the user's actual avatar URL
                                      //         ),
                                      //       ],
                                      //     )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              left: 0,
                                              right: 10,
                                              bottom: 0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${user.firstName} ${user.lastName}",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditProfileScreen()));
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
                                            const Icon(
                                              Icons.email,
                                              size: 16,
                                              color: AppColors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(user.email),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 0, right: 10),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              size: 16,
                                              color: AppColors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(user.phone),
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
                                        OrderListScreen(),
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
                                        AddressListScreen(),
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
                            primary: AppColors.buttonColor,
                          ),
                          onPressed: () {
                            ref.refresh(profileDataProvider);
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
                loading: () => SkeletonLoaderWidget())),
        error: (error, s) => const SizedBox(),
        loading: () => const SizedBox());
  }
}

class ProfileOptionButton extends StatelessWidget {
  final String title;
  final Function onTap;

  ProfileOptionButton({super.key, required this.title, required this.onTap});

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
