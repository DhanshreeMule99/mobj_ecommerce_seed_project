// SettingScreen
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobj_project/module/profile/contactuescreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../services/shopifyServices/graphQLServices/graphQlRespository.dart';
import '../wishlist/wishlishScreen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  final LanguageProvider languageProvider;

  const SettingScreen({super.key, required this.languageProvider});

  @override
  ConsumerState<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends ConsumerState<SettingScreen> {
  GraphQlRepository graphQLConfig = GraphQlRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  logout() async {
    if (AppConfigure.bigCommerce) {
      // Logout with BigCommerce

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pop();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteConstants.login,
        (route) => false,
      );
    } else if (AppConfigure.wooCommerce) {
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
  }

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    final theme = ref.watch(themeProvider);
    final languageProviders = ref.watch(languageProvider.notifier);

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
                  AppLocalizations.of(context)!.setting,
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
              body: Column(
                children: [
                  MobjListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const AppInfoScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    title:
                        '${AppLocalizations.of(context)!.about} ${appInfo.appName}',
                    // leading: const Icon(Icons.info),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    icon: Icons.info,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  MobjListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const ContactUs(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    title:
                        '${AppLocalizations.of(context)!.contactUs}',
                    // leading: const Icon(Icons.info),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    icon: Icons.contact_phone,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  appInfo.tawkURL != "" || appInfo.tawkURL.isNotEmpty
                      ? MobjListTile(
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          // leading: const Icon(Icons.help),
                          icon: Icons.help,
                          iconColor: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          title: AppLocalizations.of(context)!.help,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const HelpCenterScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  MobjListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    // leading: const Icon(Icons.vpn_key),
                    icon: Icons.vpn_key,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    title: AppLocalizations.of(context)!.resetPass,
                    onTap: () async {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const ForgotPasswordScreen(
                            isResetPass: true,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  MobjListTile(
                    icon: Icons.lightbulb_outline,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    title: AppLocalizations.of(context)!.themeChange,
                    trailing: Switch(
                      trackOutlineColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary),
                      inactiveThumbColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor:
                          Theme.of(context).colorScheme.onPrimary,
                      activeTrackColor: Theme.of(context).colorScheme.onPrimary,
                      focusColor: Theme.of(context).colorScheme.onPrimary,
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: theme,
                      onChanged: (value) =>
                          ref.read(themeProvider.notifier).toggleTheme(),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        child: Icon(
                          Icons.language,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(AppLocalizations.of(context)!.changeLanguage),
                    onTap: () {
                      _showLanguageDialog(context, languageProviders);
                    },
                  ),
                  // MobjListTile(
                  //   leading: const Icon(Icons.notifications),
                  //   title: AppString.notification,
                  //   onTap: () async {
                  //     Navigator.of(context).push(
                  //       PageRouteBuilder(
                  //         pageBuilder: (context, animation1, animation2) =>
                  //             const NotificationSettingScreen(),
                  //         transitionDuration: Duration.zero,
                  //         reverseTransitionDuration: Duration.zero,
                  //       ),
                  //     );
                  //   },
                  // ),
                  MobjListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    icon: Icons.info,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    title: AppLocalizations.of(context)!.privacyPolicy,
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const PrivacyScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  MobjListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    icon: Icons.star,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    title: AppLocalizations.of(context)!.rateUs,
                    onTap: () async {
                      LaunchReview.launch(
                          androidAppId: "com.setoo.mobj",
                          iOSAppId: "com.example.mobjProject");
                    },
                  ),
                  // MobjListTile(
                  //   leading: const Icon(Icons.logout),
                  //   title: AppLocalizations.of(context)!.logout,
                  //   onTap: () async {
                  //     bool? logoutConfirmed =
                  //         await showLogoutConfirmationDialog(context);
                  //     if (logoutConfirmed!) {
                  //       CommonAlert.show_loading_alert(context);
                  //       logout();
                  //     }
                  //     // Remove loginId from shared preferences
                  //   },
                  // ),
                  ListTile(
                      // icon: Icons.person,
                      // iconColor:  Theme.of(context).colorScheme.primary,
                      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      leading: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      title: Text(AppLocalizations.of(context)!.accDeactivate),
                      onTap: () async {
                        bool? logoutConfirmed =
                            await showDeactivateAccountDialog(context);
                        if (logoutConfirmed.toString() == "true") {
                          // Perform Deactivate logic
                          final logout = logoutRepository();
                          logout.accountDeactivate().then((value) async {
                            if (value.toString() == "true") {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              navigatorKey.currentState!
                                  .pushNamedAndRemoveUntil(
                                RouteConstants.login,
                                (route) => false,
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)!.oops,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 0,
                                  backgroundColor: AppColors.blackColor,
                                  textColor: AppColors.whiteColor,
                                  fontSize: 16.0);
                            }
                          });
                        }
                      })
                ],
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const SizedBox());
  }

  Future<void> _showLanguageDialog(
      BuildContext context, LanguageProvider languageProvider) async {
    String selectedLanguage = languageProvider.state;

    List<String> languageOptions = ['English', 'Marathi', 'Hindi'];
    List<String> languageCodes = [
      'en',
      'mr',
      'hi'
    ]; // Add language codes accordingly

    int selectedIndex = languageOptions.indexOf(selectedLanguage);

    double calculateContentHeight() {
      // Calculate the total height based on the number of items and item height
      const itemHeight = 50.0; // Adjust this based on your ListTile height
      return languageOptions.length * itemHeight;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: SizedBox(
            height: calculateContentHeight(),
            width: 150,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageOptions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(languageOptions[index]),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      selectedLanguage = languageOptions[index];
                    });

                    String languageCode = languageCodes[index];
                    languageProvider.toggleLanguage(languageCode);
                    Navigator.of(context).pop();
                  },
                  tileColor: index == selectedIndex ? Colors.grey[200] : null,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }
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

Future<bool?> showDeactivateAccountDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.deactivateConf),
        content: Text(AppLocalizations.of(context)!.areYouSureDeactivate),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Close the dialog and return false
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.delete),
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

class MobjListTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Widget? trailing;
  MobjListTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.trailing,
  }) : super(key: key);

// class _MobjListTiletate extends State<MobjListTile> {
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
        trailing: trailing,
        //    Icon(Icons.arrow_forward_ios,
        // color: Theme.of(context).colorScheme.primary,
        // size: 20,
        // ) ,
        onTap: onTap);
  }
}
