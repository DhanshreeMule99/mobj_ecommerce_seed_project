// profileScreen

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../services/shopifyServices/graphQLServices/graphQlRespository.dart';
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

  GraphQlRepository graphQLConfig = GraphQlRepository();
  @override
  void initState() {
    // TODO: implement initState
    getProfilePic();
    super.initState();
  }

  logout() async {
    cartcount = 0;
    if (AppConfigure.bigCommerce) {
      // Logout with BigCommerce

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pop();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteConstants.login,
        (route) => false,
      );

      // try {
      //   final response = await http.post(
      //     Uri.parse('${AppConfigure.bigcommerceUrl}/customers/logout'),
      //     headers: <String, String>{
      //       "Content-Type": "application/json",
      //       "X-Auth-Token": AppConfigure.bigCommerceAccessToken,
      //     },
      //   );

      //   if (response.statusCode == 204) {
      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     prefs.clear();
      //     Navigator.of(context).pop();
      //     navigatorKey.currentState!.pushNamedAndRemoveUntil(
      //       RouteConstants.login,
      //       (route) => false,
      //     );
      //   } else {
      //     Fluttertoast.showToast(
      //       msg: 'Logout failed. Please try again. 1234',
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 0,
      //       backgroundColor: AppColors.blackColor,
      //       textColor: AppColors.whiteColor,
      //       fontSize: 16.0,
      //     );
      //   }
      // } catch (e) {
      //   Fluttertoast.showToast(
      //     msg: 'Logout failed. Please try again.',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 0,
      //     backgroundColor: AppColors.blackColor,
      //     textColor: AppColors.whiteColor,
      //     fontSize: 16.0,
      //   );
      // }
    } else if (AppConfigure.wooCommerce) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pop();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteConstants.login,
        (route) => false,
      );
    } else if (AppConfigure.megentoCommerce) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pop();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteConstants.login,
        (route) => false,
      );
    } else {
      // Logout with Shopify (existing code)
      GraphQLClient client = graphQLConfig.clientToQuery();
      final token = await SharedPreferenceManager().getToken();

      try {
        final MutationOptions options = MutationOptions(
          document: gql('''
            mutation DeleteAccessToken(\$customerAccessToken: String!) {
              customerAccessTokenDelete(customerAccessToken: \$customerAccessToken) {
                deletedAccessToken
              }
            }
          '''),
          variables: {
            "customerAccessToken": token,
          },
        );

        final QueryResult result = await client.mutate(options);

        if (result.hasException) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.oops,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 0,
            backgroundColor: AppColors.blackColor,
            textColor: AppColors.whiteColor,
            fontSize: 16.0,
          );
          print(
            'Failed to delete access token. Exception: ${result.exception.toString()}',
          );
        } else {
          final deletedAccessToken =
              result.data?['customerAccessTokenDelete']['deletedAccessToken'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.of(context).pop();
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RouteConstants.login,
            (route) => false,
          );
        }
      } catch (errors) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.oops,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 0,
          backgroundColor: AppColors.blackColor,
          textColor: AppColors.whiteColor,
          fontSize: 16.0,
        );
        Navigator.of(context).pop();
      }
    }

    // GraphQLClient client = graphQLConfig.clientToQuery();
    // final token = await SharedPreferenceManager().getToken();

    // try {
    //   final MutationOptions options = MutationOptions(
    //     document: gql('''
    //     mutation DeleteAccessToken(\$customerAccessToken: String!) {
    //       customerAccessTokenDelete(customerAccessToken: \$customerAccessToken) {
    //         deletedAccessToken
    //       }
    //     }
    //   '''),
    //     variables: {
    //       "customerAccessToken": token,
    //     },
    //   );

    //   final QueryResult result = await client.mutate(options);

    //   if (result.hasException) {
    //     Navigator.of(context).pop();
    //     Fluttertoast.showToast(
    //         msg: AppLocalizations.of(context)!.oops,
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 0,
    //         backgroundColor: AppColors.blackColor,
    //         textColor: AppColors.whiteColor,
    //         fontSize: 16.0);
    //     print(
    //         'Failed to delete access token. Exception: ${result.exception.toString()}');
    //   } else {
    //     final deletedAccessToken =
    //         result.data?['customerAccessTokenDelete']['deletedAccessToken'];
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.clear();
    //     Navigator.of(context).pop();
    //     navigatorKey.currentState!.pushNamedAndRemoveUntil(
    //       RouteConstants.login,
    //       (route) => false,
    //     );
    //   }
    // } catch (errors) {
    //   Fluttertoast.showToast(
    //       msg: AppLocalizations.of(context)!.oops,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 0,
    //       backgroundColor: AppColors.blackColor,
    //       textColor: AppColors.whiteColor,
    //       fontSize: 16.0);
    //   Navigator.of(context).pop();
    // }

    // final login = LoginRepository();
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
              // actions: [
              //   IconButton(
              //       onPressed: () async {
              //         SharedPreferences prefs =
              //             await SharedPreferences.getInstance();
              //         LanguageProvider languageProvider =
              //             LanguageProvider(prefs);
              //         Navigator.of(context).push(
              //           PageRouteBuilder(
              //             pageBuilder: (context, animation1, animation2) =>
              //                 SettingScreen(
              //               languageProvider: languageProvider,
              //             ),
              //             transitionDuration: Duration.zero,
              //             reverseTransitionDuration: Duration.zero,
              //           ),
              //         );
              //       },
              //       icon: const Icon(Icons.settings))
              // ],
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
              screen2: SearchWidget(),
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
                        //  Padding(
                        //    padding: const EdgeInsets.all(8.0),
                        //    child: CircleAvatar(
                        //           radius: 40,
                        //           backgroundColor: Theme.of(context).colorScheme.onPrimary,// Placeholder color
                        //           child: Text(
                        //             '${user.firstName[0]}',
                        //             style: TextStyle(
                        //               fontSize: 25,
                        //               fontWeight: FontWeight.w400,
                        //               color: Theme.of(context).colorScheme.primary,
                        //             ),
                        //           ),
                        //         ),
                        //  ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 15),
                            child: Card(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              const SizedBox(width: 5),
                                              SizedBox(
                                                width: 100.w,
                                                child: Text(
                                                  "${user.firstName} ${user.lastName}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const EditProfileScreen()));
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                          icon: Icons.shopping_bag,
                          iconColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
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
                          icon: Icons.location_on_outlined,
                          iconColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
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
                        ProfileOptionButton(
                          icon: Icons.settings,
                          iconColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          title: AppLocalizations.of(context)!.setting,
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            LanguageProvider languageProvider =
                                LanguageProvider(prefs);
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        SettingScreen(
                                  languageProvider: languageProvider,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        ),
                        ProfileOptionButton(
                          icon: Icons.logout_outlined,
                          iconColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          title: AppLocalizations.of(context)!.logout,
                          onTap: () async {
                            bool? logoutConfirmed =
                                await showLogoutConfirmationDialog(context);
                            if (logoutConfirmed!) {
                              CommonAlert.show_loading_alert(context);
                              logout();
                            }
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

  Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logoutConfirmation),
          content: Text(AppLocalizations.of(context)!.areYouSurelogout),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog and return false
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and return true
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfileOptionButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const ProfileOptionButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.iconColor,
      required this.backgroundColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          size: 20,
          icon,
          color: iconColor,
        ),
      ),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
