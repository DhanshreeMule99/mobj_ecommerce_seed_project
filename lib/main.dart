import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobj_project/services/shopifyServices/graphQLServices/graphQlRespository.dart';
import 'package:mobj_project/utils/appConfiguer.dart';
import 'package:mobj_project/utils/appString.dart';
import 'package:mobj_project/utils/appRoutes.dart';
import 'package:mobj_project/utils/themeProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'models/constants/APIConstants.dart';
import 'module/notificationservice/notificationservice.dart';
import 'module/splash screen/Splash_screen.dart';
import 'utils/appColors.dart';

final providerContainer = ProviderContainer();
List<Map<String, dynamic>> bigcommerceOrderedItems = [];
Future<void> backgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51OwL4aSJobhEaXflptPiW116kXpb4PYnk2RbCEtDiO2ywbv36ur3AU11jm3bSi9oXxPvxmhQtjalohUSOqdZRHwF00zIDjfsXZ";
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //TODO wake lock
  // Wakelock.enable();
  runApp(
    const ProviderScope(
      child: MyHomePage(),
    ),
  );
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themes = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        title: AppConfigure.appName,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(language),
        theme: themes == false
            ? ThemeData(
                // Set the default colors for the light theme
                brightness: Brightness.light,
                iconTheme: const IconThemeData(color: AppColors.blackColor),
                appBarTheme: const AppBarTheme(
                    color: Colors.white,
                    iconTheme: IconThemeData(color: AppColors.blackColor), // 1

                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight
                            .bold) // Set your AppBar color for light mode
                    ),
                bottomAppBarTheme: const BottomAppBarTheme(
                  color: Colors.white, // Set your AppBar color for light mode
                ),
              )
            : ThemeData.dark(),
        home: const SplashScreen(),
        routes: AppRoutes.routes);
  }
}
