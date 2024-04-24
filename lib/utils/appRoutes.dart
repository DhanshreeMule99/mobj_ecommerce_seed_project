// appRoutes

import 'package:flutter/material.dart';
import 'package:mobj_project/module/home/homeScreen.dart';
import 'package:mobj_project/module/onboarding/onboardScreen.dart';
import 'package:mobj_project/module/splash%20screen/Splash_screen.dart';
import 'package:mobj_project/user_auth/login/loginScreen.dart';
import 'package:mobj_project/user_auth/registration/registrationScreen.dart';
import 'package:mobj_project/utils/routeConstant.dart';

import '../user_auth/login/forgotPasswordScreen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    RouteConstants.splash: (BuildContext context) => const SplashScreen(),
    //for login with email and password use below code
    RouteConstants.login: (BuildContext context) => const LoginScreen(),
    //for login with OTP uncomment below code
    // RouteConstants.login: (BuildContext context) => LoginWithOTP(),
    RouteConstants.registration: (BuildContext context) => const RegistrationScreen(),
    //TODO list guest checkout functionality
    // RouteConstants.guestCheckout: (BuildContext context) => const GuestCheckoutScreen(),
    RouteConstants.onboard: (BuildContext context) => const onboardScreen(),
    RouteConstants.forgotPassword: (BuildContext context) => const ForgotPasswordScreen(),
    // RouteConstants.otp: (BuildContext context) => const OtpScreen(),
    RouteConstants.home: (BuildContext context) => const HomeScreen(),
    // RouteConstants.forgotPassword: (BuildContext context) => forgotPasswordScreen(),

  };
}
