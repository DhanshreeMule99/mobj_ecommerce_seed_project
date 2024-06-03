import 'dart:convert'; // Add this import for json encoding
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobj_project/utils/api.dart';

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
  String imgLogo = "";

  int splashtime = 3; // Use a short duration for testing, adjust as needed

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    log('Token from Firebase is $token');
    if (token != null) {
      deviceTokenToSendPushNotification = token;
      sendToken(deviceTokenToSendPushNotification);
    }
  }

  void initDynamicLinks() async {
    // Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      handleMyLink(deepLink);
    }
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

  Future<void> sendToken(String token) async {
    try {
      // Replace with your server URL
      const url = '${AppConfigure.adminPanelUrl}/api/devide-informations';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "data": {"token": token}
        }),
      );

      if (response.statusCode == 200) {
        log('Token sent successfully');
      } else {
        log('Failed to send token: ${response.statusCode}, ${response.body}');
      }
    } catch (e, stackTrace) {
      log('Error sending token: $e, $stackTrace');
    }
  }

  Future<void> fetchImgUri() async {
    API api = API();
    final response = await api.sendRequest.get(
        "https://mobj-strapi-admin-panel.onrender.com/api/logos?populate=*",
        options: Options(headers: {"Authorization": ""}));

    if (response.statusCode == 200) {
      log("Response received");
      final responseBody = response.data;
      final logoImagePath = responseBody['data'][0]['attributes']['image']
          ['data']['attributes']['url'];
      // log('Image path: $logoImagePath');
      setState(() {
        imgLogo = logoImagePath;
      });
      await SharedPreferenceManager().setLogoImg(imgLogo);
    } else {
      throw Exception('Failed to load app info');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImgUri();
    getDeviceTokenToSendNotification();
    initDynamicLinks();

    Future.delayed(Duration(seconds: splashtime), () async {
      final jwt = await SharedPreferenceManager().getToken();
      jwt_token = jwt;
      final uid = await SharedPreferenceManager().getUserId();
      final did = await SharedPreferenceManager().getDeviceId();
      userid = uid;

      if (jwt_token == '' || userid == '') {
        Navigator.pushReplacementNamed(context, RouteConstants.onboard);
      } else {
        FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
            if (message != null) {
              LocalNotificationService.createAndDisplayNotification(message);
            }
          },
        );

        FirebaseMessaging.onMessage.listen(
          (message) {
            if (message.notification != null) {
              LocalNotificationService.createAndDisplayNotification(message);
            }
          },
        );

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
            child: FutureBuilder<String>(
              future: SharedPreferenceManager().getLogoImg(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return const Text('Error loading logo');
                } else {
                  final logoImg = snapshot.data ?? '';
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CachedNetworkImage(
                          imageUrl: logoImg,
                          placeholder: (context, url) => Container(
                            height: 200,
                            width: 200,
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ));
  }
}
