// Splash_screen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

final str = StateProvider((ref) => 0);

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String deviceTokenToSendPushNotification = "";
  String jwt_token = "";
  String userid = "";

  int splashtime = 3;

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
  }

  void initDynamicLinks() async {
    // Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      // ref.read(str.notifier).state++;

      handleMyLink(deepLink);
      // Navigator.pushNamed(context, deepLink.path);
    }
    //TODO list share product

    // FirebaseDynamicLinks.instance.onLink.listen(
    //       (pendingDynamicLinkData) {
    //     // Set up the `onLink` event listener next as it may be received here
    //     if (pendingDynamicLinkData != null) {
    //       final Uri deepLink = pendingDynamicLinkData.link;
    //       print("deepLink $deepLink");
    //       handleMyLink(deepLink);
    //       // Example of using the dynamic link to push the user to a different screen
    //       // Navigator.pushNamed(context, deepLink.path);
    //     }
    //   },
    // );
  }

  void handleMyLink(Uri url) {
    String itemId = url.queryParameters["itemIds"] ?? "";

    ref.read(str.notifier).state++;
    ref.read(str.notifier).state++;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          uid: itemId,
        ),
      ),
    );
  }

  @override
  @protected
  @mustCallSuper
  void initState() {
    getDeviceTokenToSendNotification();
    //TODO list firebase setup
    // Future.delayed(Duration.zero, () {
    //   FirebaseMessaging.instance.getInitialMessage().then(
    //     (message) {
    //       if (message != null) {
    //         ref.read(str.notifier).state++;
    //         if (message.notification != null) {
    //           if (message.data['nid'] != null) {
    //             Navigator.of(context).pushReplacement(
    //               MaterialPageRoute(
    //                 builder: (context) => Vounteer_job_apply_screen(
    //                     message.data['nid'],
    //                     msg: "yes"),
    //               ),
    //             );
    //           }
    //         }
    //       }
    //     },
    //   );
    //
    initDynamicLinks();
    Future.delayed(Duration(seconds: splashtime), () async {
      final jwt = await SharedPreferenceManager().getToken();
      jwt_token = jwt;
      final uid = await SharedPreferenceManager().getUserId();
      final did = await SharedPreferenceManager().getDeviceId();
      userid = uid;
      if (jwt_token == '' || userid == '') {
        //TODO list guest checkout

        // if (did.toString() == '0') {
        //   Navigator.pushReplacementNamed(context,
        //       RouteConstants.onboard);
        // }
        // else {
        //   Navigator.pushReplacementNamed(context,
        //       RouteConstants.guestCheckout);
        // }
        Navigator.pushReplacementNamed(context, RouteConstants.onboard);
      } else {
        // 1. This method call when app in terminated state and you get a notification
        // when you click on notification app open from terminated state and you can get notification data in this method

        FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
            if (message != null) {
              LocalNotificationService.createAndDisplayNotification(message);

              // if (message.data['_id'] != null) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => DemoScreen(
              //         id: message.data['_id'],
              //       ),
              //     ),
              //   );
              // }
            }
          },
        );

        // 2. This method only call when App in forground it mean app must be opened
        FirebaseMessaging.onMessage.listen(
          (message) {
            if (message.notification != null) {
              LocalNotificationService.createAndDisplayNotification(message);
            }
          },
        );

        // 3. This method only call when App in background and not terminated(not closed)
        FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
            LocalNotificationService.createAndDisplayNotification(message);

            if (message.notification != null) {}
          },
        );

        Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const HomeScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
            (route) => route.isCurrent);
      }
    });
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
        upgrader: Upgrader(
            durationUntilAlertAgain: const Duration(days: 3),
            shouldPopScope: () => true,
            canDismissDialog: true),
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: Consumer(
              builder: (context, watch, child) {
                final appInfoAsyncValue = ref.watch(appInfoProvider);
                return appInfoAsyncValue.when(
                  data: (appInfo) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //vertically align center
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: CachedNetworkImage(
                            imageUrl: appInfo.logoImagePath,
                            placeholder: (context, url) => Container(
                              height: 200,
                              width: 200,
                              color: AppColors.greyShade200,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ]),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => const Text(AppString.oops),
                );
              },
            ),
          ),
        ));
  }
}
