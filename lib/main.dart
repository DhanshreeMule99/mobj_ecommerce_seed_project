import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobj_project/utils/appConfiguer.dart';
import 'package:mobj_project/utils/appRoutes.dart';
import 'package:mobj_project/utils/themeProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'module/notificationservice/notificationservice.dart';
import 'module/splash screen/Splash_screen.dart';
import 'utils/appColors.dart';

final providerContainer = ProviderContainer();
List<Map<String, dynamic>> bigcommerceOrderedItems = [];
Map<String, dynamic>? woocommerceaddressbody;
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
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        // for web app
        useInheritedMediaQuery: true, //for keyboard not overlapp
        // //designSize: const Size(1080, 1920), //for android application
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
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
                      // unselectedWidgetColor: Colors.black,
                      useMaterial3: true,
                      colorScheme: lightColorScheme,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      textTheme: TextTheme(
                        headlineLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.black,
                          fontSize: 14.sp,
                        ),
                        headlineMedium: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: ConstColors.black,
                          fontSize: 12.sp,
                        ),
                        headlineSmall: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: ConstColors.black,
                          fontSize: 10.sp,
                        ),
                        bodyLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.black,
                          fontSize: 14.sp,
                        ),
                        bodyMedium: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: ConstColors.black,
                            fontSize: 14.sp,
                            ),
                        bodySmall: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.darkGrey,
                          fontSize: 18.sp,
                        ),
                        titleLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.black,
                          fontSize: 18.sp,
                        ),
                        titleMedium: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.darkGrey,
                          fontSize: 12.sp,
                        ),
                        titleSmall: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: ConstColors.darkGrey,
                          fontSize: 10.sp,
                        ),
                        displayLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.backgroundColor,
                          fontSize: 14.sp,
                        ),
                        displayMedium: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: ConstColors.purple,
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: ConstColors.purple),
                        displaySmall: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: ConstColors.purple,
                        ),
                      )
                      // brightness: Brightness.light,
                      // colorSchemeSeed: Colors.blue,
                      )
                  : ThemeData(
                      // unselectedWidgetColor: Colors.white,
                      useMaterial3: true, colorScheme: darkColorScheme,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      textTheme: TextTheme(
                        headlineLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.lightGrey,
                          fontSize: 14.sp,
                        ),
                        headlineMedium: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: ConstColors.lightGrey,
                          fontSize: 12.sp,
                        ),
                        headlineSmall: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: ConstColors.lightGrey,
                          fontSize: 10.sp,
                        ),
                        bodyLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.lightGrey,
                          fontSize: 14.sp,
                        ),
                        bodyMedium: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: ConstColors.lightGrey,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: ConstColors.lightGrey),
                        bodySmall: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.lightGrey,
                          fontSize: 18.sp,
                        ),
                        titleLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.lightGrey,
                          fontSize: 14.sp,
                        ),
                        titleMedium: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.lightGrey,
                          fontSize: 12.sp,
                        ),
                        titleSmall: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: ConstColors.lightGrey,
                          fontSize: 10.sp,
                        ),
                        displayLarge: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: ConstColors.black,
                          fontSize: 13.sp,
                        ),
                        displayMedium: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            color: ConstColors.purple,
                            fontSize: 13.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: ConstColors.purple),
                        displaySmall: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: ConstColors.purple,
                        ),
                      ),
                      // brightness: Brightness.dark,
                      // colorSchemeSeed: Colors.blue,
                    ),
              home: const SplashScreen(),
              routes: AppRoutes.routes);
        });
  }
}
